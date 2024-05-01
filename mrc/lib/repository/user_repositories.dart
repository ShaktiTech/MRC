import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  String verificationId = "";
  int? forceResendingToken;
//
  UserRepository({required this.firebaseAuth});

  //******* Sign Up with email and password ********/

  Future<User?> signUp(
      String email, String password, String phone, String name) async {
    try {
      var auth = await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      final firestore = FirebaseFirestore.instance;
      firestore.collection('users').doc(auth.user!.uid).set(
          {"email": email, "password": password, "phone": phone, "name": name});
      if (auth.user != null) {
        saveData(auth.user!, "EMAIL");
      }

      return auth.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == "weak-password") {
        throw Exception("Password is too weak");
      } else if (e.code == "email-already-in-use") {
        throw Exception("Account already exist for this email address");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  //******* Login with email and password ********/

  Future<User?> signIn(String email, String password) async {
    try {
      var auth = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      if (auth.user != null) {
        saveData(auth.user!, "EMAIL");
      }

      return auth.user;
    } on FirebaseAuthException catch (e) {
      rethrow;
    } catch (e) {
      print(e.toString());
    }
  }

  //******* Change password ********/

  Future<bool?> changePassword(
      String email, String password, String newPassword) async {
    try {
      bool value = false;
      print("SSS Firebase Cred ${email} --- ${password}");
      var cred = EmailAuthProvider.credential(email: email, password: password);
      print("SSS Firebase Cred ${cred}");
      if (cred.accessToken != null) {
        print("SSS Firebase Error 223 ${cred}");
        value = await firebaseAuth.currentUser!
            .reauthenticateWithCredential(cred)
            .then((value) {
          firebaseAuth.currentUser!.updatePassword(newPassword);
          return true;
        }).onError((error, stackTrace) {
          print("SSS Firebase Error ${error.toString()}");
          return false;
        });
      } else {
        value = false;
      }
      return value;
    } on FirebaseAuthException catch (e) {
      rethrow;
    } catch (e) {
      print(e.toString());
    }
  }

//******** Update Profile ************/

  Future<bool> updateProfile(
      String name, String email, String phone, String image) async {
    var completer = Completer<bool>();
    bool isDone = false;
    try {
      var currentUser = await firebaseAuth.currentUser;
      final firestore = FirebaseFirestore.instance;

      if (image.isNotEmpty) {
        firestore.collection('users').doc(currentUser!.uid).set({
          "email": email,
          "name": name,
          "phone": phone,
          "image": image
        }).then((value) {
          saveProfile(email, phone, name);
          isDone = true;
          completer.complete(true);
        }).onError((error, stackTrace) {
          isDone = false;
        });
      } else {
        firestore
            .collection('users')
            .doc(currentUser!.uid)
            .set({"email": email, "name": name, "phone": phone}).then((value) {
          saveProfile(email, phone, name);
          isDone = true;
          completer.complete(true);
        }).onError((error, stackTrace) {
          isDone = false;
        });
      }

      return await completer.future ? isDone : false;
    } on FirebaseAuthException catch (e) {
      rethrow;
    } catch (e) {
      return false;
    }
  }

  //******* Forgot password ********/
  Future<bool> forgotPassword(String email) async {
    try {
      var value = await firebaseAuth
          .sendPasswordResetEmail(email: email)
          .then((value) => true);
      return value;
    } on FirebaseAuthException catch (e) {
      rethrow;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  //******* SignOut ********/

  Future<void> signOut() async {
    print("SSS Is Signed Out 1");
    await firebaseAuth.signOut();

    print("SSS Is Signed Out");
    final SharedPreferences s = await SharedPreferences.getInstance();
    s.clear();
  }

  //******* check Sign In ********/
  Future<bool> isSignedIn() async {
    var currentUser = await firebaseAuth.currentUser;
    print("Is Signed in ${currentUser}");
    return currentUser != null;
  }

  //******* get current user ********/

  Future<User?> getCurrentUser() async {
    return await firebaseAuth.currentUser;
  }

  //******* Sign in with Google ********/

  Future<User?> signInWithGoogle() async {
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      // executing our authentication
      try {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        // signing to firebase user instance
        final User userDetails =
            (await firebaseAuth.signInWithCredential(credential)).user!;

        saveData(userDetails, "GOOGLE");
        return userDetails;
        // now save all values
        // _name = userDetails.displayName;
        // _email = userDetails.email;
        // _imageUrl = userDetails.photoURL;
        // _provider = "GOOGLE";
        // _uid = userDetails.uid;
        // notifyListeners();
      } on FirebaseAuthException catch (e) {
        if (e.code == "account-exists-with-different-credential") {
          throw Exception(
              "You already have an account with us. Use correct provider");
        } else if (e.code == "null") {
          throw Exception("Some unexpected error while trying to sign in");
        }
      } catch (e) {
        throw Exception(e.toString());
      }
    } else {
      return null;
      //Todo
    }
  }

  //******* Send Otp ********/

//   Future<void> sendCode(String mobile) async {

//       try{
//          FirebaseAuth.instance.verifyPhoneNumber(
//           phoneNumber: mobile,
//           verificationCompleted: (AuthCredential credential) async {
//             await FirebaseAuth.instance.signInWithCredential(credential);
//           },
//           verificationFailed: (FirebaseAuthException e) {
//             // openSnackbar(context, e.toString(), Colors.red);
//           },
//           codeSent: (String verificationIds, int? forceResendingTokens) {
//             verificationId = verificationIds;
//             forceResendingToken = forceResendingTokens;
//           },
//           codeAutoRetrievalTimeout: (String verification) {});
// //  await FirebaseAuth.instance.verifyPhoneNumber(
// //           phoneNumber: mobile,
// //           verificationCompleted: (AuthCredential credential) async {
// //             await FirebaseAuth.instance.signInWithCredential(credential);

// //           },
// //           verificationFailed: (FirebaseAuthException e) {

// //           },
// //           codeSent: (String verificationIds, int? forceResendingTokens) {
// //             verificationId = verificationIds;
// //             forceResendingToken = forceResendingTokens;

// //           },
// //           codeAutoRetrievalTimeout: (String verification) {});

// //       return verificationId;
//       } on FirebaseAuthException catch (e) {
//       rethrow;}
//       catch(e)
//     {

//       print(e);
//       //throw Exception(e.toString());
//      // return false;
//     }

//   }

//   //******* verify Otp ********/

// Future<User?> verify(String code) async {
//     // AuthCredential authCredential = PhoneAuthProvider.credential(
//     //     verificationId: verificationId, smsCode: code);
//     // try {
//     //   User user =
//     //       (await FirebaseAuth.instance.signInWithCredential(authCredential))
//     //           .user!;
//     //           saveData(user,"PHONE");
//     //           return user;
//     //   // saveDataToSharedPreferences().then((value) => setSignIn().then((value) {
//     //   //       otpController.success();
//     //   //       Get.offNamed('home');
//     //   //     }));
//     // }
//      AuthCredential authCredential = await PhoneAuthProvider.credential(
//         verificationId: verificationId, smsCode: code);
//     try {
//       print("Phone auth 2 ${authCredential}");
//        if(authCredential.accessToken !=null)
//        {
//         print("Phone auth 1 ${authCredential}");
//           User user =
//           (await FirebaseAuth.instance.signInWithCredential(authCredential))
//               .user!;
//               print("Phone auth 3 ${user}");
//      saveData(user,"PHONE");
//       return user;
//        }

//     }
//     on FirebaseAuthException catch (e) {

//       rethrow;
//       } catch(e)
//     {
//       throw Exception(e.toString());
//     }

//   }

//************ Save Data to prefrence */
  void saveData(User user, String provider) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("userID", user.uid);
    prefs.setString("provider", provider);
    if (user.email != null) {
      prefs.setString("userEmail", user.email!);
    }
    if (user.phoneNumber != null) {
      prefs.setString("userPhone", user.phoneNumber!);
    }
    if (user.displayName != null) {
      prefs.setString("userName", user.displayName!);
    }
    if (user.photoURL != null) {
      prefs.setString("userProfileImg", user.photoURL!);
    }
  }

//********** Check Internet ***********/
  Future<bool> checkInternetConnection() async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      return false;
    } else {
      return true;
    }
  }

  Future<User?> verify(String code, String vId) async {
    print("Verification Id 2 ${vId}");
    AuthCredential authCredential =
        PhoneAuthProvider.credential(verificationId: vId, smsCode: code);
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(authCredential);
      saveData(userCredential.user!, "PHONE");
      print("USer Phone ${userCredential.user}");
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      rethrow;
    } catch (e) {
      print("CODE Error ${e}");
      return null;
    }
  }

  Future<String> sendCode(String mobile) async {
    var completer = Completer<bool>();
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: mobile,
          verificationCompleted: (AuthCredential credential) async {
            await FirebaseAuth.instance.signInWithCredential(credential);
          },
          verificationFailed: (FirebaseAuthException e) {
            // openSnackbar(context, e.toString(), Colors.red);
          },
          codeSent: (String verificationIds, int? forceResendingTokens) {
            verificationId = verificationIds;
            print("Verification Id 1 ${verificationIds}");
            forceResendingToken = forceResendingTokens;
            completer.complete(true);
          },
          codeAutoRetrievalTimeout: (String verification) {});
      return await completer.future ? verificationId : "";
    } on FirebaseAuthException catch (e) {
      rethrow;
    } catch (e) {
      print("CODE Error ${e}");
      return "";
    }
  }

  Future<String> uploadImage(ImageSource source) async {
    String imageUrl = "";
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image != null) {
        File? img = File(image.path);
        img = await cropImage(imageFile: img);
        String uniqueFileName =
            DateTime.now().millisecondsSinceEpoch.toString();
        if (img != null) {
          Reference referenceRoot = FirebaseStorage.instance.ref();
          Reference referenceDirImages = referenceRoot.child('profile_images');

          //Create a reference for the image to be stored
          Reference referenceImageToUpload =
              referenceDirImages.child(uniqueFileName);

          //Handle errors/success

          //Store the file
          await referenceImageToUpload.putFile(File(img.path));

          imageUrl = await referenceImageToUpload.getDownloadURL();
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("userProfileImg", imageUrl);
          print("Upload Image 111 ${imageUrl}");
        }
      }

      return imageUrl;
    } on PlatformException catch (e) {
      print(e);
      return "";
    }
  }

  Future<File?> cropImage({required File imageFile}) async {
    CroppedFile? croppedImage =
        await ImageCropper().cropImage(sourcePath: imageFile.path);
    if (croppedImage == null) return null;
    return File(croppedImage.path);
  }
}

void saveProfile(String email, String phone, String name) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("userEmail", email);
  prefs.setString("userPhone", phone);
  prefs.setString("userName", name);
}
