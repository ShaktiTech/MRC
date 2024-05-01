import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrc/bloc/login_bloc/login_bloc.dart';
import 'package:mrc/utils/alert_dialoge.dart';
import 'package:mrc/utils/error_snackbar.dart';
import 'package:mrc/utils/mycolor.dart';
import 'package:mrc/view/screens/register_screen.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _unameController = new TextEditingController();

  TextEditingController _passwordController = new TextEditingController();

  bool _hasInternet = false;

  late LoginBloc loginBloc;

  bool _showPswd = true;

  var reg = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    loginBloc = BlocProvider.of<LoginBloc>(context);
    return Scaffold(
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
                Container(
                  child: Image.asset(
                    'assets/mrc-logo.png',
                    width: screenWidth * 0.3,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Login",
                      style: GoogleFonts.openSans(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 30.0,
                      ),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        "Welcome back, Enter your credentials to access your account",
                        overflow: TextOverflow.visible,
                        style: GoogleFonts.openSans(
                          color: MyColor.drwMenu,
                          fontSize: 15.0,
                        ),
                      ),
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
                FocusScope(
                  onFocusChange: (value) {
                    if (!value) {
                      if (!reg.hasMatch(_unameController.text)) {
                        ErrorSnackBar().showToastWithIcon("Error",
                            "Enter Valid Email", const Icon(Icons.email));

                        return;
                      }
                    }
                    print('First text FOCUS: $value');
                  },
                  child: SizedBox(
                    height: 40,
                    child: TextField(
                      keyboardType: TextInputType.emailAddress,
                      controller: _unameController,
                      decoration: InputDecoration(
                        labelText: "Email Address",
                        labelStyle: TextStyle(
                          color: MyColor.drwMenu,
                        ),
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
                SizedBox(
                  height: 40,
                  child: TextFormField(
                    controller: _passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the password';
                      }
                    },
                    obscureText: _showPswd,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(
                        color: MyColor.drwMenu,
                      ),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _showPswd = !_showPswd;
                          });
                        },
                        child: _showPswd
                            ? Icon(Icons.visibility_off)
                            : Icon(Icons.visibility),
                      ),
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
                const SizedBox(height: 50.0),
                BlocConsumer<LoginBloc, LoginState>(
                  listener: (context, state) {
                    if (state is LoginhasNetwork) {
                      loginBloc.add(SignInButtonPressed(
                          email: _unameController.text,
                          password: _passwordController.text));
                    }
                    if (state is LoginNetworkError) {
                      var customDialogWidget = CustomDialogWidget();
                      customDialogWidget.showDialogclass(context,
                          "Network Error", "Check your internet connection");
                    }

                    if (state is LoginSucced) {
                      _unameController.text = "";
                      _passwordController.text = "";
                      Get.offAllNamed("/home");
                    }
                    if (state is LoginFailed) {
                      var customDialogWidget = CustomDialogWidget();
                      customDialogWidget.showDialogclass(context, "Login Error",
                          state.message); //"Eneter valid email and password"
                    }
                  },
                  builder: (bloccontext, state) {
                    if (state is LoginLoading) {
                      return Center(child: CircularProgressIndicator());
                    } else if (state is LoginFailed) {
                      print("Error Login SSS" + state.message);
                    }

                    return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          // maximumSize: const Size(290.0, 40.0),
                          minimumSize: const Size.fromHeight(45),
                          primary: MyColor.primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                        onPressed: () {
                          if (_unameController.text.isEmpty) {
                            ErrorSnackBar().showToastWithIcon("Error",
                                "Enter Valid Email", const Icon(Icons.email));
                            return;
                          } else if (_passwordController.text.isEmpty) {
                            ErrorSnackBar().showToastWithIcon(
                                "Error",
                                "Enter Valid Password",
                                const Icon(Icons.password));
                            return;
                          } else {
                            loginBloc.add(CheckInternetLoginPressed());
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          //crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Continue",
                              style: GoogleFonts.openSans(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                            // const Icon(
                            //   Icons.lock,
                            //   color: Colors.white,
                            // ),
                          ],
                        ));
                  },
                ),
                const SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size(50, 30),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          alignment: Alignment.centerLeft),
                      onPressed: () {
                        Get.toNamed('/forgotPassword');
                        // Navigator.pushNamed(context, 'forgot');
                      },
                      child: Text('Forgot Password',
                          style: GoogleFonts.openSans(
                            color: MyColor.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          )),
                    ),
                  ],
                ),

                SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.black,
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "or sign up with",
                        style: GoogleFonts.openSans(
                          color: MyColor.textnewlight,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.black,
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(2.0, 0, 2.0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: BlocConsumer<LoginBloc, LoginState>(
                          listener: (context, state) {
                            if (state is LoginGooglehasNetwork) {
                              loginBloc.add(SignInWithGooglePressed());
                            }
                            if (state is LoginGoogleNetworkError) {
                              var customDialogWidget = CustomDialogWidget();
                              customDialogWidget.showDialogclass(
                                  context,
                                  "Network Error",
                                  "Check your internet connection");
                            }

                            if (state is LoginGoogleSucced) {
                              Get.offAllNamed("/home");
                            }
                            if (state is GmailLoginFailed) {
                              var customDialogWidget = CustomDialogWidget();
                              customDialogWidget.showDialogclass(
                                  context,
                                  "Login Error",
                                  state
                                      .message); //"Eneter valid email and password"
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

                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0)),
                              ),
                              onPressed: () {
                                loginBloc
                                    .add(CheckInternetLoginGooglePressed());
                              },
                              child: Wrap(
                                children: <Widget>[
                                  Icon(
                                    FontAwesomeIcons.google,
                                    color: MyColor.cbuttons,
                                    size: 20.0,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Google",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: MyColor.kBlackColor,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            // maximumSize: const Size(290.0, 40.0),
                            //  minimumSize: const Size.fromHeight(5),
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                          ),
                          onPressed: () {
                            Get.toNamed('/phoneScreen'); //otpScreen
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
                                width: 10,
                              ),
                              Text(
                                "Mobile",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: MyColor.kBlackColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                  height: 30,
                ),

                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                        text: TextSpan(children: [
                      TextSpan(
                        text: "Don't have an Account? ",
                        style: GoogleFonts.openSans(
                          color: Colors.black,
                          fontSize: 15.0,
                        ),
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

                const SizedBox(height: 20.0),

                // Row(
                //   children: [
                //     RichText(
                //         text: TextSpan(children: [
                //       const TextSpan(
                //         text: "Don't have an account? ",
                //         style: TextStyle(color: Colors.grey),
                //       ),
                //       TextSpan(
                //           text: " Sign up here",
                //           style: TextStyle(
                //               fontWeight: FontWeight.bold,
                //               color: MyColor.primaryColor),
                //           recognizer: TapGestureRecognizer()
                //             ..onTap = () {
                //               Get.toNamed('/register');
                //               //                          Navigator.push(
                //               // context,
                //               // MaterialPageRoute(builder: (context) => const RegisterScreen()),
                //               // );
                //             })
                //     ])),
                //   ],
                // ),

                //  const SizedBox(
                //   height: 20,
                // ),
                // // ignore: prefer_const_constructors
                // Text("---- Sign in with ----",
                //     style: const TextStyle(
                //         color: Colors.grey,
                //         fontSize: 15,
                //         fontWeight: FontWeight.w500)),
                // const SizedBox(
                //   height: 30,
                // ),
                // ElevatedButton(
                //   style: ElevatedButton.styleFrom(
                //     // maximumSize: const Size(290.0, 40.0),
                //     minimumSize: const Size.fromHeight(45),
                //     primary: Colors.white,
                //     shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(5.0)),
                //   ),
                //   onPressed: () {
                //     Get.toNamed('/phoneScreen');
                //   },
                //   child: Wrap(
                //     children: const <Widget>[
                //       Icon(
                //         Icons.phone_android_rounded,
                //         color: Colors.blue,
                //         size: 20.0,
                //       ),
                //       SizedBox(
                //         width: 30,
                //       ),
                //       Text(
                //         "Phone",
                //         style: TextStyle(fontSize: 15, color: Colors.blue),
                //       ),
                //     ],
                //   ),
                // ),

                // const SizedBox(
                //   height: 30,
                // ),
                // BlocConsumer<LoginBloc, LoginState>(
                //   listener: (context, state) {
                //     if (state is LoginSucced) {

                //       Get.toNamed("/home");
                //     } else if (state is LoginFailed) {
                //       var customDialogWidget = CustomDialogWidget();
                //       customDialogWidget.showDialogclass(
                //           context, "", state.message);//"Eneter valid email and password"
                //     }
                //   },
                //   builder: (context, state) {
                //        if (state is LoginGmailLoading) {
                //       return Center(child: CircularProgressIndicator());
                //     } else if (state is LoginFailed) {
                //       print("Error Login SSS" + state.message);
                //     }
                //     return ElevatedButton(
                //       style: ElevatedButton.styleFrom(
                //         // maximumSize: const Size(290.0, 40.0),
                //         minimumSize: const Size.fromHeight(45),
                //         primary: MyColor.googleColor,
                //         shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(5.0)),
                //       ),
                //       onPressed: () {
                //          loginBloc.add(SignInWithGooglePressed());
                //       },
                //       child: Wrap(
                //         children: <Widget>[
                //           Icon(
                //             FontAwesomeIcons.google,
                //             color: Colors.white,
                //             size: 20.0,
                //           ),
                //           SizedBox(
                //             width: 30,
                //           ),
                //           Text(
                //             "Google",
                //             style: TextStyle(fontSize: 15),
                //           ),
                //         ],
                //       ),
                //     );
                //   },
                // ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
