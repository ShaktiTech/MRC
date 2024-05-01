import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:mrc/bloc/auth_bloc/auth_bloc.dart';
import 'package:mrc/utils/mycolor.dart';

import 'package:mrc/view/screens/home_screen.dart';
import 'package:mrc/view/screens/login_screen.dart';
import 'package:mrc/view/screens/register_screen.dart';

import '../../repository/user_repositories.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String routes = "";
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
            if (state is UnAuthenticateState) {
              routes ="/login";
            }  
            if (state is AuthenticateState) {
               routes ="/home";
            }
      },
      builder: (context, state) {
                 AuthBloc authBloc = BlocProvider.of<AuthBloc>(context);
            authBloc.add(AppLoaded());
        return initScreen(context);
      },
    );
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  startTimer() async {
    var duration = Duration(seconds: 3);
    return new Timer(duration, route);
  }

  route() {
    Get.offNamed(routes);
  }

  initScreen(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          
          gradient: MyColor.kPrimaryGradient
          // LinearGradient(
          //   begin: Alignment.centerLeft,
          //   end: Alignment.centerRight,
          //   // stops: [0.2,0.4 ,0.6],
          //   colors: [
          //     Color.fromARGB(221, 10, 123, 237),
          //     Color.fromARGB(255, 17, 109, 201),
          //     Color.fromARGB(255, 2, 55, 108)
          //   ],
          //   // transform: GradientRotation(4.745375),
          // ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Image.asset(
                  "assets/mrc-logo-white.png",
                  width: screenWidth * 0.3,
                  fit: BoxFit.contain,
                ),
                SizedBox(
                  height: 30,
                ),
                Text("MEKONG RIVER COMMISSION",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.openSans(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    )),
                //  SizedBox(height: 5,),
                Text("For Sustainable Developement",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.openSans(
                      color: Colors.white,
                      fontSize: 16.0,
                    )),
                SizedBox(
                  height: 30,
                ),

                // Lottie.asset('assets/success.json'),
              ],
            ),

            // CircularProgressIndicator(
            //   valueColor:  AlwaysStoppedAnimation<Color>(Colors.orange),
            // ),
          ],
        ),
      ),
    );
  }
}
