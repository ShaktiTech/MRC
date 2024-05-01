import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrc/bloc/register_bloc/register_bloc.dart';
import 'package:mrc/utils/alert_dialoge.dart';
import 'package:mrc/utils/mycolor.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../utils/error_snackbar.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var reg = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  bool _showPswd = true;

  TextEditingController _unameController = new TextEditingController();

  TextEditingController _passwordController = new TextEditingController();

  TextEditingController _emailController = new TextEditingController();

  TextEditingController _phoneController = new TextEditingController();

  late RegisterBloc registerBloc;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    registerBloc = BlocProvider.of<RegisterBloc>(context);
    return Scaffold(
      body: Stack(children: [
        SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.1,
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
                      "Sign Up",
                      style: GoogleFonts.openSans(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 30.0,
                      ),
                    ),
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
                        "Please enter your details here",
                        overflow: TextOverflow.visible,
                        style: GoogleFonts.openSans(
                          color: MyColor.textligth,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 30,
                ),
                FocusScope(
                  onFocusChange: (value) {
                    // if (!value) {
                    //   if (_unameController.text.isEmpty) {
                    //     ErrorSnackBar().showToastWithIcon("Error",
                    //         "Enter Your Name", const Icon(Icons.email));

                    //     return;
                    //   }
                    // }
                    // print('First text FOCUS: $value');
                  },
                  child: SizedBox(
                    height: 40,
                    child: TextField(
                      keyboardType: TextInputType.name,
                      controller: _unameController,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp("[a-z A-Z]"))
                      ],
                      decoration: InputDecoration(
                        labelText: "Full Name",
                        labelStyle: GoogleFonts.openSans(
                          color: MyColor.textligth,
                          fontSize: 16.0,
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
                        labelText: "Email Address",
                        labelStyle: GoogleFonts.openSans(
                          color: MyColor.textligth,
                          fontSize: 16.0,
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
                const SizedBox(
                  height: 40,
                ),
                FocusScope(
                  onFocusChange: (value) {
                    // if (!value) {
                    //   if (_phoneController.text.isEmpty) {
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
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(11),
                      ],
                      controller: _phoneController,
                      decoration: InputDecoration(
                        labelText: "Phone Number",
                        labelStyle: GoogleFonts.openSans(
                          color: MyColor.textligth,
                          fontSize: 16.0,
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

                const SizedBox(height: 40.0),
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
                    inputFormatters: <TextInputFormatter>[
                      LengthLimitingTextInputFormatter(32),
                    ],
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: GoogleFonts.openSans(
                        color: MyColor.textligth,
                        fontSize: 16.0,
                      ),
                      fillColor: MyColor.secondPageTitleColor,
                      filled: true,
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _showPswd = !_showPswd;
                          });

                          // setState(() {

                          // });
                        },
                        child: _showPswd
                            ? Icon(Icons.visibility_off)
                            : Icon(Icons.visibility),
                      ),
                      contentPadding: EdgeInsets.all(8.0),
                      // hintText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 50.0),
                BlocConsumer<RegisterBloc, RegisterState>(
                  listener: (bloccontext, state) {
                    if (state is RegisterhasNetwork) {
                      registerBloc.add(SignUpButtonPressed(
                          email: _emailController.text.trim(),
                          password: _passwordController.text.trim(),
                          phone: _phoneController.text.trim(),
                          name: _unameController.text.trim()));
                    }
                    if (state is RegisterNetworkError) {
                      var customDialogWidget = CustomDialogWidget();
                      customDialogWidget.showDialogclass(context,
                          "Network Error", "Check your Internet connection");
                    }

                    if (state is RegisterSucced) {
                      _emailController.text = "";
                      _unameController.text = "";
                      _passwordController.text = "";
                      _phoneController.text = "";
                      Get.offAllNamed("/home");
                    }
                    if (state is RegisterFailed) {
                      var customDialogWidget = CustomDialogWidget();
                      customDialogWidget.showDialogclass(
                          context, "Alert", state.message);
                    }
                  },
                  builder: (context, state) {
                    if (state is RegisterLoading) {
                      return Center(child: CircularProgressIndicator());
                    }
                    // else
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
                            ErrorSnackBar().showToastWithIcon(
                                "Error",
                                "Please enter your name",
                                const Icon(Icons.password));
                            return;
                          } else if (_emailController.text.isEmpty ||
                              !reg.hasMatch(_emailController.text)) {
                            ErrorSnackBar().showToastWithIcon(
                                "Error",
                                "Please enter valid email address",
                                const Icon(Icons.email));
                            return;
                          } else if (_phoneController.text.isEmpty ||
                              _phoneController.text.length < 10) {
                            ErrorSnackBar().showToastWithIcon(
                                "Error",
                                "Please enter valid phone number",
                                const Icon(Icons.email));
                            return;
                          } else if (_passwordController.text.isEmpty) {
                            ErrorSnackBar().showToastWithIcon(
                                "Error",
                                "Please enter valid password",
                                const Icon(Icons.password));
                            return;
                          } else {
                            registerBloc.add(CheckInternetRegisterPressed());
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          //crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Sign up",
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
                const SizedBox(height: 30.0),
                Row(
                  children: [
                    RichText(
                        text: TextSpan(children: [
                      const TextSpan(
                        text: "Already have an Account? ",
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                      TextSpan(
                          text: "Login here",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: MyColor.primaryColor),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Get.toNamed('/login');
                            })
                    ])),
                  ],
                ),

                const SizedBox(
                  height: 40,
                ),
                // ignore: prefer_const_constructors
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
