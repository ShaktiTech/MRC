import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrc/utils/alert_dialoge.dart';

import '../../bloc/profile_bloc/profile_bloc.dart';
import '../../utils/error_snackbar.dart';
import '../../utils/mycolor.dart';
import '../../utils/success_dialog.dart';

class ChangePassword extends StatefulWidget {
  String email;
  ChangePassword({super.key, required this.email});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  late ProfileBloc profileBloc;

  final TextEditingController _oldPswdController = new TextEditingController();

  final TextEditingController _newPswdController = new TextEditingController();

  final TextEditingController _confirmPswdController =
      new TextEditingController();

  bool _validate = false;

  bool _showOldPswd = false;

  bool _showNewPswd = false;

  bool _showConfirmPswd = false;

  String passwordMsg = "New password and confirmed password not matched";

  @override
  Widget build(BuildContext context) {
    profileBloc = BlocProvider.of<ProfileBloc>(context);
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
                    Text("Change Password",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.openSans(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 30.0,
                        )),
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
                      keyboardType: TextInputType.visiblePassword,
                      controller: _oldPswdController,
                      obscureText: _showOldPswd,
                      inputFormatters: <TextInputFormatter>[
                        LengthLimitingTextInputFormatter(32),
                      ],
                      decoration: InputDecoration(
                        labelText: "Enter Old Password",
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _showOldPswd = !_showOldPswd;
                            });
                          },
                          child: _showOldPswd
                              ? Icon(Icons.visibility_off)
                              : Icon(Icons.visibility),
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
                  onFocusChange: (value) {},
                  child: SizedBox(
                    height: 40,
                    child: TextField(
                      keyboardType: TextInputType.visiblePassword,
                      controller: _newPswdController,
                      obscureText: _showNewPswd,
                      inputFormatters: <TextInputFormatter>[
                        LengthLimitingTextInputFormatter(32),
                      ],
                      decoration: InputDecoration(
                        labelText: "Enter New Password",
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _showNewPswd = !_showNewPswd;
                            });
                          },
                          child: _showNewPswd
                              ? Icon(Icons.visibility_off)
                              : Icon(Icons.visibility),
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
                FocusScope(
                  onFocusChange: (value) {
                    // if(value != _newPswdController.text.trim())
                    // {
                    //    _validate = true;
                    // }
                    // else
                    // {
                    //   _validate = false;
                    // }
                  },
                  child: SizedBox(
                    height: 40,
                    child: TextField(
                      keyboardType: TextInputType.emailAddress,
                      controller: _confirmPswdController,
                      obscureText: _showConfirmPswd,
                      inputFormatters: <TextInputFormatter>[
                        LengthLimitingTextInputFormatter(32),
                      ],
                      decoration: InputDecoration(
                        labelText: "Confirm Password",
                        // errorText: _validate ? passwordMsg : null,
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _showConfirmPswd = !_showConfirmPswd;
                            });
                          },
                          child: _showConfirmPswd
                              ? Icon(Icons.visibility_off)
                              : Icon(Icons.visibility),
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

                BlocConsumer<ProfileBloc, ProfileState>(
                  listener: (context, state) {
                    if (state is ProfilehasNetwork) {
                      profileBloc.add(ChangePasswordPressed(
                          email: widget.email,
                          oldPassword: _oldPswdController.text.trim(),
                          newPassword: _newPswdController.text.trim()));
                    }
                    if (state is ProfileNetworkError) {
                      var customDialogWidget = CustomDialogWidget();
                      customDialogWidget.showDialogclass(context,
                          "Network Error", "Check your Internet connection");
                    }

                    if (state is ProfileSuccess) {
                      _confirmPswdController.text = "";
                      _newPswdController.text = "";
                      _oldPswdController.text = "";
                      var customDialogWidget = const SuccessDialog();
                      customDialogWidget.showDialogclass(context, "",
                          "Your password changed successfully.", "");
                    }
                    if (state is ProfileError) {
                      var customDialogWidget = CustomDialogWidget();
                      customDialogWidget.showDialogclass(
                          context, "Password Error", state.message);
                    }
                  },
                  builder: (context, state) {
                    if (state is ProfileLoading) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          // maximumSize: const Size(290.0, 40.0),
                          minimumSize: const Size.fromHeight(45),
                          backgroundColor: MyColor.primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                        onPressed: () {
                          if (_oldPswdController.text.isEmpty) {
                            ErrorSnackBar().showToastWithIcon(
                                "Error",
                                "Please eneter old password.",
                                const Icon(Icons.password));
                            return;
                          } else if (_newPswdController.text.isEmpty) {
                            ErrorSnackBar().showToastWithIcon(
                                "Error",
                                "Please enter new password.",
                                const Icon(Icons.password));
                            return;
                          } else if (_confirmPswdController.text.isEmpty) {
                            ErrorSnackBar().showToastWithIcon(
                                "Error",
                                "Please enter confirm password",
                                const Icon(Icons.password));
                            return;
                          } else if (_newPswdController.text.trim().compareTo(
                                  _confirmPswdController.text.trim()) !=
                              0) {
                            ErrorSnackBar().showToastWithIcon("Error",
                                passwordMsg, const Icon(Icons.password));
                          } else {
                            profileBloc.add(CheckInternetProfilePressed());
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
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
