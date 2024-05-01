import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrc/utils/mycolor.dart';

import '../../bloc/drawer_bloc/drawer_bloc.dart';
import '../../model/station_model.dart';
import '../../repository/user_repositories.dart';
import '../../utils/success_dialog.dart';
import 'drawer_screen.dart';

class PersonalizeScreen extends StatefulWidget {
  const PersonalizeScreen({super.key});

  @override
  State<PersonalizeScreen> createState() => _PersonalizeScreenState();
}

class _PersonalizeScreenState extends State<PersonalizeScreen> {

List<StationModel> station = [
    StationModel("Chiang Saen", "Chiang Saen", false,"thailand"),
    StationModel("Chiang Khan", "Chiang Khan", false,"thailand"),
    StationModel("Nong Khai", "Nong Khai", false,"thailand"),
    StationModel("Nakhon Phanom", "Nakhon Phanom", false,"thailand"),
    StationModel("Mukdahan", "Mukdahan", false,"thailand"),
    StationModel("Khong Chiam", "Khong Chiam", false,"thailand"),
    StationModel("Tan Chau", "Tan Chau", false,"vietnam"),
    StationModel("Chau Doc", "Chau Doc", false,"vietnam"),
    StationModel("Stung Treng", "Stung Treng", false,"cambodia"),
    StationModel("Kratie", "Kratie", false,"cambodia"),
    StationModel("Kompong Cham", "Kompong Cham", false,"cambodia"),
    StationModel("Phnom Penh (Bassac)", "Phnom Penh (Bassac)", false,"cambodia"),
    StationModel("Phnom Penh Port","Phnom Penh Port", false,"cambodia"),
    StationModel("Koh Khel (Bassac)", "Koh Khel (Bassac)", false,"cambodia"),
    StationModel("Neak Luong", "Neak Luong", false,"cambodia"),
    StationModel("Prek Kdam (Tonle Sap)", "Prek Kdam (Tonle Sap)", false,"cambodia"),
    StationModel("Luang Prabang", "Luang Prabang", false,"laodpr"),
    StationModel("Vientiane", "Vientiane", false,"laodpr"),
    StationModel("Paksane", "Paksane", false,"laodpr"),
    StationModel("Thakhek", "Thakhek", false,"laodpr"),
    StationModel("Savannakhet", "Savannakhet", false,"laodpr"),
    StationModel("Pakse", "Pakse", false,"laodpr"),
  ];
    bool _isLoading = false;

   List<StationModel> selectedStation = [] ;

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
        title: Text("Personalize",style:  GoogleFonts.openSans(
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
    //  actions: [IconButton(
    //     onPressed: (){
    //      Get.toNamed('/profile');
        
    //     }, icon: const Icon(Icons.settings)),
    //     ],     
        //centerTitle: true,
        
        // backgroundColor: MyColor.kPrimaryGradient,
      ),
      body: SafeArea(
        child: 
              Container(
          child: Column(
            children: [
               Align(
                alignment: Alignment.centerLeft,
                 child: Padding(
                   padding: const EdgeInsets.fromLTRB(18.0,20.0,10.0,0),
                   child: Text("Choose station",style: GoogleFonts.openSans(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 30.0,
                      
                      )
                     
                      
                      ,),
                 ),
               ),
                  SizedBox(height: 20,),
              Expanded(
                child: ListView.builder(
                    itemCount: station.length,
                    itemBuilder: (BuildContext context, int index) {
                      // return item
                      return ContactItem(
                        station[index].name,
                        station[index].phoneNumber,
                        station[index].isSelected,
                        index,
                        station[index].flags,
                      );
                    }),
              ),
              selectedStation.length > 0 ? Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 10,
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: _isLoading 
            ? const Center(
                child: CircularProgressIndicator(),
              ):  ElevatedButton(
                    //color: Colors.green[700],
                    child: Text(
                      "Save (${selectedStation.length})",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                          _isLoading = true;
                                          Timer(Duration(seconds: 2), () {

                                            setState(() {
                                               _isLoading = false;
                                              var customDialogWidget = const SuccessDialog();
   
                        customDialogWidget.showDialogclass(
                            context, "Report", "Data saved successfully.","");
});
                      });
                                            });
    
                   
       
                    //  print("Delete List Lenght: ${selectedStation.length}");
                    },
                  ),
                ),
              ): Container(),
            ],
          ),
        ),
      ),
    );
  }
   Widget ContactItem(
      String name, String phoneNumber, bool isSelected, int index,String flags) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0,6.0,20.0,6.0),
      child: InputDecorator(
      
        decoration: InputDecoration(
              contentPadding: const EdgeInsets.fromLTRB(10.0,-5.0,10.0,-5.0),
              enabled: isSelected,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyColor.primaryColor),
              ),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5.0),
                ),
            ),
        child: ListTile(
           visualDensity: VisualDensity(horizontal: -4, vertical: 0),
          leading:
           SizedBox(
            height: 25,
            width: 25,
            child: Image.asset('assets/${flags}.png'),
          ),
           minLeadingWidth : 10,
      //     ImageIcon(
      //    AssetImage('assets/thailand.png'),
      // ),
          title: Text(
            name,
            textAlign: TextAlign.left,
            style: GoogleFonts.openSans(
                        color: MyColor.kBlackColor,
                        fontSize: 15.0,
                      ),
          ),
          subtitle: Text(phoneNumber,  style: GoogleFonts.openSans(
                        color: MyColor.textligth,
                        fontSize: 12.0,
                      ),),
          trailing: isSelected
              ? Icon(
                  Icons.check_circle,
                  color: Colors.green[700],
                )
              : Icon(
                  Icons.check_circle_outline,
                  color: Colors.grey,
                ),
          onTap: () {
            setState(() {
              station[index].isSelected = !station[index].isSelected;
              if (station[index].isSelected == true) {
                selectedStation.add(StationModel(name, phoneNumber, true,"flag"));
              } else if (station[index].isSelected == false) {
                selectedStation
                    .removeWhere((element) => element.name == station[index].name);
              }
            });
          },
        ),
      ),
    );
  }
}