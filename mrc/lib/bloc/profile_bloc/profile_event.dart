part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}
class ChangePasswordPressed extends ProfileEvent {
  String email, oldPassword,newPassword;
  ChangePasswordPressed({required this.email, required this.oldPassword, required this.newPassword});
}
class CheckInternetProfilePressed extends ProfileEvent {

  CheckInternetProfilePressed();
}
class ProfileImageButtonPressed extends ProfileEvent {
  ImageSource source;
  ProfileImageButtonPressed({required this.source});
}
class UpdateProfilePressed extends ProfileEvent {
  String email, name,phone,image;
  UpdateProfilePressed({required this.email, required this.name, required this.phone, required this.image});
}