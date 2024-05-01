import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrc/bloc/login_bloc/login_bloc.dart';
import 'package:mrc/utils/alert_dialoge.dart';
import 'package:mrc/utils/country_picker.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';

import '../../utils/error_snackbar.dart';
import '../../utils/mycolor.dart';

class PhoneScreen extends StatelessWidget {
  final _contactEditingController = TextEditingController();
  var _dialCode = '';
  String phoneNo = "";
  String smsOTP = "";
  String verificationId = "";
  String errorMessage = '';
  String otp = "";
  late Timer _timer;
  OtpFieldController otpController = OtpFieldController();
  late LoginBloc loginBloc;
  @override
  Widget build(BuildContext context) {
      loginBloc = BlocProvider.of<LoginBloc>(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
       appBar: AppBar(
        elevation: 0,
         backgroundColor: Colors.white,
  leading: IconButton(
    icon: Icon(Icons.arrow_back_ios, color: Colors.black),
    onPressed: () => Get.back(),
  ), 
 
  centerTitle: true,
),
      body: SingleChildScrollView(
        child: Container(
         // height: screenHeight,
          //  color: MyColor.lightWhiteColor,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.05,
              left: 35,
              right: 35,
            ),
          child: Column(
            children: [
              phoneView(screenHeight, screenWidth, context),
              BlocConsumer<LoginBloc, LoginState>(
                listener: (context, state) {

                      if(state is LoginhasNetwork)
                    {
                        phoneNo = _dialCode.trim() + _contactEditingController.text.trim();
 loginBloc.add(SignInWithPhonePressed(phoneNumber: _dialCode.trim() + _contactEditingController.text.trim()));

                    }
                    if(state is LoginNetworkError)
                    {
                       var customDialogWidget = CustomDialogWidget();
                      customDialogWidget.showDialogclass(
                          context, "Network Error","Check your internet connection" );
                    }

                    if(state is Codesent)
                  {
                    print("SSS COde Sent");
                   //  Center(child: CircularProgressIndicator(color: MyColor.primaryColor,));
                   Get.toNamed('/otpScreen',arguments: {
                            "phone": phoneNo,"vId":state.vId
                            
                          });
//                     Timer(Duration(seconds: 5), () {
   
// });
                  
                  }
                  else if (state is LoginFailed) {
                        var customDialogWidget = CustomDialogWidget();
                        customDialogWidget.showDialogclass(
                            context, "", state.message);//"Eneter valid email and password"
                      }
                },
                builder: (context, state) {
                   if (state is LoginLoading) {
                        return Center(child: CircularProgressIndicator(color: MyColor.primaryColor,));
                      } else if (state is LoginFailed) {
                        print("Error Login SSS" + state.message);
                      }
                  //  if(state is Codesent)
                  // {
                  //  return Center(child: CircularProgressIndicator(color: MyColor.primaryColor,));
                  // }
                  
                  return buttonView();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget otpView(
  //     double screenHeight, double screenWidth, BuildContext context) {
  //   return Container(
  //     padding: const EdgeInsets.all(16.0),
  //     width: double.infinity,
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         SizedBox(
  //           height: screenHeight * 0.02,
  //         ),
  //         Text(
  //           'Verification',
  //           style: TextStyle(
  //               fontSize: 28, color: MyColor.primaryColor),
  //         ),
  //         SizedBox(
  //           height: screenHeight * 0.02,
  //         ),
  //         Text(
  //           'Enter A 4 digit number that was sent to ${_dialCode.trim() + _contactEditingController.text.trim()} ', //${controller.phoneNumber}
  //           textAlign: TextAlign.center,
  //           style: TextStyle(
  //             fontSize: 18,
  //             color: MyColor.primaryColor,
  //           ),
  //         ),
  //         SizedBox(
  //           height: screenHeight * 0.04,
  //         ),
  //         Container(
  //           margin: EdgeInsets.symmetric(
  //               horizontal: screenWidth > 600 ? screenWidth * 0.2 : 16),
  //           padding: const EdgeInsets.all(16.0),
  //           decoration: BoxDecoration(
  //               color: Colors.grey,
  //               // ignore: prefer_const_literals_to_create_immutables
  //               boxShadow: [
  //                 const BoxShadow(
  //                   color: Colors.grey,
  //                   offset: Offset(0.0, 1.0), //(x,y)
  //                   blurRadius: 6.0,
  //                 ),
  //               ],
  //               borderRadius: BorderRadius.circular(16.0)),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               // Row(
  //               //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               //   children: [
  //               //     _textFieldOTP(first: true, last: false),
  //               //     _textFieldOTP(first: false, last: false),
  //               //     _textFieldOTP(first: false, last: false),
  //               //     _textFieldOTP(first: false, last: true),
  //               //   ],
  //               // ),
  //               OTPTextField(
  //                 controller: otpController,
  //                 length: 6,
  //                 width: MediaQuery.of(context).size.width,
  //                 fieldWidth: 40,
  //                 style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
  //                 textFieldAlignment: MainAxisAlignment.spaceAround,
  //                 fieldStyle: FieldStyle.box,
  //                 inputFormatter: <TextInputFormatter>[
  //                   FilteringTextInputFormatter.digitsOnly
  //                 ],
  //                 outlineBorderRadius: 5,
  //                 otpFieldStyle: OtpFieldStyle(
  //                     enabledBorderColor:
  //                         MyColor.primaryColor,
  //                     disabledBorderColor: Theme.of(context).highlightColor),
  //                 onChanged: (pin) {
  //                   print("Changed: " + pin);
  //                 },
  //                 onCompleted: (pin) {
  //                   otp = pin;
  //                   print("Completed: " + pin);
  //                 },
  //               ),
  //               SizedBox(
  //                 height: screenHeight * 0.04,
  //               ),
  //               ElevatedButton(
  //                   style: ElevatedButton.styleFrom(
  //                     // maximumSize: const Size(290.0, 40.0),
  //                     minimumSize: const Size.fromHeight(45),
  //                     primary: MyColor.primaryColor,
  //                     shape: RoundedRectangleBorder(
  //                         borderRadius: BorderRadius.circular(5.0)),
  //                   ),
  //                   onPressed: () {
  //                       loginBloc.add(SignInCodeVerifiedPressed(code: otp));
                
  //                   },
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     //crossAxisAlignment: CrossAxisAlignment.center,
  //                     children: const [
  //                       Text('Verify'),
  //                       // const Icon(
  //                       //   Icons.lock,
  //                       //   color: Colors.white,
  //                       // ),
  //                     ],
  //                   )),
  //             ],
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }

  Widget phoneView(
      double screenHeight, double screenWidth, BuildContext context) {
    return Column(
      children: [
          Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          //crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("Welcome Back",style: GoogleFonts.openSans(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 30.0,
                  
                  ),),
                            // const Icon(
                            //   Icons.lock,
                            //   color: Colors.white,
                            // ),
                          ],
                        ),
                 const SizedBox(
                  height: 10,
                ),
                 Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          //crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text("Login to your account",
                               overflow: TextOverflow.visible,
                               style: GoogleFonts.openSans(
                                                color: MyColor.textligth,
                                                fontWeight: FontWeight.bold,
                                               
                                                fontSize: 16.0,
                                              
                                              ),),
                            ),
                            // const Icon(
                            //   Icons.lock,
                            //   color: Colors.white,
                            // ),
                          ],
                        ),
                 const SizedBox(
                  height: 30,
                ),
       Container(
               // margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                height: 45,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: MyColor.primaryColor,
                    width: 1.5
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    CountryPicker(
                      callBackFunction: _callBackFunction,
                      headerText: 'Select Country',
                      headerBackgroundColor: Theme.of(context).primaryColor,
                      headerTextColor: Colors.white,
                    ),
                    SizedBox(
                      width: screenWidth * 0.01,
                    ),
                    Expanded(
                      child: TextField(
                        maxLength: 10,
                        decoration: const InputDecoration(
                          hintText: 'Contact Number',
                          border: InputBorder.none,
                          counterText: "",
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 13.5),
                        ),
                        controller: _contactEditingController,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 8,
              ),
               Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          //crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text("You will receive an SMS verification that may apply message and data rates.",
                               overflow: TextOverflow.visible,
                               style: GoogleFonts.openSans(
                                                color: MyColor.textligth,
                                                fontWeight: FontWeight.bold,
                                               
                                                fontSize: 11.0,
                                              
                                              ),),
                            ),
                            // const Icon(
                            //   Icons.lock,
                            //   color: Colors.white,
                            // ),
                          ],
                        ),
                 
