import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../repository/user_repositories.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
   UserRepository userRepository;
  RegisterBloc({required this.userRepository}) : super(RegisterInitial()) {
    on<RegisterEvent>((event, emit) async{
     if (event is SignUpButtonPressed) {
      emit(RegisterLoading());

      try {
        var user = await userRepository.signUp(event.email, event.password,event.phone,event.name);
        
        emit(RegisterSucced(user: user!));
      } catch (e) {
        emit(RegisterFailed(message: e.toString()));
      }
    }
     if (event is CheckInternetRegisterPressed) {
      emit(RegisterLoading());

      try {
        var user = await userRepository.checkInternetConnection();
        if(user)
        {
          emit(RegisterhasNetwork());
        }
        else
        {
         emit(RegisterNetworkError());
        }
      }
       catch (e) {
       
       emit(RegisterNetworkError());
      }
 }
    });
  }
}
