// import 'dart:js_util';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrc/bloc/drawer_bloc/drawer_bloc.dart';
import 'package:mrc/repository/user_repositories.dart';
import 'package:mrc/view/screens/drawer_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:latlong2/latlong.dart';
import '../../model/station_filter_model.dart';
import '../../utils/mycolor.dart';

class ForecastingScreen extends StatefulWidget {
  const ForecastingScreen({super.key});

  @override
  State<ForecastingScreen> createState() => _ForecastingScreenState();
}

class _ForecastingScreenState extends State<ForecastingScreen>
    with TickerProviderStateMixin {
  InAppWebViewController? webViewController;
  PullToRefreshController? refreshController;
 List<StationFilterModel> filterData = [] ;
   var markers = <Marker>[];
  bool _isPermitted = true;
  bool _isLoading = false;
  bool _isArrow = false;
  int _selectedIndex = 0;
  bool _isNormal = false;
  bool _isAlarm = false;
  bool _isFlood = false;
  bool _isFifty = false;
  bool _isFiftyFive = false;
  bool _isSixty = false;
  bool _isSixtyFive = false;
  bool _isSeventy = false;
  bool _isSeventyFive = false;
  bool _isEightyty = false;
  late LatLng destination;
  late LatLng source;
  bool _isLoadingL = true;
  LatLng? _currentPosition;
  late var url;
  var initialUrl = "https://www.mrcmekong.org/river-monitoring";
 List<String> selectedStation = [] ;
  @override
  void initState() {
    filterList.forEach((element) {
      filterData.add(StationFilterModel.fromJson(element));
    });
        getLocation();
    super.initState();
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
          "Monitoring & forecasting",
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
        actions: [
          IconButton(
              onPressed: () {
                _showSelectFilterOptions(context);
              },
              icon: const Icon(Icons.filter_list)),
        ],
        // actions: [IconButton(
        //   onPressed: (){
        //     webViewController!.reload();

        //   }, icon: const Icon(Icons.refresh)),
        //   ],
      ),
      body: Column(
        children: [
          Expanded(
              child:_isLoadingL &&  _currentPosition == null 
          ? const Center(
              child: CircularProgressIndicator(),
            )
          :
               Stack(children: [
            InAppWebView(
              onLoadStart: (controller, url) {
                setState(() {
                  _isLoading = true;
                });
              },
              onLoadStop: (controller, url) {
                setState(() {
                  _isLoading = false;
                  _isArrow = true;
                });
              },
              initialUrlRequest: URLRequest(url: Uri.parse(initialUrl)),
              onWebViewCreated: (controller) => webViewController = controller,
            ),
            Visibility(
                visible: _isLoading,
                child: Center(child: CircularProgressIndicator())),
            Visibility(
              visible: _isArrow,
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox.fromSize(
                        size: Size(40, 40), // button width and height
                        child: ClipOval(
                          child: Material(
                            color: Colors.orange, // button color
                            child: InkWell(
                              splashColor: Colors.green, // splash color
                              onTap: () {
                                webViewController!.scrollBy(x: 0, y: -200);
                              }, // button pressed
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(Icons.arrow_upward), // icon
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox.fromSize(
                        size: Size(40, 40), // button width and height
                        child: ClipOval(
                          child: Material(
                            color: Colors.orange, // button color
                            child: InkWell(
                              splashColor: Colors.green, // splash color
                              onTap: () {
                                webViewController!.scrollBy(x: 0, y: 200);
                              }, // button pressed
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(Icons.arrow_downward), // icon
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ])),
        ],
      ),
    );
  }

  void _showSelectFilterOptions(BuildContext context) {
  
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(25.0),
          ),
        ),
        builder: (context) => StatefulBuilder(builder: (BuildContext context,
                StateSetter setModelState /*You can rename this!*/) {
              return DraggableScrollableSheet(
                  initialChildSize: 0.6,
                  maxChildSize: 0.6,
                  minChildSize: 0.28,
                  expand: false,
                  builder: (context, scrollController) {
                    return SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          children: [
                            // Padding(
                            //   padding: const EdgeInsets.fromLTRB(10.0,20.0,10.0,8.0),
                            //   child:       ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  10.0, 20.0, 10.0, 8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setModelState(() {
                                        _selectedIndex = 0;
                                      });
                                    },
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      color: _selectedIndex == 0
                                          ? MyColor.primaryColor
                                          : Colors.white,
                                      elevation: 10,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              //  Image.asset('assets/images/ic_policy@2x.png', width: 18, height: 18),const SizedBox(width: 8),
                                              Icon(
                                                Icons.filter_list_outlined,
                                                color: _selectedIndex == 0
                                          ? Colors.white
                                          : MyColor.primaryColor,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                "Stations",
                                                style: GoogleFonts.openSans(
                                                  color: _selectedIndex == 0
                                          ? Colors.white
                                          : MyColor.primaryColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12.0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setModelState(() {
                                        _selectedIndex = 1;
                                      });
                                    },
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      color: _selectedIndex == 1
                                          ? MyColor.primaryColor
                                          : Colors.white,
                                      elevation: 10,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              //  Image.asset('assets/images/ic_policy@2x.png', width: 18, height: 18),const SizedBox(width: 8),
                                              Icon(
                                                Icons.more_time_rounded,
                                                color: _selectedIndex == 1
                                          ? Colors.white
                                          : MyColor.primaryColor,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                "Status",
                                                style: GoogleFonts.openSans(
                                                  color: _selectedIndex == 1
                                          ? Colors.white
                                          : MyColor.primaryColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12.0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setModelState(() {
                                        _selectedIndex = 2;
                                      });
                                    },
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      color: _selectedIndex == 2
                                          ? MyColor.primaryColor
                                          : Colors.white,
                                      elevation: 10,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              //  Image.asset('assets/images/ic_policy@2x.png', width: 18, height: 18),const SizedBox(width: 8),
                                              Icon(
                                                Icons.water_drop_outlined,
                                                color: _selectedIndex == 2
                                          ? Colors.white
                                          : MyColor.primaryColor,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                "Water level",
                                                style: GoogleFonts.openSans(
                                                  color: _selectedIndex == 2
                                          ? Colors.white
                                          : MyColor.primaryColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12.0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Visibility(
                              visible: _selectedIndex == 0,
                              child: stationFilter(setModelState),
                            ),
                            const SizedBox(height: 20,),
                            Visibility(
                              visible: _selectedIndex == 1,
                              child: statusFilter(setModelState),
                            ),
                            Visibility(
                              visible: _selectedIndex == 2,
                              child:  waterFilter(setModelState),
                            ),
                             const SizedBox(height: 20,),
                             selectedStation.length > 0 ? Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 10,
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    //color: Colors.green[700],
                    child: Text(
                      "Apply (${selectedStation.length})",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    onPressed: () {
                           Navigator.pop(context);
                            webViewController!.reload();
                    //  print("Delete List Lenght: ${selectedStation.length}");
                    },
                  ),
                ),
              ): Container(),
         
                          ],
                        ));
                  });
            }));
  }

  Widget stationFilter(StateSetter setModelState){
    return Column(
      children: [
        ListView.builder(
          physics: const ScrollPhysics(),
          shrinkWrap: true,
          itemCount: filterData.length,
          itemBuilder: (BuildContext context, index) => 
          _buildList(filterData[index],setModelState),
          ),
      ],
    );
  }

  Widget _buildList2(StationFilterModel filterData,StateSetter setModelState) {
     return Builder(builder: (context){
   return ListTile(
          leading: SizedBox(
            height: 25,
            width: 25,
            child: Image.asset('assets/${filterData.flags}.png'),
          ),
    title: Text(
            filterData.name,
            textAlign: TextAlign.left,
            style: GoogleFonts.openSans(
                        color: MyColor.kBlackColor,
                        fontSize: 15.0,
                      ),
          ),
           trailing: filterData.isSelected
              ? Icon(
                  Icons.check_circle,
                  color: MyColor.primaryColor,
                )
              : Icon(
                  Icons.check_circle_outline,
                  color: Colors.grey,
                ),
   onTap: () {
      setModelState(() {
              filterData.isSelected = !filterData.isSelected;
              if(filterData.isSelected == true)
              {
                 selectedStation.add(filterData.name);
                 print("Data List ${selectedStation.toList()}");
              } else if(filterData.isSelected == false)
              {
                  selectedStation
                    .removeWhere((element) => element == filterData.name);
                      print("Data List ${selectedStation.toList()}");
              }
      });
   },
   );
  });

  }

Widget _buildList(StationFilterModel filterData,StateSetter setModelState) {

// if(filterData.subList.isEmpty)
// {
//   return Builder(builder: (context){
//    return ListTile(
//           leading: SizedBox(
//             height: 25,
//             width: 25,
//             child: Image.asset('assets/${filterData.flags}.png'),
//           ),
//     title: Text(
//             filterData.name,
//             textAlign: TextAlign.left,
//             style: GoogleFonts.openSans(
//                         color: MyColor.kBlackColor,
//                         fontSize: 15.0,
//                       ),
//           ),
//            trailing: filterData.isSelected
//               ? Icon(
//                   Icons.check_circle,
//                   color: Colors.green[700],
//                 )
//               : Icon(
//                   Icons.check_circle_outline,
//                   color: Colors.grey,
//                 ),
//    onTap: () {
//       setState(() {
//               filterData.isSelected = !filterData.isSelected;
//       });
//    },
//    );
//   });
// }

  return ExpansionTile(
    leading: SizedBox(
            height: 25,
            width: 25,
            child: Image.asset('assets/${filterData.flags}.png'),
          ),
    title: Text(
            filterData.name,
            textAlign: TextAlign.left,
            style: GoogleFonts.openSans(
                        color: MyColor.kBlackColor,
                        fontSize: 15.0,
                      ),
          ),
    children:[  ListView.builder(
          physics: const ScrollPhysics(),
          shrinkWrap: true,
          itemCount: filterData.subList.length,
          itemBuilder: (BuildContext context, index) => 
          _buildList2(filterData.subList[index],setModelState),
          ),]//filterData.subList.map(_buildList).toList(),      
          );

}
 
 Widget statusFilter(StateSetter setModelState ){
 
  return Center(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
      
      GestureDetector(
        onTap: () {
            setModelState(() {
            _isNormal = !_isNormal;
              if(_isNormal == true)
              {
                 selectedStation.add("Normal");
                 print("Data List ${selectedStation.toList()}");
              } else if(_isNormal == false)
              {
                  selectedStation
                    .removeWhere((element) => element == "Normal");
                      print("Data List ${selectedStation.toList()}");
              }
          });
        },
        child: Card(
           shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        color: _isNormal?MyColor.primaryColor: Colors.white,
                                        elevation: 10,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(children: [
              Icon(Icons.water,color:_isNormal?Colors.white:MyColor.primaryColor,),
              SizedBox(height: 5,),
               Text(
              " Normal ",
              style: GoogleFonts.openSans(
                color: _isNormal?Colors.white:MyColor.primaryColor,
                
                fontSize: 12.0,
              ),
            ),
            ],),
          )
        ,),
      ),
       GestureDetector(
        onTap: () {
            setModelState(() {
            _isAlarm = !_isAlarm;
             if(_isAlarm == true)
              {
                 selectedStation.add("Alarm");
                 print("Data List ${selectedStation.toList()}");
              } else if(_isAlarm == false)
              {
                  selectedStation
                    .removeWhere((element) => element == "Alarm");
                      print("Data List ${selectedStation.toList()}");
              }
          });
        },
         child: Card(
           shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        color: _isAlarm?MyColor.primaryColor:Colors.white,
                                        elevation: 10,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(children: [
              Icon(Icons.alarm,color: _isAlarm?Colors.white:MyColor.primaryColor,),
              SizedBox(height: 5,),
               Text(
              "  Alarm  ",
              style: GoogleFonts.openSans(
                color:  _isAlarm?Colors.white:MyColor.primaryColor,
                
                fontSize: 12.0,
              ),
            ),
            ],),
          )
             ,),
       ),
       GestureDetector(
        onTap: () {
          setModelState(() {
            _isFlood = !_isFlood;
              if(_isFlood == true)
              {
                 selectedStation.add("Flood");
                 print("Data List ${selectedStation.toList()}");
              } else if(_isFlood == false)
              {
                  selectedStation
                    .removeWhere((element) => element == "Flood");
                      print("Data List ${selectedStation.toList()}");
              }
          });
        },
         child: Card(
           shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        color: _isFlood?MyColor.primaryColor:Colors.white,
                                        elevation: 10,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(children: [
              Icon(Icons.flood,color:  _isFlood?Colors.white:MyColor.primaryColor,),
              SizedBox(height: 5,),
               Text(
              "Flooded",
              style: GoogleFonts.openSans(
                color: _isFlood?Colors.white:MyColor.primaryColor,
                
                fontSize: 12.0,
              ),
            ),
            ],),
          )
             ,),
       )
     
     
    ],),
  );
 }
 
 Widget waterFilter(StateSetter setModelState){
   return Padding(
     padding: const EdgeInsets.all(10.0),
     child: Column(
    
       children: [
         Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
           children: [
           
           GestureDetector(
             onTap: () {
                 setModelState(() {
                 _isFifty = !_isFifty;
                 if(_isFifty == true)
              {
                 selectedStation.add("Fifty");
                 print("Data List ${selectedStation.toList()}");
              } else if(_isFifty == false)
              {
                  selectedStation
                    .removeWhere((element) => element == "Fifty");
                      print("Data List ${selectedStation.toList()}");
              }
               });
             },
             child: Card(
                shape: RoundedRectangleBorder(
                                                 borderRadius:
                                                     BorderRadius.circular(5)),
                                             color: _isFifty?MyColor.primaryColor: Colors.white,
                                             elevation: 10,
               child: Padding(
                 padding: const EdgeInsets.fromLTRB(18.0,8.0,18.0,8.0),
                 child: Text(
                   "350",
                   style: GoogleFonts.openSans(
                  color: _isFifty?Colors.white:MyColor.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                   ),
                 ),
               )
             ,),
           ),
            GestureDetector(
             onTap: () {
                 setModelState(() {
                 _isFiftyFive = !_isFiftyFive;
                  if(_isFiftyFive == true)
              {
                 selectedStation.add("FiftyFive");
                 print("Data List ${selectedStation.toList()}");
              } else if(_isFiftyFive == false)
              {
                  selectedStation
                    .removeWhere((element) => element == "FiftyFive");
                      print("Data List ${selectedStation.toList()}");
              }
               });
             },
             child: Card(
                shape: RoundedRectangleBorder(
                                                 borderRadius:
                                                     BorderRadius.circular(5)),
                                             color: _isFiftyFive?MyColor.primaryColor: Colors.white,
                                             elevation: 10,
               child: Padding(
                 padding: const EdgeInsets.fromLTRB(18.0,8.0,18.0,8.0),
                 child: Text(
                   "355",
                   style: GoogleFonts.openSans(
                  color: _isFiftyFive?Colors.white:MyColor.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                   ),
                 ),
               )
             ,),
           ),
           GestureDetector(
             onTap: () {
                 setModelState(() {
                 _isSixty = !_isSixty;
                   if(_isSixty == true)
              {
                 selectedStation.add("Sixty");
                 print("Data List ${selectedStation.toList()}");
              } else if(_isSixty == false)
              {
                  selectedStation
                    .removeWhere((element) => element == "Sixty");
                      print("Data List ${selectedStation.toList()}");
              }
               });
             },
             child: Card(
                shape: RoundedRectangleBorder(
                                                 borderRadius:
                                                     BorderRadius.circular(5)),
                                             color: _isSixty?MyColor.primaryColor: Colors.white,
                                             elevation: 10,
               child: Padding(
                 padding: const EdgeInsets.fromLTRB(18.0,8.0,18.0,8.0),
                 child: Text(
                   "360",
                   style: GoogleFonts.openSans(
                  color: _isSixty?Colors.white:MyColor.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                   ),
                 ),
               )
             ,),
           ),
           GestureDetector(
             onTap: () {
                 setModelState(() {
                 _isSixtyFive = !_isSixtyFive;
                    if(_isSixtyFive == true)
              {
                 selectedStation.add("SixtyFive");
                 print("Data List ${selectedStation.toList()}");
              } else if(_isSixtyFive == false)
              {
                  selectedStation
                    .removeWhere((element) => element == "SixtyFive");
                      print("Data List ${selectedStation.toList()}");
              }
               });
             },
             child: Card(
                shape: RoundedRectangleBorder(
                                                 borderRadius:
                                                     BorderRadius.circular(5)),
                                             color: _isSixtyFive?MyColor.primaryColor: Colors.white,
                                             elevation: 10,
               child: Padding(
                 padding: const EdgeInsets.fromLTRB(18.0,8.0,18.0,8.0),
                 child: Text(
                   "365",
                   style: GoogleFonts.openSans(
                  color: _isSixtyFive?Colors.white:MyColor.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                   ),
                 ),
               )
             ,),
           ),
          
         ],),
           Row(
             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
           children: [
              GestureDetector(
             onTap: () {
                 setModelState(() {
                 _isSeventy = !_isSeventy;
                    if(_isSeventy == true)
              {
                 selectedStation.add("Seventy");
                 print("Data List ${selectedStation.toList()}");
              } else if(_isSeventy == false)
              {
                  selectedStation
                    .removeWhere((element) => element == "Seventy");
                      print("Data List ${selectedStation.toList()}");
              }
               });
             },
             child: Card(
                shape: RoundedRectangleBorder(
                                                 borderRadius:
                                                     BorderRadius.circular(5)),
                                             color: _isSeventy?MyColor.primaryColor: Colors.white,
                                             elevation: 10,
               child: Padding(
                 padding: const EdgeInsets.fromLTRB(18.0,8.0,18.0,8.0),
                 child: Text(
                   "370",
                   style: GoogleFonts.openSans(
                  color: _isSeventy?Colors.white:MyColor.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                   ),
                 ),
               )
             ,),
           ),
        
           GestureDetector(
             onTap: () {
                 setModelState(() {
                 _isSeventyFive = !_isSeventyFive;
                     if(_isSeventyFive == true)
              {
                 selectedStation.add("SeventyFive");
                 print("Data List ${selectedStation.toList()}");
              } else if(_isSeventyFive == false)
              {
                  selectedStation
                    .removeWhere((element) => element == "SeventyFive");
                      print("Data List ${selectedStation.toList()}");
              }
               });
             },
             child: Card(
                shape: RoundedRectangleBorder(
                                                 borderRadius:
                                                     BorderRadius.circular(5)),
                                             color: _isSeventyFive?MyColor.primaryColor: Colors.white,
                                             elevation: 10,
               child: Padding(
                padding: const EdgeInsets.fromLTRB(18.0,8.0,18.0,8.0),
                 child: Text(
                   "375",
                   style: GoogleFonts.openSans(
                  color: _isSeventyFive?Colors.white:MyColor.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                   ),
                 ),
               )
             ,),
           ),
            GestureDetector(
             onTap: () {
                 setModelState(() {
                 _isEightyty = !_isEightyty;
                  if(_isEightyty == true)
              {
                 selectedStation.add("Eightyty");
                 print("Data List ${selectedStation.toList()}");
              } else if(_isEightyty == false)
              {
                  selectedStation
                    .removeWhere((element) => element == "Eightyty");
                      print("Data List ${selectedStation.toList()}");
              }
               });
             },
             child: Card(
                shape: RoundedRectangleBorder(
                                                 borderRadius:
                                                     BorderRadius.circular(5)),
                                             color: _isEightyty?MyColor.primaryColor: Colors.white,
                                             elevation: 10,
               child: Padding(
                 padding: const EdgeInsets.fromLTRB(18.0,8.0,18.0,8.0),
                 child: Text(
                   "380",
                   style: GoogleFonts.openSans(
                  color: _isEightyty?Colors.white:MyColor.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                   ),
                 ),
               )
             ,),
           ),
           Card(
            elevation: 0,
        color: Colors.transparent,
              // shape: RoundedRectangleBorder(
              //                                  borderRadius:
              //                                      BorderRadius.circular(5)),
                                         //  color: Colors.transparent,
                                          //  elevation: 10,
             child: Padding(
               padding: const EdgeInsets.fromLTRB(30.0,8.0,30.0,8.0),
               child: Text(
                 "",
                 style: GoogleFonts.openSans(
               
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
                 ),
               ),
             )
           ,),
           
         ],),
       ],
     ),
   );

 }
 
  List filterList= [
    {
     'name':"Thailand",
     'flags':"thailand",
     'isSelected':false,
     'subList':[
      {'name':"Chiang Saen",'flags':"thailand",'isSelected':false,},
      {'name':"Chiang Khan",'flags':"thailand",'isSelected':false,},
      {'name':"Nong Khai",'flags':"thailand",'isSelected':false,},
      {'name':"Nakhon Phanom",'flags':"thailand",'isSelected':false,},
      {'name':"Mukdahan",'flags':"thailand",'isSelected':false,},
      {'name':"Khong Chiam",'flags':"thailand",'isSelected':false,}
     ]
    },
     {
     'name':"Vietnam",
     'flags':"vietnam",
     'isSelected':false,
     'subList':[
      {'name':"Tan Chau",'flags':"vietnam",'isSelected':false,},
      {'name':"Chau Doc",'flags':"vietnam",'isSelected':false,},
     
     ]
    },
     {
     'name':"Cambodia",
     'flags':"cambodia",
     'isSelected':false,
     'subList':[
      {'name':"Stung Treng",'flags':"cambodia",'isSelected':false,},
      {'name':"Kratie",'flags':"cambodia",'isSelected':false,},
      {'name':"Kompong Cham",'flags':"cambodia",'isSelected':false,},
      {'name':"Phnom Penh (Bassac)",'flags':"cambodia",'isSelected':false,},
      {'name':"Phnom Penh Port",'flags':"cambodia",'isSelected':false,},
      {'name':"Koh Khel (Bassac)",'flags':"cambodia",'isSelected':false,},
      {'name':"Neak Luong",'flags':"cambodia",'isSelected':false,},
      {'name':"Prek Kdam (Tonle Sap)",'flags':"cambodia",'isSelected':false,}
     ]
    },
      {
     'name':"Lao PDR",
     'flags':"laodpr",
     'isSelected':false,
     'subList':[
      {'name':"Luang Prabang",'flags':"laodpr",'isSelected':false,},
      {'name':"Vientiane",'flags':"laodpr",'isSelected':false,},
      {'name':"Paksane",'flags':"laodpr",'isSelected':false,},
      {'name':"Thakhek",'flags':"laodpr",'isSelected':false,},
      {'name':"Savannakhet",'flags':"laodpr",'isSelected':false,},
      {'name':"Pakse",'flags':"laodpr",'isSelected':false,}
     ]
    }
  ];
  
  getLocation() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
       
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
       showDialogclass("Permission Required", "App required location permission to showing map","local");
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }
 
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      _isPermitted = false;
      showDialogclass("Permission Required", "App required location permission to showing map","denied");
      
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    double lat = position.latitude;
    double long = position.longitude;

    LatLng location = LatLng(lat, long);
     SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("userLocation", location.toString());
       prefs.setString("userLatitude", location.latitude.toString());
        prefs.setString("userLongitude", location.longitude.toString());
       prefs.setDouble("userLateD", location.latitude);
        prefs.setDouble("userLongD", location.longitude);
    setState(() {
      _currentPosition = location;
      _isLoadingL = false;
    });
  }


 showDialogclass(String title, String text,String type) {
    return showDialog(
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0,10.0,10.0,10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 12),
              Text.rich(
                TextSpan(
                  children: [
                    WidgetSpan(
                        child: Icon(
                      Icons.error,
                      color: Colors.red,
                    )),
                  //   TextSpan(
                  //     text: title,
                  //     style:
                  //         GoogleFonts.openSans(
                  //   color: MyColor.titleColor,
                  //   fontWeight: FontWeight.bold,
                  //   fontSize: 20.0,
                  
                  // )
                  //   ),
                  ],
                ),
              ),
               SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.left,
                style: GoogleFonts.openSans(
                    color: MyColor.kBlackColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  
                  )
              ),
              // Text(
              //   '\u{26A0} ${title}',
              //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              // ),
              SizedBox(height: 12),
              Text(
                text,
                textAlign: TextAlign.left,
                style: GoogleFonts.openSans(
                    color: MyColor.textligth,
                    // fontWeight: FontWeight.bold,
                    fontSize: 14.0,
                  
                  ),
              ),
              SizedBox(height: 12),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: MyColor.cborder),
                  child: Text('Ok', style: GoogleFonts.openSans(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                    
                    ),),
                  onPressed: () {
                    Navigator.of(context).pop();
                    if(type.compareTo("local")==0)
                    {
     getLocation();
                    }
                    else
                    {
                      Geolocator.openLocationSettings();
                    }
             
                  } 
                ),
              )
            ],
          ),
        ),
      ),
      context: context,
      barrierDismissible: false,
    );
  }


}
