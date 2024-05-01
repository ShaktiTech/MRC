import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mrc/bloc/drawer_bloc/drawer_bloc.dart';
import 'package:mrc/bloc/profile_bloc/profile_bloc.dart';
import 'package:mrc/repository/user_repositories.dart';
import 'package:mrc/utils/mycolor.dart';
import 'package:mrc/view/screens/drawer_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../utils/success_dialog.dart';
import '../widgets/re_usable_select_photo_button.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _image;

  var userEmail = "";

  var userName = "";

  var userPhone = "";

  var userImg = "";
  var loginType = "";
  bool _isUpdateEnable = false;

  late ProfileBloc profileBloc;
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;

  Future<void> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    userEmail = prefs.getString("userEmail") ?? '----';
    userName = prefs.getString("userName") ?? '----';
    userPhone = prefs.getString("userPhone") ?? 'xxxxxxxxxx';
    userImg = prefs.getString("userProfileImg") ?? '';
    loginType = prefs.getString("provider") ?? '';

    _nameController.text = userName;
    _emailController.text = userEmail;
    _phoneController.text = userPhone;
    setState(() {});
    // print("User Image ${userImg}");
    // userEmail = "SSS";
  }

  @override
  void initState() {
    profileBloc = BlocProvider.of<ProfileBloc>(context);
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Sizer(builder: (context, orientation, device) {
      return Scaffold(
        extendBodyBehindAppBar: true,
        drawer: RepositoryProvider(
          create: (context) =>
              UserRepository(firebaseAuth: FirebaseAuth.instance),
          child: BlocProvider(
            create: (context) =>
                DrawerBloc(userRepository: context.read<UserRepository>()),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 55, 0, 0),
              child: DrawerScreen(),
            ),
          ),
        ),
        appBar: AppBar(
          title: Text('Profile'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SingleChildScrollView(
            child: Container(
          child: Column(
            children: [
              Container(
                width: screenWidth,
                height: SizerUtil.deviceType == DeviceType.tablet ? 40.h : 40.h,
                decoration: const BoxDecoration(
                  gradient: MyColor.kPrimaryGradient,
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 40,
                    ),

                    SizedBox(
                      height: 10,
                    ),
                    BlocConsumer<ProfileBloc, ProfileState>(
                      listener: (context, state) {
                        if (state is ProfileImageUploadedSuccess) {
                          userImg = state.imgUrl;
                          print("Upload Image 113 ${userImg}");
                        }
                      },
                      builder: (context, state) {
                        if (state is ProfileLoading) {
                          return Center(child: CircularProgressIndicator());
                        }
                        return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircleAvatar(
                              radius: 60.0,
                              backgroundColor: Colors.white,
                              backgroundImage:
                                  (userImg == null || userImg.isEmpty)
                                      ? AssetImage('assets/avatar.png')
                                          as ImageProvider
                                      : NetworkImage(userImg),
                              child: Stack(children: [
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: GestureDetector(
                                    onTap: () {
                                      print('On Tap Image');
                                      _showDialog(context);
                                    },
                                    child: CircleAvatar(
                                      radius: 18,
                                      backgroundColor:
                                          Color.fromARGB(255, 99, 98, 98),
                                      child: ImageIcon(
                                        AssetImage('assets/camera.png'),
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                            ));
                      },
                    ),
                    // SizedBox(height: 20,),
                  ],
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                child: SizedBox(
                  height: 50,
                  child: TextFormField(
                    readOnly: !_isUpdateEnable,
                    //  enabled: _isNameEnable,
                    //  initialValue: userName,
                    controller: _nameController, //..text = "${userName}",
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      suffixIcon: GestureDetector(
                        onTap: () {
                          _nameController.clear();
                          print('SSS Edit');
                          setState(() {
                            _isUpdateEnable = true;
                          });
                        },
                        child: Icon(Icons.edit),
                      ),
                      fillColor: MyColor.secondPageTitleColor,
                      filled: true,

                      contentPadding: EdgeInsets.all(8.0),
                      // hintText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                child: SizedBox(
                  height: 50,
                  child: TextFormField(
                    //  initialValue: userEmail,
                    readOnly: !_isUpdateEnable,
                    // enabled: _isEmailEnable,
                    controller: _emailController, //..text = "${userEmail}",
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                      suffixIcon: GestureDetector(
                        onTap: () {
                          _emailController.clear();
                          setState(() {
                            _isUpdateEnable = true;
                          });
                        },
                        child: Icon(Icons.edit),
                      ),
                      fillColor: MyColor.secondPageTitleColor,
                      filled: true,

                      contentPadding: EdgeInsets.all(8.0),
                      // hintText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                child: SizedBox(
                  height: 50,
                  child: TextFormField(
                    readOnly: !_isUpdateEnable,
                    // enabled: _isPhoneEnable,
                    //   initialValue: userPhone,
                    controller: _phoneController, //..text = "${userPhone}",
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _phoneController.clear();
                            _isUpdateEnable = true;
                          });
                        },
                        child: Icon(Icons.edit),
                      ),
                      fillColor: MyColor.secondPageTitleColor,
                      filled: true,

                      contentPadding: EdgeInsets.all(8.0),
                      // hintText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Visibility(
                visible:
                    (loginType.compareTo("EMAIL") == 0 && !loginType.isEmpty)
                        ? true
                        : false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        // maximumSize: const Size(290.0, 40.0),
                        minimumSize: const Size.fromHeight(45),
                        backgroundColor: MyColor.primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                      ),
                      onPressed: () {
                        Get.toNamed("/changePassword",
                            arguments: {"email": userEmail});
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        //crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Change Password",
                            style: GoogleFonts.openSans(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                        ],
                      )),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              BlocConsumer<ProfileBloc, ProfileState>(
                listener: (context, state) {
                  if (state is ProfileSuccess) {
                    // _confirmPswdController.text ="";
                    // _newPswdController.text = "";
                    // _oldPswdController.text="";
                    _isUpdateEnable = false;
                    var customDialogWidget = const SuccessDialog();
                    customDialogWidget.showDialogclass(
                        context, "", "Your profile updated successfully.", "");
                  }
                },
                builder: (context, state) {
                  if (state is ProfileDataLoading) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return Visibility(
                    visible: _isUpdateEnable,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            // maximumSize: const Size(290.0, 40.0),
                            minimumSize: const Size.fromHeight(45),
                            backgroundColor: MyColor.primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                          ),
                          onPressed: () {
                            profileBloc.add(UpdateProfilePressed(
                                email: _emailController.text.toString().trim(),
                                name: _nameController.text.toString().trim(),
                                phone: _phoneController.text.toString().trim(),
                                image: userImg));
                            // Get.toNamed("/changePassword",
                            //     arguments: {"email": userEmail});
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            //crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Update",
                                style: GoogleFonts.openSans(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                            ],
                          )),
                    ),
                  );
                },
              ),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        )),
      );
      //app bar theme for tablet
    });
  }

  void _showDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(
              "Chosse an image",
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                  profileBloc.add(
                      ProfileImageButtonPressed(source: ImageSource.gallery));
                },
                icon: Icon(
                  Icons.image,
                  color: Colors.white,
                ),
                label: Text(
                  'Gallery',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: MyColor.primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                  profileBloc.add(
                      ProfileImageButtonPressed(source: ImageSource.camera));
                },
                icon: Icon(
                  Icons.camera_alt_outlined,
                  color: Colors.white,
                ),
                label: Text(
                  'Camera',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: MyColor.primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                ),
              )
            ],
          );
        });
  }
}
