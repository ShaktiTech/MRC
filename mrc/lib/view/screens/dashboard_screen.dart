import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrc/bloc/report_bloc/report_bloc.dart';
import 'package:mrc/model/report_model.dart';
import 'package:mrc/utils/error_snackbar.dart';

import '../../bloc/drawer_bloc/drawer_bloc.dart';
import '../../model/station_model.dart';
import '../../repository/user_repositories.dart';
import '../../utils/mycolor.dart';
import 'drawer_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<ReportModel> reportList = [];
  List<StationModel> station = [
    StationModel("Chiang Saen", "Chiang Saen", false, "thailand"),
    StationModel("Chiang Khan", "Chiang Khan", false, "thailand"),
    StationModel("Nong Khai", "Nong Khai", false, "thailand"),
    StationModel("Nakhon Phanom", "Nakhon Phanom", false, "thailand"),
    StationModel("Mukdahan", "Mukdahan", false, "thailand"),
    StationModel("Khong Chiam", "Khong Chiam", false, "thailand"),
    StationModel("Tan Chau", "Tan Chau", false, "vietnam"),
    StationModel("Chau Doc", "Chau Doc", false, "vietnam"),
    StationModel("Stung Treng", "Stung Treng", false, "cambodia"),
    StationModel("Kratie", "Kratie", false, "cambodia"),
    StationModel("Kompong Cham", "Kompong Cham", false, "cambodia"),
    StationModel(
        "Phnom Penh (Bassac)", "Phnom Penh (Bassac)", false, "cambodia"),
    StationModel("Phnom Penh Port", "Phnom Penh Port", false, "cambodia"),
    StationModel("Koh Khel (Bassac)", "Koh Khel (Bassac)", false, "cambodia"),
    StationModel("Neak Luong", "Neak Luong", false, "cambodia"),
    StationModel(
        "Prek Kdam (Tonle Sap)", "Prek Kdam (Tonle Sap)", false, "cambodia"),
    StationModel("Luang Prabang", "Luang Prabang", false, "laodpr"),
    StationModel("Vientiane", "Vientiane", false, "laodpr"),
    StationModel("Paksane", "Paksane", false, "laodpr"),
    StationModel("Thakhek", "Thakhek", false, "laodpr"),
    StationModel("Savannakhet", "Savannakhet", false, "laodpr"),
    StationModel("Pakse", "Pakse", false, "laodpr"),
  ];

  List<StationModel> selectedStation = [];
  bool _isDiaLoading = false;

  @override
  void initState() {
    super.initState();
    print("sss INit 1");
    BlocProvider.of<ReportBloc>(context).add(GetDataEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        title: Text(
          "iReport community",
          style: GoogleFonts.openSans(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: MyColor.kPrimaryGradient,
          ),
        ),
        // actions: [
        //   IconButton(
        //       onPressed: () {
        //         Get.toNamed('/profile');
        //       },
        //       icon: const Icon(Icons.settings)),
        // ],
      ),
      body: SafeArea(
        child: BlocBuilder<ReportBloc, ReportState>(
          builder: (context, state) {
            if (state is ReportLoadedState) {
              reportList = state.reportList;
              return Container(
                child: Column(
                  children: [
                    //  Align(
                    //   alignment: Alignment.centerLeft,
                    //    child: Padding(
                    //      padding: const EdgeInsets.fromLTRB(18.0,20.0,10.0,0),
                    //      child: Text("Choose station",style: GoogleFonts.openSans(
                    //           color: Colors.black,
                    //           fontWeight: FontWeight.bold,
                    //           fontSize: 30.0,

                    //         )

                    //         ,),
                    //    ),
                    //  ),
                    //     SizedBox(height: 20,),
                    Expanded(
                      child: ListView.builder(
                          itemCount: reportList.length, //station.length,
                          itemBuilder: (BuildContext context, int index) {
                            // return item
                            // return ContactItem(
                            //   station[index].name,
                            //   station[index].phoneNumber,
                            //   station[index].isSelected,
                            //   index,
                            // );
                            return ContactItem(
                              reportList[index].incidentType,
                              reportList[index].location,
                              reportList[index].image,
                              //  reportList[index].userName,
                              //   reportList[index].userImage,
                              reportList[index].description,
                              reportList[index].userName,
                              reportList[index].userImage,
                              reportList[index].userEmail,
                              reportList[index].userPhone,
                              index,
                            );
                          }),
                    ),
                    selectedStation.length > 0
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 25,
                              vertical: 10,
                            ),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                //color: Colors.green[700],
                                child: Text(
                                  "Save (${selectedStation.length})",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                                onPressed: () {
                                  //  print("Delete List Lenght: ${selectedStation.length}");
                                },
                              ),
                            ),
                          )
                        : Container(),
                  ],
                ),
              );
            } else if (state is ReportLoading) {
              return Center(child: CircularProgressIndicator());
            } else {
              return Container();
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed('/ireport');
        },
        child: Container(
          width: 60,
          height: 60,
          child: Icon(
            Icons.add,
            size: 40,
          ),
          decoration: BoxDecoration(
              shape: BoxShape.circle, gradient: MyColor.kPrimaryGradient),
        ),
      ),
    );
  }

  // Widget ContactItem(
  //     String name, String phoneNumber, bool isSelected, int index) String userName,String userImage,
  Widget ContactItem(
      String incidentType,
      String location,
      String image,
      String description,
      String userName,
      String userImage,
      String userEmail,
      String userPhone,
      int index) {
    return Container(
      margin: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
      child: Column(
        children: [
          Card(
            elevation: 3,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  visualDensity: VisualDensity(horizontal: -4, vertical: 0),
                  leading: CircleAvatar(
                    radius: 22,
                    backgroundColor: MyColor.primaryColor,
                    child: userImage.isEmpty
                        ? CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.white,
                            backgroundImage: AssetImage('assets/avatar.png'))
                        : CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.white,
                            backgroundImage: NetworkImage(userImage),
                          ),
                  ),
                  title: Text(
                    getText(userName, userEmail,
                        userPhone), //userName.isEmpty ? userEmail : userName,
                    textAlign: TextAlign.left,
                    style: GoogleFonts.openSans(
                      color: MyColor.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                    ),
                  ),
                  subtitle: Text(
                    "${incidentType}",
                    style: GoogleFonts.openSans(
                      color: MyColor.textligth,
                      fontSize: 12.0,
                    ),
                  ),
                  trailing: image.isNotEmpty
                      ? Text(
                          "View Image",
                          style: GoogleFonts.openSans(
                            color: MyColor.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 8.0,
                          ),
                        )
                      : Icon(
                          Icons
                              .image_not_supported_rounded, //   Icons.more_vert,
                          color: Colors.white,
                        ),
                  onTap: () {
                    if (image.isEmpty) {
                      //  ErrorSnackBar().showToastWithIcon("No Preview",
                      //     "Image not available", const Icon(Icons.image));

                      return;
                    } else {
                        showImage(context, image);
                      // setState(() {
                       // _isDiaLoading = true;
                      
                        // Timer(Duration(seconds: 2), () {
                        //   setState(() {
                        //     _isDiaLoading = false;
                        //   });
                        // });
                        
                      // });
                    }
                  },
                  // isSelected
                  //     ? Icon(
                  //         Icons.check_circle,
                  //         color: Colors.green[700],
                  //       )
                  //     : Icon(
                  //         Icons.check_circle_outline,
                  //         color: Colors.grey,
                  //       ),
                  //  onTap: () {
                  // setState(() {
                  //   station[index].isSelected = !station[index].isSelected;
                  //   if (station[index].isSelected == true) {
                  //     selectedStation.add(StationModel(name, phoneNumber, true,"flag"));
                  //   } else if (station[index].isSelected == false) {
                  //     selectedStation
                  //         .removeWhere((element) => element.name == station[index].name);
                  //   }
                  // });
                  //  },
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 20.0),
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          "${description}", //"Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit. Exercitation veniam consequat sunt nostrud amet.",
                          overflow: TextOverflow.visible,
                          textAlign: TextAlign.justify,
                          style: GoogleFonts.openSans(
                            color: MyColor.kBlackColor,
                            //  fontWeight: FontWeight.bold,

                            fontSize: 11.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    TextButton.icon(
                      // <-- TextButton
                      onPressed: () {},
                      icon: Icon(
                        Icons.thumb_up_outlined,
                        color: MyColor.textligth,
                        size: 18.0,
                      ),
                      label: Text(
                        "Yes",
                        style: GoogleFonts.openSans(
                          color: MyColor.textligth,
                          fontWeight: FontWeight.bold,
                          fontSize: 10.0,
                        ),
                      ),
                    ),
                    // SizedBox(width: 20,),
                    TextButton.icon(
                      // <-- TextButton
                      onPressed: () {},
                      icon: Icon(
                        Icons.thumb_down_outlined,
                        color: MyColor.textligth,
                        size: 18.0,
                      ),
                      label: Text(
                        "No",
                        style: GoogleFonts.openSans(
                          color: MyColor.textligth,
                          fontWeight: FontWeight.bold,
                          fontSize: 10.0,
                        ),
                      ),
                    ),
                    // SizedBox(width: 20,),
                    TextButton.icon(
                      // <-- TextButton
                      onPressed: () {},
                      icon: Icon(
                        Icons.share,
                        color: MyColor.textligth,
                        size: 18.0,
                      ),
                      label: Text(
                        "Share",
                        style: GoogleFonts.openSans(
                          color: MyColor.textligth,
                          fontWeight: FontWeight.bold,
                          fontSize: 10.0,
                        ),
                      ),
                    ),
                    //SizedBox(width: 20,),
                    Flexible(
                      child: TextButton.icon(
                        // <-- TextButton
                        onPressed: () {},
                        icon: Icon(
                          Icons.comment,
                          color: MyColor.textligth,
                          size: 18.0,
                        ),
                        label: Text(
                          "Comment",
                          style: GoogleFonts.openSans(
                            color: MyColor.textligth,
                            fontWeight: FontWeight.bold,
                            fontSize: 10.0,
                          ),
                        ),
                      ),
                    ),
                    //  SizedBox(width: 20,),
                  ],
                ),
                SizedBox(
                  height: 5,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void showImage(context, path) {
    showDialog<AlertDialog>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.all(10),
            actions: <Widget>[
             Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              child: Text('Close'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      MyColor.primaryColor),
                                  textStyle: MaterialStateProperty.all(
                                      TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold))),
                            ),
                          ],
                        ),
                        Container(
                          width: double.infinity,
                          height: 220,
                          child: InteractiveViewer(
                            clipBehavior: Clip.none,
                            panEnabled: false,
                            minScale: 1,
                            maxScale: 4,
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image.network(
                                  '$path',
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            ],
          );
        });
  }

  String getText(String userName, String userEmail, String userPhone) {
    if (userName.isNotEmpty) {
      return userName;
    } else if (userEmail.isNotEmpty) {
      return userEmail;
    } else {
      return userPhone;
    }
  }
}
