import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mrc/model/report_model.dart';

class ReportRepository {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  
  ReportRepository({required this.firebaseAuth});

  Future<List<ReportModel>> getReport() async{
    List<ReportModel> reportList =[];
    try{
      final fireCloud = await FirebaseFirestore.instance.collection("iReport").orderBy("createdAt", descending: true).get();
      fireCloud.docs.forEach((element) {
         print("get Data SSS  ${element.data()}");
        return reportList.add(ReportModel.fromJson(element.data()));
      });
     return reportList;
    } on FirebaseException catch(e)
    {
          print("get Data SSS error Firebase ${e}");
      return reportList;
    }
    catch(e)
    {
       print("get Data SSS error 3 ${e}");
    throw Exception(e.toString());
    }
  }




  Future<bool> addReport(String latLong, String incidentType,
      String description, String imageUrl,String userId,String userName, String userImage,String userEmail,String userPhone) async {
         var completer = Completer<bool>();
    bool value =false;
    Map<String, String> data = {
      'location': latLong,
      'description': description,
      'incidentType': incidentType,
      'image': imageUrl,
      'userId': userId,
      'createdAt':  DateTime.now().millisecondsSinceEpoch.toString(),
      'userName':userName,
      'userImage':userImage,
      'userEmail':userEmail,
      'userPhone':userPhone
    };
    try {
      CollectionReference reference =
          FirebaseFirestore.instance.collection('iReport');
  await reference.add(data).whenComplete(() { value=true;
   completer.complete(true);
   } );
      return value;
    } catch (e) {
      rethrow;
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
          Reference referenceDirImages = referenceRoot.child('images');

          //Create a reference for the image to be stored
          Reference referenceImageToUpload =
              referenceDirImages.child(uniqueFileName);

          //Handle errors/success

          //Store the file
          await referenceImageToUpload.putFile(File(img.path));

          imageUrl = await referenceImageToUpload.getDownloadURL();
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
