part of 'register_bloc.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}
class SignUpButtonPressed extends RegisterEvent {
  String email, password,phone,name;
  SignUpButtonPressed({required this.email, required this.password,required this.phone, required this.name});
}
class CheckInternetRegisterPressed extends RegisterEvent {
 // String email, password;
  CheckInternetRegisterPressed();
}