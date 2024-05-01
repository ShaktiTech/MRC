part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();
  
  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}
class ProfileLoading extends ProfileState {}
class ProfileDataLoading extends ProfileState {}

class ProfileSuccess extends ProfileState {}
class ProfileError extends ProfileState {
  String message;
  ProfileError({required this.message});
}

class ProfileNetworkError extends ProfileState {}
class ProfilehasNetwork extends ProfileState {}
class ProfileImageUploadedSuccess extends ProfileState {
    String imgUrl;
  ProfileImageUploadedSuccess({required this.imgUrl});
}
class ProfileImageUploadedFailure extends ProfileState {
   String message;
  ProfileImageUploadedFailure({required this.message});
}