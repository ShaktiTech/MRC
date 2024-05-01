import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mrc/bloc/report_bloc/report_bloc.dart';
import 'package:mrc/utils/alert_dialoge.dart';
import 'package:mrc/utils/error_snackbar.dart';
import 'package:mrc/utils/mycolor.dart';
import 'package:mrc/utils/success_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../widgets/re_usable_select_photo_button.dart';

class IreportScreen extends StatefulWidget {
  IreportScreen({super.key});

  @override
  State<IreportScreen> createState() => _IreportScreenState();
}

class _IreportScreenState extends State<IreportScreen> {
  TextEditingController _locationController = TextEditingController();

  TextEditingController _descriptionController = TextEditingController();

  late ReportBloc reportBloc;

  String userImg = "";

  String userId = "";
  String userLocation = "";
  String userLate = "";
  String userLong = "";
  var userName = "";
  var userPhone = "";
  var userProfile = "";
  var userEmail = "";
  bool _isEnable = false;

  CollectionReference _reference =
      FirebaseFirestore.instance.collection('report_list');

  List dropDownListData = [
    {"title": "Accident", "value": "Accident"},
    {"title": "Drought", "value": "Drought"},
    {"title": "Fisheries", "value": "Fisheries"},
    {"title": "Flood", "value": "Flood"},
  ];

  String defaultValue = "";

