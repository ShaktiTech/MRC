import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mrc/repository/user_repositories.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
   UserRepository userRepository;

   
  AuthBloc({required this.userRepository}) : super(AuthInitial())  {
    // ignore: void_checks
    on<AuthEvent>((event, emit) async {
       print("SSS event ${event}");
       if (event is AppLoaded) {
         
      try {
        var isSignedIn = await userRepository.isSignedIn();

        if (isSignedIn) {
          var user = await userRepository.getCurrentUser();
          print("SSS 1");
          emit(AuthenticateState(user: user!));
          
         // yield AuthenticateState(user: user!);
        } else {
          print("SSS 2");
          emit(UnAuthenticateState());

        }
      } catch (e) {
        print("SSS 3");
        emit(UnAuthenticateState());
      }
    }
    });
  }
}
