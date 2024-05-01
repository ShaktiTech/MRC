import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import 'mycolor.dart';


class SuccessDialog extends StatelessWidget {
  const SuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: showDialogclass(context, "", "",""),
    );
  }
   showDialogclass(BuildContext context, String title, String text,String routes) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
       
          shape: RoundedRectangleBorder( borderRadius:
      BorderRadius.all(
        Radius.circular(10.0))),
      
          content: Lottie.asset('assets/success.json',width: 100,height: 100),
          contentPadding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
           actionsAlignment: MainAxisAlignment.center,
          //  title:  Text(
          //       title,
          //       textAlign: TextAlign.left,
          //       style: GoogleFonts.openSans(
          //           color: MyColor.kBlackColor,
          //           fontWeight: FontWeight.bold,
          //           fontSize: 18.0,
                  
          //         )
          //     ),
            
          actions: <Widget>[
             Center(
               child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.openSans(
                      color: MyColor.kBlackColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                    
                    ),
                ),
             ),
              SizedBox(height: 12),
             
             Center(
               child: ElevatedButton(
                         onPressed: (){
                 Navigator.of(context).pop();
                 if(routes.isNotEmpty)
                 {
                  Get.offNamed(routes);
                 }
               
                         }, 
                         
                         child: Text('OK',style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
                ),
                 style: ElevatedButton.styleFrom(
                          backgroundColor: MyColor.primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                        ),),
             )
       
       
          
          ],
        );
      });
   }
}