              Container(height: 300,),
                  
        ],
    );
  }
 Widget buttonView()
 {
  return Column(
    children: [
 ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    // maximumSize: const Size(290.0, 40.0),
                    minimumSize: const Size.fromHeight(45),
                    primary: MyColor.primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                  ),
                  onPressed: () {
                     if(_dialCode.isEmpty)
               {
 ErrorSnackBar().showToastWithIcon("Error",
                            "Please select country code", const Icon(Icons.email));

                        return;
               }
               if(_contactEditingController.text.isEmpty || _contactEditingController.text.length<10)
               {
 ErrorSnackBar().showToastWithIcon("Error",
                            "Enter valid phone number", const Icon(Icons.email));

                        return;
               }
               else
               {
                  loginBloc.add(CheckInternetLoginPressed());
                               
               }
               //print("SSS code "+_dialCode.trim() + _contactEditingController.text.trim());
                     },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    //crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Text('Send OTP'),
                      // const Icon(
                      //   Icons.lock,
                      //   color: Colors.white,
                      // ),
                    ],
                  )),
            TextButton(
                      style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size(50, 30),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          alignment: Alignment.centerLeft),
                      onPressed: () {
                         Get.offNamed('/login');
                        // Navigator.pushNamed(context, 'forgot');
                      },
                      child: Text(
                        'Use email instead',
                        style: GoogleFonts.openSans(
                    color: MyColor.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  
                  )
                      ),
                    ),
              const SizedBox(height: 20,)
    ],
  );
 }
  void _callBackFunction(String name, String dialCode, String flag) {
    _dialCode = dialCode;
  }
}
