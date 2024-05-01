import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrc/bloc/login_bloc/login_bloc.dart';
import 'package:mrc/utils/mycolor.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';

import '../../utils/alert_dialoge.dart';

class OtpScreen extends StatelessWidget {
  String phoneNo;
  String vId;
  OtpScreen({super.key, required this.phoneNo, required this.vId});
  var _dialCode = '';
  var _isEnable = false;
  
  String smsOTP = "";
  String verificationId = "";
  String errorMessage = '';
  String otp = "";
  late Timer _timer;
  OtpFieldController otpController = OtpFieldController();
  late LoginBloc loginBloc;

  @override
  Widget build(BuildContext context) {
   // phoneNo = Get.arguments["phoneNuber"];
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
      
          //  color: Colors.white,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.05,
              left: 35,
              right: 35,
            ),
          child: Column(
            children: [
              otpView(screenHeight, screenWidth, context),
              BlocConsumer<LoginBloc, LoginState>(
                listener: (context, state) {
                 
                  if(state is LoginhasNetwork)
                    {
                      loginBloc.add(SignInCodeVerifiedPressed(code: otp,vId: vId));
                    }
                    if(state is LoginNetworkError)
                    {
                       var customDialogWidget = CustomDialogWidget();
                      customDialogWidget.showDialogclass(
                          context, "Network Error","Check your internet connection" );
                    }

                   if (state is LoginSucced) {
                    Get.offAllNamed('/home');
                   }
                   else if (state is LoginFailed) {
                        var customDialogWidget = CustomDialogWidget();
                        customDialogWidget.showDialogclass(
                            context, "Login Error", state.message);//"Eneter valid email and password"
                      }
                },
                builder: (context, state) {
                   if (state is LoginLoading) {
                        return Center(child: CircularProgressIndicator(color: MyColor.primaryColor,));
                      } else if (state is LoginFailed) {
                        print("Error Login SSS" + state.message);
                      }
                
                  
                  return buttonView();
                },
              ),
            ],
          ),
        ),
      ),
    
    );
    
  }
   Widget otpView(
      double screenHeight, double screenWidth, BuildContext context) {
    return Container(
    //  padding: const EdgeInsets.all(8.0),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // SizedBox(
          //   height: screenHeight * 0.02,
          // ),
          Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          //crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text("Enter authentication code",
                              overflow: TextOverflow.visible,
                              style: GoogleFonts.openSans(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 22.0,
                                              
                                              ),),
                            ),
                            // const Icon(
                            //   Icons.lock,
                            //   color: Colors.white,
                            // ),
                          ],
                        ),
                 const SizedBox(
                  height: 10,
                ),
                
       
         Text(
            'Enter the 6-digit code that we have sent on the phone number ${phoneNo}', //${controller.phoneNumber}+ _contactEditingController.text.trim()
            textAlign: TextAlign.center,
            style: GoogleFonts.openSans(
                                                color: MyColor.textligth2,
                                                
                                               
                                                fontSize: 16.0,
                                              
                                              ),
          ),
          SizedBox(
            height: screenHeight * 0.04,
          ),
           OTPTextField(
                  controller: otpController,
                  length: 6,
                  width: MediaQuery.of(context).size.width,
                
                  fieldWidth: 40,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  textFieldAlignment: MainAxisAlignment.spaceAround,
                  fieldStyle: FieldStyle.box,
                  inputFormatter: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  outlineBorderRadius: 15,
                  
                  otpFieldStyle: OtpFieldStyle(
                    
                      enabledBorderColor:
                          MyColor.primaryColor,
                      disabledBorderColor: Colors.grey,
                      borderColor:Colors.grey, ),
                  onChanged: (pin) {
                    print("Changed: " + pin);
                  },
                  onCompleted: (pin) {
                    otp = pin;
                    _isEnable = true;
                    print("Completed: " + pin);
                  },
                ),
                SizedBox(
                  height: screenHeight * 0.04,
                ),
                  Container(height: 200,),
                   
          ],
      ),
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
                          primary: _isEnable? MyColor.primaryColor: Colors.grey,
                       
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                        onPressed: () {
                          if(_isEnable)
                          {
                            loginBloc.add(CheckInternetLoginPressed());

                          }
                          else{
                              print("Disable SSS");
                            Null;
                          }
                            
                    
                        },
                        
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          //crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            Text('Continue',style: TextStyle(fontSize: 16),),
                            // const Icon(
                            //   Icons.lock,
                            //   color: Colors.white,
                            // ),
                          ],
                        )),
                         SizedBox(
                  height: 40,
                ),
                  ],
                );
           
}
}