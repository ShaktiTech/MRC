part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();
  
  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}


class LoginLoading extends LoginState {}
class LoginGmailLoading extends LoginState {}
class Codesent extends LoginState {
  String vId;
   
  Codesent({required this.vId});
 
}
class Codefailed extends LoginState {

}
class LoginSucced extends LoginState {
  User user;
  LoginSucced({required this.user});
}
class LoginGoogleSucced extends LoginState {
  User user;
  LoginGoogleSucced({required this.user});
}

class LoginFailed extends LoginState {
  String message;
  LoginFailed({required this.message});
}
class GmailLoginFailed extends LoginState {
  String message;
  GmailLoginFailed({required this.message});
}
class ResetLinkFailed extends LoginState {
  String message;
  ResetLinkFailed({required this.message});
}

class LoginNetworkError extends LoginState {}
class LoginhasNetwork extends LoginState {}
class LoginGoogleNetworkError extends LoginState {}
class LoginGooglehasNetwork extends LoginState {}
