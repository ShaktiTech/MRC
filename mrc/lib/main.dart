import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:mrc/repository/user_repositories.dart';
import 'package:mrc/routes.dart';
import 'package:mrc/utils/mycolor.dart';
import 'package:mrc/view/screens/login_screen.dart';
import 'package:mrc/view/screens/splash_screen.dart';

import 'bloc/auth_bloc/auth_bloc.dart';
import 'view/screens/home_screen.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
 WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
 FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => UserRepository(firebaseAuth: FirebaseAuth.instance),
      child: BlocProvider(
        create: (context) =>
            AuthBloc(userRepository: context.read<UserRepository>()),
        child: GetMaterialApp(
          title: '',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch().copyWith(
              primary: MyColor.primaryColor,
              secondary: Colors.blue,

              // or from RGB
            ),
          ),
          onGenerateRoute: Routes.onGenerateRoute,
          // initialRoute: "/splash",

          home: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
               if (state is AuthenticateState) {
                FlutterNativeSplash.remove();
                    Get.offAllNamed('/home');
                  } else if (state is UnAuthenticateState) {
                    FlutterNativeSplash.remove();
                      Get.offAllNamed('/login');
                  }
            },
            builder: (context, state) {
               AuthBloc authBloc = BlocProvider.of<AuthBloc>(context);
                  authBloc.add(AppLoaded());
                    return Container(child:const Center(child: CircularProgressIndicator()),
                    color: Colors.white,);
             
            },
          ),
        ),
      ),
    );
  }
  
}
