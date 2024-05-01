part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}
class SignInButtonPressed extends LoginEvent {
  String email, password;
  SignInButtonPressed({required this.email, required this.password});
}

class SignInWithGooglePressed extends LoginEvent {
 // String email, password;
  SignInWithGooglePressed();
}

class SignInWithPhonePressed extends LoginEvent {
  String phoneNumber;
  SignInWithPhonePressed({required this.phoneNumber});
}
class SignInCodeVerifiedPressed extends LoginEvent {
  String code,vId;
  SignInCodeVerifiedPressed({required this.code,required this.vId});
}

class ForgotButtonPressed extends LoginEvent {
  String email;
  ForgotButtonPressed({required this.email});
}

class CheckInternetLoginPressed extends LoginEvent {
 // String email, password;
  CheckInternetLoginPressed();
}

class CheckInternetLoginGooglePressed extends LoginEvent {
 // String email, password;
  CheckInternetLoginGooglePressed();
}