  Future<void> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    userId = prefs.getString("userID")!;
    userLocation = prefs.getString("userLocation") ?? '----';
    userLate = prefs.getString("userLatitude") ?? '----';
    userLong = prefs.getString("userLongitude") ?? '----';
    userEmail = prefs.getString("userEmail") ?? '';
    userName = prefs.getString("userName") ?? '';
    userPhone = prefs.getString("userPhone") ?? '';
    userProfile = prefs.getString("userProfileImg") ?? '';
    // userEmail = "SSS";
  }

  @override
  Widget build(BuildContext context) {
    reportBloc = BlocProvider.of<ReportBloc>(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Sizer(builder: (context, orientation, device) {
      return FutureBuilder<void>(
          future: getUser(), // <-- your future
          builder: (context, snapshot) {
            return Scaffold(
              extendBodyBehindAppBar: true,
              // drawer: RepositoryProvider(
              //   create: (context) => UserRepository(firebaseAuth: FirebaseAuth.instance),
              //   child: BlocProvider(
              //     create: (context) => DrawerBloc(userRepository: context.read<UserRepository>()),
              //     child: Padding(
              //       padding: const EdgeInsets.fromLTRB(0, 55, 0, 0),
              //       child:  DrawerScreen(),
              //     ),
              //   ),
              // ),
              appBar: AppBar(
                title: Text('iReport incident'),
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              body: SingleChildScrollView(
                  child: Container(
                      child: Column(
                children: [
                  Container(
                    width: screenWidth,
                    height:
                        SizerUtil.deviceType == DeviceType.tablet ? 40.h : 40.h,
                    decoration: const BoxDecoration(
                      gradient: MyColor.kPrimaryGradient,
                      // color: MyColor.primaryColor,
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

                        BlocConsumer<ReportBloc, ReportState>(
                          listener: (context, state) {
                            if (state is ImageUploadedSuccess) {
                              userImg = state.imgUrl;
                              print("Upload Image 113 ${userImg}");
                            }
                            if (state is IncidentSelectedState) {
                              defaultValue = state.incidentType;
                            }
                          },
                          builder: (context, state) {
                            if (state is ReportLoading) {
                              return Center(child: CircularProgressIndicator());
                            }
                            return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircleAvatar(
                                  radius: 60.0,
                                  backgroundColor: Colors.white,
                                  backgroundImage: (userImg == null ||
                                          userImg.isEmpty)
                                      ? const AssetImage('assets/uploadimg.png')
                                          as ImageProvider
                                      : NetworkImage(userImg),
                                  //AssetImage('assets/profile.png') as ImageProvider:NetworkImage(userImg),
                                  //
                                  child: Stack(children: [
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: GestureDetector(
                                        onTap: () {
                                         
                                          _showDialog(context);
                                        },
                                        child: const CircleAvatar(
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
                        Text(
                          "Upload Image",
                          style: GoogleFonts.openSans(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                        SizedBox(
                          height: 10,
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
                        readOnly: true,
                        enabled: false,
                        controller: _locationController..text = "${userLate},${userLong}",//"Latitude : ${userLate} --- Longitude : ${userLong}",
                        // TextEditingController()
                        //   ..text = "Location LatLong",
                        decoration: InputDecoration(
                          labelText: 'Location',

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
                    child: InputDecorator(
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.fromLTRB(10.0, 10.0, 0, 10.0),
                        labelText: 'Incident type',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                            isDense: true,
                            // icon: const ImageIcon(
                            //   AssetImage('assets/droparrow.png'),
                            // ),
                            value: defaultValue,
                            isExpanded: true,
                            // menuMaxHeight: 350,
                            items: [
                              const DropdownMenuItem(
                                  child: Text(
                                    "Select Incident",
                                  ),
                                  value: ""),
                              ...dropDownListData
                                  .map<DropdownMenuItem<String>>((data) {
                                return DropdownMenuItem(
                                    child: Text(data['title']),
                                    value: data['value']);
                              }).toList(),
                            ],
                            onChanged: (value) {
                              if (value!.isNotEmpty) {
                                print("selected Value $value");
                                // reportBloc.add(
                                //     IncidentButtonPressed(incidentType: value));
                                setState(() {
                                  defaultValue = value;
                                });
                              }
                            }),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                    child: SizedBox(
                      height: 150,
                      child: TextFormField(
                        textAlignVertical: TextAlignVertical.top,
                        
                        expands: true,
                        controller: _descriptionController,

                        // minLines: null,
                        maxLines: null,
                        onChanged: (value) {
                          if (value.length > 1) {
                            _isEnable = true;
                          }
                        },
                        keyboardType: TextInputType.multiline,
                        // readOnly: true,
                        // enabled: false,
                        // controller: TextEditingController()..text = "Description",
                        decoration: InputDecoration(
                          labelText:  'Description',
                          alignLabelWithHint: true,
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
                  BlocConsumer<ReportBloc, ReportState>(
                    listener: (context, state) {
                      if (state is ReportSaveSucccess) {
                        _descriptionController.text = "";
                        defaultValue = "";
                        var customDialogWidget = const SuccessDialog();
                        customDialogWidget.showDialogclass(
                            context, "Report", "The incident was submitted successfully.","/forecasting");
                      }
                      if (state is ReportFailure) {
                        var customDialogWidget = CustomDialogWidget();
                        customDialogWidget.showDialogclass(
                            context, "Report Error", "${state.message}");
                      }
                    },
                    builder: (context, state) {
                      if (state is ReportButtonLoading) {
                        return Center(child: CircularProgressIndicator());
                      }
                      return Visibility(
                        visible:
                            true, //(loginType.compareTo("EMAIL")==0 && !loginType.isEmpty)?true:false,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                // maximumSize: const Size(290.0, 40.0),
                                minimumSize: const Size.fromHeight(45),
                                backgroundColor: _isEnable
                                    ? MyColor.primaryColor
                                    : MyColor.lightGrey,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0)),
                              ),
                              onPressed: () {
                                if (_isEnable) {
                                  if (defaultValue.isEmpty) {
                                    ErrorSnackBar().showToastWithIcon(
                                        "Error",
                                        "Please select valid incident type.",
                                        const Icon(Icons.email));

                                    return;
                                  } else {
                                    reportBloc.add(SaveReportButtonPressed(
                                        latLong: _locationController.text,
                                        incidentType: defaultValue,
                                        description:
                                            _descriptionController.text.trim(),
                                        imageUrl: userImg,
                                        userId: userId,
                                        userName: userName,
                                        userImage: userProfile,
                                        userEmail: userEmail,
                                        userPhone:userPhone));
                                  }
                                } else if (defaultValue.isEmpty) {
                                  ErrorSnackBar().showToastWithIcon(
                                      "Error",
                                      "Please select valid incident type.",
                                      const Icon(Icons.email));

                                  return;
                                } else if (_descriptionController
                                    .text.isEmpty) {
                                  ErrorSnackBar().showToastWithIcon(
                                      "Error",
                                      "Enter some description about your report.",
                                      const Icon(Icons.email));

                                  return;
                                } else {
                                  Null;
                                }
                                // Get.toNamed("/changePassword",arguments: {
                                //   "email": userEmail

                                // });
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                //crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Continue",
                                    style: GoogleFonts.openSans(
                                      color: _isEnable
                                          ? Colors.white
                                          : Colors.grey,
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
              ))),
            );
          });
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
                  reportBloc
                      .add(ImageButtonPressed(source: ImageSource.gallery));
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
                  reportBloc
                      .add(ImageButtonPressed(source: ImageSource.camera));
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
