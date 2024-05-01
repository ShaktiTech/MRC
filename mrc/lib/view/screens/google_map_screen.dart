import 'dart:convert';

import 'package:custom_info_window/custom_info_window.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mrc/bloc/drawer_bloc/drawer_bloc.dart';
import 'package:mrc/model/water_quality_model.dart';
import 'package:mrc/view/screens/drawer_screen.dart';
import 'package:http/http.dart' as http;
import '../../repository/user_repositories.dart';

class GoogleMapScreen extends StatefulWidget {
  const GoogleMapScreen({super.key});

  @override
  State<GoogleMapScreen> createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
    bool _isLoading = true;
    late LatLng location1;
     CustomInfoWindowController _customInfoWindowController = CustomInfoWindowController();
  final LatLng _latLng = LatLng(18.042833732211516, 102.71605629054815);
  final double _zoom = 8.0;
  Set<Marker> markers2 = {};




getWaterQualityData() async {
     
   
    final response = await http.get(Uri.parse("https://portal.mrcmekong.org/assets/data/water-quality/WQ-for-human-health.json"), headers: {
     // "Authorization": "Bearer ${AppUrl.authToken}",
      "Content-Type": "application/json"
    });
    
    if (response.statusCode == 200) {
     
      var items = json.decode( response.body );//"[" ++ "]"
     //var items = response.body;
   //  List<WaterQualityModel> model = waterQualityModelFromJson(items);
   
List<WaterQualityModel> model = List<WaterQualityModel>.from(items.map((model)=> WaterQualityModel.fromJson(model)));
      print(" sss WaterQualityModel ${model.length}");
      if (items != null) {
         for (var x = 0; x < model.length; x++) {
          double lat = model[x].lat??0.0;
          double lon = model[x].lon??0.0;
        location1 = LatLng(lat, lon);
        markers2.add(Marker(markerId:MarkerId(model[x].stationName??"No Name"),
        icon: BitmapDescriptor.defaultMarker,
        position: location1,
        onTap: () {
          // _customInfoWindowController.addInfoWindow!(Container(
          //   height: 200,
          //   width: 100,
          //   decoration: BoxDecoration(
          //     color: Colors.amber,
              
          //   ),
           
          //   child: Text("Shakti",
          //   style: GoogleFonts.openSans(
          //                   color: Colors.red,
          //                   fontWeight: FontWeight.bold,
          //                   fontSize: 20.0,
          //                 ),),
          // ),location1);
           _customInfoWindowController.addInfoWindow!(
            Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.account_circle,
                            color: Colors.white,
                            size: 30,
                          ),
                          SizedBox(
                            width: 8.0,
                          ),
                          Text(
                            model[x].stationName!,
                                style: GoogleFonts.openSans(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                           
                          )
                        ],
                      ),
                    ),
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
                // Triangle.isosceles(
                //   edge: Edge.BOTTOM,
                //   child: Container(
                //     color: Colors.blue,
                //     width: 20.0,
                //     height: 10.0,
                //   ),
                // ),
              ],
            ),
             LatLng(lat, lon),
          );
            
        },),
         );
         setState(() {
           
         });

    //   markers2.add(Marker(builder:(ctx) => Container(
    //         child: Icon(
    //           Icons.circle_rounded,
    //           color:model[x].the2021=="A"?Colors.blue :
    //           model[x].the2021=="B"?Colors.green:
    //           model[x].the2021=="C"?Colors.yellow:
    //           model[x].the2021=="D"?Colors.orange:Colors.red,
    //           size: 20,
    //         ),
    //       ),
    // point: location1
      
      
    // ));
      }
      setState(() {
        markers2;
        _isLoading = false;
      });
       
      } else {
        
      }
    } else {
      
    }
  }
 
 @override
  void initState() {
    // TODO: implement initState
    getWaterQualityData();
    super.initState();
  }
    @override
  void dispose() {
    _customInfoWindowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        appBar: AppBar(title: Text('Map with Layers'),backgroundColor: Colors.transparent),//Color(0x44000000),
        body:  Padding(
          padding: EdgeInsets.all(8.0),
          child:  _isLoading 
            ? const Center(
                child: CircularProgressIndicator(),
              )
            :Stack(
            children: [
            GoogleMap(
            onTap: (position) {
              _customInfoWindowController.hideInfoWindow!();
            },
            onCameraMove: (position) {
              _customInfoWindowController.onCameraMove!();
            },
            onMapCreated: (GoogleMapController controller) async {
              _customInfoWindowController.googleMapController = controller;
            },
            markers: markers2,
            initialCameraPosition: CameraPosition(
              target: _latLng,
              zoom: _zoom,
            ),
          ),
          
          CustomInfoWindow(
            controller: _customInfoWindowController,
            height: 75,
            width: 200,
            offset: 50,
          ),
            ],
          ),
        ),
          
      );
 
  }
}