import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mrc/bloc/login_bloc/login_bloc.dart';
import 'package:mrc/bloc/profile_bloc/profile_bloc.dart';
import 'package:mrc/bloc/report_bloc/report_bloc.dart';
import 'package:mrc/view/screens/change_password_screen.dart';
import 'package:mrc/view/screens/dashboard_screen.dart';
import 'package:mrc/view/screens/forecasting_screen.dart';
import 'package:mrc/view/screens/google_map_screen.dart';
import 'package:mrc/view/screens/home_screen.dart';
import 'package:mrc/view/screens/login_screen.dart';
import 'package:mrc/view/screens/otp_screen.dart';
import 'package:mrc/view/screens/personalize_screen.dart';
import 'package:mrc/view/screens/phone_screen.dart';
import 'package:mrc/view/screens/profile_screen.dart';
import 'package:mrc/view/screens/register_screen.dart';
import 'package:mrc/view/screens/splash_screen.dart';

import 'bloc/auth_bloc/auth_bloc.dart';
import 'bloc/drawer_bloc/drawer_bloc.dart';
import 'bloc/register_bloc/register_bloc.dart';
import 'repository/report_repositories.dart';
import 'repository/user_repositories.dart';
import 'view/screens/forgot_screen.dart';
import 'view/screens/ireport_screen.dart';

class Routes {
  static Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/login":
        return MaterialPageRoute(
            builder: (context) => RepositoryProvider(
                  create: (context) =>
                      UserRepository(firebaseAuth: FirebaseAuth.instance),
                  child: BlocProvider(
                    create: (context) => LoginBloc(
                        userRepository: context.read<UserRepository>()),
                    child: LoginScreen(),
                  ),
                ));
      case "/register":
        return MaterialPageRoute(
            builder: (context) => RepositoryProvider(
                  create: (context) =>
                      UserRepository(firebaseAuth: FirebaseAuth.instance),
                  child: BlocProvider(
                    create: (context) => RegisterBloc(
                        userRepository: context.read<UserRepository>()),
                    child: RegisterScreen(),
                  ),
                ));
      case "/splash":
        return MaterialPageRoute(
            builder: (context) => RepositoryProvider(
                  create: (context) =>
                      UserRepository(firebaseAuth: FirebaseAuth.instance),
                  child: BlocProvider(
                    create: (context) => AuthBloc(
                        userRepository: context.read<UserRepository>()),
                    child: const SplashScreen(),
                  ),
                ));
      case "/forgotPassword":
        return MaterialPageRoute(
            builder: (context) => RepositoryProvider(
                  create: (context) =>
                      UserRepository(firebaseAuth: FirebaseAuth.instance),
                  child: BlocProvider(
                    create: (context) => LoginBloc(
                        userRepository: context.read<UserRepository>()),
                    child: ForgotScreen(),
                  ),
                ));
      // case "/login":
      // Map<String,dynamic> arguments = settings.arguments as Map<String,dynamic>;
      //  return MaterialPageRoute(
      //   builder: (context) => BlocProvider(
      //     create: (context)=> AuthCubit(),
      //     child: Login(title :arguments["title"]),
      //     )
      //   );

      case "/forecasting":
        return MaterialPageRoute(
            builder: (context) => RepositoryProvider(
                  create: (context) =>
                      ReportRepository(firebaseAuth: FirebaseAuth.instance),
                  child: BlocProvider(
                    create: (context) => ReportBloc(
                        userRepository: context.read<ReportRepository>()),
                    child: DashboardScreen(), //HomeScreen(),
                  ),
                ));
      //  return MaterialPageRoute(builder: (context) => const HomeScreen());

      case "/home":
        return MaterialPageRoute(
            builder: (context) => const ForecastingScreen());

      case "/profile":
       return MaterialPageRoute(
            builder: (context) => RepositoryProvider(
                  create: (context) =>
                      UserRepository(firebaseAuth: FirebaseAuth.instance),
                  child: BlocProvider(
                    create: (context) => ProfileBloc(
                        userRepository: context.read<UserRepository>()),
                    child: ProfileScreen(),
                  ),
                ));
 

      case "/map":
        return MaterialPageRoute(builder: (context) => GoogleMapScreen());

      case "/ireport":
        return MaterialPageRoute(
            builder: (context) => RepositoryProvider(
                  create: (context) =>
                      ReportRepository(firebaseAuth: FirebaseAuth.instance),
                  child: BlocProvider(
                    create: (context) => ReportBloc(
                        userRepository: context.read<ReportRepository>()),
                    child: IreportScreen(),
                  ),
                ));

      case "/personalize":
        return MaterialPageRoute(builder: (context) =>HomeScreen()); // PersonalizeScreen()

      case "/changePassword":
        Map<String, dynamic> arguments =
            settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (context) => RepositoryProvider(
                  create: (context) =>
                      UserRepository(firebaseAuth: FirebaseAuth.instance),
                  child: BlocProvider(
                    create: (context) => ProfileBloc(
                        userRepository: context.read<UserRepository>()),
                    child: ChangePassword(
                      email: arguments["email"],
                    ),
                  ),
                ));

      case "/phoneScreen":
        return MaterialPageRoute(
            builder: (context) => RepositoryProvider(
                  create: (context) =>
                      UserRepository(firebaseAuth: FirebaseAuth.instance),
                  child: BlocProvider(
                    create: (context) => LoginBloc(
                        userRepository: context.read<UserRepository>()),
                    child: PhoneScreen(),
                  ),
                ));
      case "/otpScreen":
        Map<String, dynamic> arguments =
            settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (context) => RepositoryProvider(
                  create: (context) =>
                      UserRepository(firebaseAuth: FirebaseAuth.instance),
                  child: BlocProvider(
                    create: (context) => LoginBloc(
                        userRepository: context.read<UserRepository>()),
                    child: OtpScreen(
                        phoneNo: arguments["phone"], vId: arguments["vId"]),
                  ),
                ));
      default:
        return null;
    }
  }
}
