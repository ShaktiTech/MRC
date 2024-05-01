import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrc/utils/alert_dialoge.dart';

import '../../bloc/login_bloc/login_bloc.dart';
import '../../utils/error_snackbar.dart';
import '../../utils/mycolor.dart';


class ForgotScreen extends StatelessWidget {
   final TextEditingController _emailController = new TextEditingController();

  

  late LoginBloc loginBloc;

  var reg = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  @override
  Widget build(BuildContext context) {
    loginBloc = BlocProvider.of<LoginBloc>(context);
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
      body: Stack(children: [
        SingleChildScrollView(
          child: Container(
            // color: MyColor.lightWhiteColor,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.05,
              left: 35,
              right: 35,
            ),
            child: Column(
              children: [
               Row(
                mainAxisAlignment: MainAxisAlignment.start,
                 children: [
                   Text("Forgot Password",textAlign:TextAlign.center,
                      style: GoogleFonts.openSans(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 30.0,
                      
                      )
                       
                    ),
                 ],
               ),
                const SizedBox(
                  height: 40,
                ),
                FocusScope(
                  onFocusChange: (value) {
                    // if (!value) {
                    //   if (!reg.hasMatch(_emailController.text)) {
                    //     ErrorSnackBar().showToastWithIcon("Error",
                    //         "Enter Valid Email", const Icon(Icons.email));

                    //     return;
                    //   }
                    // }
                    // print('First text FOCUS: $value');
                  },
                  child: SizedBox(
                    height: 40,
                    child: TextField(
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: "Email",
                        fillColor: MyColor.secondPageTitleColor,
                        filled: true,
                        contentPadding: EdgeInsets.all(8.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30.0),
                BlocConsumer<LoginBloc, LoginState>(
                  listener: (context, state) {
                    if (state is Codesent) {
                      _emailController.text = "";
                    
                      Get.toNamed("/login");
                    } 
                      if(state is LoginhasNetwork)
                    {
                       loginBloc.add(ForgotButtonPressed(
                                email: _emailController.text,
                                ));
                    }
                    if(state is LoginNetworkError)
                    {
                       var customDialogWidget = CustomDialogWidget();
                      customDialogWidget.showDialogclass(
                          context, "Network Error","Check your internet connection" );
                    }
                    else if (state is ResetLinkFailed) {
                      var customDialogWidget = CustomDialogWidget();
                      customDialogWidget.showDialogclass(
                          context, "", state.message);
                    }
                  },
                  builder: (bloccontext, state) {
                    if (state is LoginLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } 
                    // else if (state is Codefailed) {
                    //   var customDialogWidget = CustomDialogWidget();
                    //   customDialogWidget.showDialogclass(
                    //       context, "", "Something went wrong, please try again later.");
                    // }

                    return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          // maximumSize: const Size(290.0, 40.0),
                          minimumSize: const Size.fromHeight(45),
                          primary: MyColor.primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                        onPressed: () {
                          if (_emailController.text.isEmpty) {
                            ErrorSnackBar().showToastWithIcon("Error",
                                "Enter Valid Email", const Icon(Icons.email));
                            return;
                          }  else {
                             loginBloc.add(CheckInternetLoginPressed());
                           
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          //crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            Text('Send'),
                            // const Icon(
                            //   Icons.lock,
                            //   color: Colors.white,
                            // ),
                          ],
                        ));
                  },
                ),
                const SizedBox(height: 30.0),
              
                const SizedBox(
                  height: 20,
                ),
                // ignore: prefer_const_constructors
                Text("---- or sign up with ----",
                    style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                        fontWeight: FontWeight.w500)),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  
                  children: [
                    Expanded(
                      child: BlocConsumer<LoginBloc, LoginState>(
                                      listener: (context, state) {

                         if(state is LoginGooglehasNetwork)
                    {
                        loginBloc.add(SignInWithGooglePressed());
                    }
                    if(state is LoginGoogleNetworkError)
                    {
                       var customDialogWidget = CustomDialogWidget();
                      customDialogWidget.showDialogclass(
                          context, "Network Error","Check your internet connection" );
                    }

                      if (state is LoginGoogleSucced) {
                      
                        Get.offAllNamed("/home");
                      }  if (state is GmailLoginFailed) {
                        var customDialogWidget = CustomDialogWidget();
                        customDialogWidget.showDialogclass(
                            context, "Login Error", state.message);//"Eneter valid email and password"
                      }
                                      },
                                      builder: (context, state) {
                         if (state is LoginGmailLoading) {
                        return Center(child: CircularProgressIndicator());
                      } 
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          // maximumSize: const Size(290.0, 40.0),
                         // minimumSize: const Size.fromHeight(45),
                      
                          primary: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                        onPressed: () {
                            loginBloc.add(CheckInternetLoginGooglePressed());
                          
                        },
                        child: Wrap(
                          children: <Widget>[
                            Icon(
                              FontAwesomeIcons.google,
                              color: MyColor.cbuttons,
                              size: 20.0,
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            Text(
                              "Google",
                              style: TextStyle(fontSize: 15,color: MyColor.kBlackColor,),
                            ),
                          ],
                        ),
                      );
                                      },
                                    ),
                    ),
 SizedBox(width: 20,),
 Expanded(
   child: ElevatedButton(
    
                        style: ElevatedButton.styleFrom(
                          
                          // maximumSize: const Size(290.0, 40.0),
                        //  minimumSize: const Size.fromHeight(5),
                          primary: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                        onPressed: () {
                          Get.toNamed('/phoneScreen');//otpScreen
                       //  Get.toNamed('/otpScreen');
                        },
                        child: Wrap(
                          children: const <Widget>[
                            Icon(
                              Icons.phone_android,
                              color: MyColor.kBlackColor,
                              size: 20.0,
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            Text(
                              "Phone",
                              style: TextStyle(fontSize: 15, color: MyColor.kBlackColor,),
                            ),
                          ],
                        ),
                      ),
 ),
                   
                  ],
                ),

              
                const SizedBox(
                  height: 30,
                ),
              
                const SizedBox(
                  height: 10,
                ),
                  Row(
                  children: [
                    RichText(
                        text: TextSpan(children: [
                      const TextSpan(
                        text: "Don't have an account? ",
                        style: TextStyle(color: Colors.grey,fontSize: 16),
                      ),
                      TextSpan(
                          text: "Sign up here",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              
                              color: MyColor.primaryColor),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Get.toNamed('/register');
                              //                          Navigator.push(
                              // context,
                              // MaterialPageRoute(builder: (context) => const RegisterScreen()),
                              // );
                            })
                    ])),
                  ],
                ),

              ],
            ),
          ),
        ),
      ]),
    );
 
  }
}