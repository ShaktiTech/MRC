import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrc/bloc/drawer_bloc/drawer_bloc.dart';
import 'package:mrc/utils/mycolor.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../widgets/drawer_header.dart';

class DrawerScreen extends StatelessWidget {
  // DrawerScreen({super.key});

  late DrawerBloc drawerBloc;
    int _isSelected = 2;
     bool isProfileTapped = false;
     bool  isLogoutTapped = false;
  final List drawerMenuListname = const [
    {
      "leading": Icon(
        Icons.dashboard,
        color: Colors.black,
      ),
      "title": "Dashboard",
      "trailing": Icon(
        Icons.chevron_right,
      ),
      "action_id": 1,
    },
     {
      "leading": Icon(
        Icons.map_outlined,
        color: Colors.black,
      ),
      "title": "Map",
      "trailing": Icon(
        Icons.chevron_right,
      ),
      "action_id": 2,
    },
    {
      "leading": ImageIcon(
          AssetImage('assets/moniter.png'),
        color: Colors.black,
      ),
      "title": "Monitoring & forecasting",
      "trailing": Icon(Icons.chevron_right),
      "action_id": 3,
    },

    {
      "leading": ImageIcon(
         AssetImage('assets/personalize.png'),
        color: Colors.black,
      ),
      "title": "Personalize",
      "trailing": Icon(Icons.chevron_right),
      "action_id": 4,
    },
    {
      "leading": ImageIcon(
         AssetImage('assets/ireport.png'),
       color: Colors.black,
      ),
      "title": "iReport",
      "trailing": Icon(Icons.chevron_right),
      "action_id": 5,
    },
  ];
 
    var userEmail = "";

    var userName = "";

    var userPhone = "";
    var userImg = "";
    var provider ="";
 
  Future<void> getUser() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
     
       userEmail = prefs.getString("userEmail") ?? '';
       userName = prefs.getString("userName") ?? '';
      userPhone = prefs.getString("userPhone") ?? 'xxxxxxxxxx';
      userImg = prefs.getString("userProfileImg") ?? '';//provider
      print("User Image ${userImg}");
    // userEmail = "SSS";
    if(userName.isNotEmpty)
    {
       userName = userName;
    }
    else if(userEmail.isEmpty)
    {
      userName = userPhone;
    }
    else
    {
      userName = userEmail;
    }
    
    }
 
  @override
  Widget build(BuildContext context) {
    drawerBloc = BlocProvider.of<DrawerBloc>(context);
      return FutureBuilder<void>(
          future: getUser(), // <-- your future
          builder: (context, snapshot) {
    return SafeArea(
      child: Drawer(
          child: SingleChildScrollView(
        child: Column(
          children: [
            DrawerHeaderView(),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 8, 8),
                  child: Text(
                    "Menu",
                    overflow: TextOverflow.visible,
                    style: GoogleFonts.openSans(
                      color: MyColor.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 13.0,
                    ),
                  ),
                ),
              ],
            ),
            BlocConsumer<DrawerBloc, DrawerState>(
              listener: (context, state) {
                if(state is DrawerDashboardState)
                {
                    Navigator.pop(context);
                     Get.offAllNamed('/home');  // Get.toNamed('/forecasting');
                } if(state is DrawerMoniterState)
                {
                    Navigator.pop(context);
                    Get.offAllNamed('/home');
                 //   Navigator.pushNamed(context, '/forecasting');
    //                Future.delayed(
    //   const Duration(seconds: 2),
    //   () {   
    //   }
    // );
                }
                 if(state is DrawerProfileState)
                {
                    Navigator.pop(context);
                     Get.toNamed('/profile');
                }
                 if(state is DrawerPersonalizeState)
                {
                    Navigator.pop(context);
                    Get.toNamed('/personalize');
                }
                 if(state is DrawerIReportState)
                {
                    Navigator.pop(context);
                     Get.toNamed('/forecasting'); 
                }
                  if(state is DrawerMapState)
                {
                    Navigator.pop(context);
                     Get.toNamed('/map');
                }
                  if(state is DrawerLogoutState)
                {
                     //  Navigator.pop(context);
                  
                   Future.delayed(
      const Duration(seconds: 2),
      () {   
      Get.offAllNamed('/login');
      }
    );
                   // Navigator.pop(context);
               
                }
              },
              builder: (context, state) {

                 if(state is DrawerLogoutState)
                {
                     
                 return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                   children: [
                    SizedBox(height: 100,),
                     Center(child: CircularProgressIndicator(color: MyColor.primaryColor,
                     backgroundColor: Colors.amber,)),
                   ],
                 );
                }
                return Column(
                  children: [
                    MyDrawerList(context),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                      child: Divider(
                        color: Colors.grey,
                        thickness: 2.0,
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 8, 8, 8),
                          child: Text(
                            "Profile",
                            overflow: TextOverflow.visible,
                            style: GoogleFonts.openSans(
                              color: MyColor.primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 13.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                    MyDrawerProfile(context),
                  ],
                );
              },
            )
          ],
        ),
      )),
    );
   });
  }

  Widget MyDrawerList(BuildContext context) {
    bool isTapped = false;
  
    return ListView.builder(
        shrinkWrap: true,
        itemCount: drawerMenuListname.length,
        itemBuilder: (context, index) {
          return Container(
            color: isTapped ? Colors.blue : Colors.transparent,
            child: ListTile(
              selected:  _isSelected == index,
              selectedTileColor: Colors.teal[50],
              leading: drawerMenuListname[index]['leading'],
              title: Text(
                drawerMenuListname[index]['title'],
              ),
              trailing: drawerMenuListname[index]['trailing'],
              onTap: () {
                _isSelected = index;
                isProfileTapped = false;
                isLogoutTapped = false;
                drawerBloc.add(DrawerListClicked(index: index));
                //  cubitcontext.read<DrawerCubit>().onTapped(index, context);
              },
            ),
          );
        });

    // return BlocConsumer<DrawerCubit, DrawerState>(
    //   listener: (context, state) {},
    //   builder: (cubitcontext, state) {
    //    },
    // );
  }

  Widget MyDrawerProfile(BuildContext context) {
   
   // bool _isSelected = false;
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            _isSelected = 16;
             isLogoutTapped = false;
            isProfileTapped = true;
               drawerBloc.add(DrawerProfileClicked());
          },
          child: Container(
            color: isProfileTapped? Colors.teal[50]:Colors.white,
            width: double.infinity,
            height: 65,
            padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                userImg.isEmpty? CircleAvatar(
                                  radius:15.0,
                                  backgroundColor: Colors.amber,
                                  backgroundImage: 
                                      AssetImage('assets/avatar.png')
                                     
                                ):CircleAvatar(
                                  radius:15.0,
                                  backgroundColor: Colors.amber,
                                  backgroundImage: 
                                      NetworkImage(userImg)
                                     
                                ),
            
               
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${userName}",
                       overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: MyColor.kBlackColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      Text(
                        "${userEmail}",
                           overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: MyColor.primaryColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        GestureDetector(
          onTap: () {
            isLogoutTapped = true;
            isProfileTapped = false;
            _isSelected = 2;
            drawerBloc.add(DrawerLogoutClicked());
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Container(
              height: 50,
               color: isLogoutTapped? Colors.teal[50]:Colors.white,
            //  color: MyColor.containerMenu,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Logout",
                    style: GoogleFonts.openSans(
                      color: MyColor.kBlackColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
       
      
      ],
    );
  }
}
