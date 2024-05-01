import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../repository/user_repositories.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  UserRepository userRepository;
  LoginBloc({required this.userRepository}) : super(LoginInitial()) {
    on<LoginEvent>((event, emit) async{

      //********Sing with Email Password********** */


      if (event is SignInButtonPressed) {
      emit(LoginLoading());

      try {
        var user = await userRepository.signIn(event.email, event.password);
         if(user !=null)
        {
          emit(LoginSucced(user: user));
        }
        else
        {
         emit( LoginFailed(message: "Something went wrong, please try again later."));
        }
        
      }
      on FirebaseAuthException catch (e) {
          if(e.code == "account-exists-with-different-credential")
        {
   
          emit(LoginFailed(message: "You already have an account with us. Use correct provider"));
        }
        else if(e.code =="wrong-password")
        {

        emit(LoginFailed(message: "The password used to login is invalid. Please enter the correct password."));
        }
         else if(e.code =="user-not-found")
        {

        emit(LoginFailed(message: "There is no user found corresponding to this email address."));
        }
         else if(e.code =="null")
        {

  emit(LoginFailed(message: "Some unexpected error while trying to sign in"));
        }
          else
        {
 print("sss Error sss ${e.code+"-----"+e.toString()}");
  emit(LoginFailed(message: "Some unexpected error while trying to sign in, please try again later."));
        }
       
        
      }
       catch (e) {
      //user-not-found
        emit(LoginFailed(message: "Some unexpected error while trying to sign in, please try again later."));
    }
    }

 //********Sing with Google********** */
     if (event is SignInWithGooglePressed) {
      emit(LoginGmailLoading());

      try {
        var user = await userRepository.signInWithGoogle();
       if(user != null)
       {
   emit(LoginGoogleSucced(user: user));
       }
       else{
        emit(GmailLoginFailed(message: "Some unexpected error while trying to sign in, please try again later."));
   
       }
     
      } catch (e) {
        emit(GmailLoginFailed(message: e.toString()));
      }
    }

     //********Sing with Phone********** */
     if (event is SignInWithPhonePressed) {
      emit(LoginLoading());

      try {
        var isSent = await userRepository.sendCode(event.phoneNumber);
       // emit(Codesent(vId: ""));
         if(isSent.isNotEmpty)
        {
           emit(Codesent(vId: isSent));
         
        }
        else
        {
        
           emit(LoginFailed(message: "Some unexpected error while trying to send otp, please try again later."));
        }
       
      }
        on FirebaseAuthException catch (e) {
          if(e.code == "account-exists-with-different-credential")
        {
   
          emit(LoginFailed(message: "You already have an account with us. Use correct provider"));
        }
        else if(e.code =="wrong-password")
        {

        emit(LoginFailed(message: "The password used to login is invalid. Please enter the correct password."));
        }
         else if(e.code =="user-not-found")
        {

        emit(LoginFailed(message: "There is no user found corresponding to this email address."));
        }
         else if(e.code =="null")
        {

  emit(LoginFailed(message: "Some unexpected error while trying to send otp"));
        }
          else
        {
 
  emit(LoginFailed(message: "Some unexpected error while trying to send otp, please try again later."));
        }
       
        
      }
      catch (e) {
        emit(LoginFailed(message: "Some unexpected error while trying to send otp, please try again later."));
      }
    }

     //********Otp Verification ********** */
     if (event is SignInCodeVerifiedPressed) {
      emit(LoginLoading());

      try {
        var user = await userRepository.verify(event.code,event.vId);
        if(user != null)
        {
 emit(LoginSucced(user: user));
        }
        else
        {
            emit(LoginFailed(message: "Some unexpected error while verifing otp"));
        }
      
      }
      on FirebaseAuthException catch (e) {
          if(e.code == "account-exists-with-different-credential")
        {
   
          emit(LoginFailed(message: "You already have an account with us. Use correct provider"));
        }
        else if(e.code =="invalid-verification-code")
        {

        emit(LoginFailed(message: "The sms verification code used to verify the phone number is invalid. Please re-enter the verification code."));
        }
        
         else if(e.code =="null")
        {

  emit(LoginFailed(message: "Some unexpected error while verifing otp"));
        }
          else
        {
      print("SSS OTP ERROR ${e.toString()}");
  emit(LoginFailed(message: "Some unexpected error while verifing otp, please try again later."));
        }
       
        
      }
      catch (e) {
        emit(LoginFailed(message: "Some unexpected error while verifing otp, please try again later."));
      }
       
    }

     //********Forgot Password********** */

    if (event is ForgotButtonPressed) {
      emit(LoginLoading());

      try {
        var user = await userRepository.forgotPassword(event.email);
        if(user)
        {
emit(Codesent(vId: ""));
        }
        else
        {
          emit(ResetLinkFailed(message: "Some unexpected error while trying to generate reset link."));
        }
        print("Email Bool ${user}");
        
      } 
       on FirebaseAuthException catch (e) {
          if(e.code == "account-exists-with-different-credential")
        {
   
          emit(ResetLinkFailed(message: "You already have an account with us. Use correct provider"));
        }
        else if(e.code =="invalid-email")
        {

        emit(ResetLinkFailed(message: "The email address is badly formatted."));
        }
         else if(e.code =="user-not-found")
        {

        emit(ResetLinkFailed(message: "There is no user found corresponding to this email address."));
        }
         else if(e.code =="null")
        {

  emit(ResetLinkFailed(message: "Some unexpected error while trying to sign in"));
        }
          else
        {
 print("sss Error sss ${e.code+"-----"+e.toString()}");
  emit(ResetLinkFailed(message: "Some unexpected error while trying to generate reset link."));
        }
       }

      catch (e) {
         print("Email Bool sss ${e}");
        emit(ResetLinkFailed(message: "Some unexpected error while trying to generate reset link."));
      }
    }

 if (event is CheckInternetLoginPressed) {
      emit(LoginLoading());

      try {
        var user = await userRepository.checkInternetConnection();
        if(user)
        {
          emit(LoginhasNetwork());
        }
        else
        {
         emit(LoginNetworkError());
        }
      }
       catch (e) {
       
       emit(LoginNetworkError());
      }
 }

  if (event is CheckInternetLoginGooglePressed) {
      emit(LoginGmailLoading());

      try {
        var user = await userRepository.checkInternetConnection();
        if(user)
        {
          emit(LoginGooglehasNetwork());
        }
        else
        {
         emit(LoginGoogleNetworkError());
        }
      }
       catch (e) {
       
       emit(LoginGoogleNetworkError());
      }
 }
    });
  }

}
