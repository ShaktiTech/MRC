import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

import '../../repository/user_repositories.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  UserRepository userRepository;
  ProfileBloc({required this.userRepository}) : super(ProfileInitial()) {
    on<ProfileEvent>((event, emit) async {
      if (event is ChangePasswordPressed) {
        emit(ProfileLoading());
        try {
          print("Old Password 1 ${event.oldPassword} -- ${event.newPassword}");
          bool? user = await userRepository.changePassword(
              event.email, event.oldPassword, event.newPassword);
          if (user != null) {
            if (user) {
              emit(ProfileSuccess());
            } else {
              //  print("SSS Error 1 ${user}");
              emit(ProfileError(
                  message:
                      "Your password is not correct. please enter correct password"));
            }
          } else {
            //   print("SSS Error 2 ${user}");
            emit(ProfileError(
                message: "Something went wrong, please try again later."));
          }
        } on FirebaseAuthException catch (e) {
          if (e.code == "account-exists-with-different-credential") {
            emit(ProfileError(
                message:
                    "You already have an account with us. Use correct provider"));
          } else if (e.code == "wrong-password") {
            emit(ProfileError(
                message:
                    "The password used is invalid. Please enter the correct password."));
          } else if (e.code == "user-not-found") {
            emit(ProfileError(
                message:
                    "There is no user found corresponding to this email address."));
          } else if (e.code == "null") {
            emit(ProfileError(
                message: "Some unexpected error while trying to sign in"));
          } else {
            //print("sss Error sss ${e.code+"-----"+e.toString()}");
            emit(ProfileError(
                message:
                    "Some unexpected error while trying to sign in, please try again later."));
          }
        } catch (e) {
          //user-not-found
          emit(ProfileError(
              message:
                  "Some unexpected error while trying to sign in, please try again later."));
        }
      }
      if (event is CheckInternetProfilePressed) {
        emit(ProfileLoading());

        try {
          var user = await userRepository.checkInternetConnection();
          if (user) {
            emit(ProfilehasNetwork());
          } else {
            emit(ProfileNetworkError());
          }
        } catch (e) {
          emit(ProfileNetworkError());
        }
      }

      if (event is ProfileImageButtonPressed) {
        emit(ProfileLoading());

        try {
          var user = await userRepository.uploadImage(event.source);
          if (user.isNotEmpty) {
            print("Upload Image 112 ${user}");
            emit(ProfileImageUploadedSuccess(imgUrl: user));
          } else {
            emit(ProfileImageUploadedFailure(message: "Something went wrong,"));
          }
        } catch (e) {}
      }

      if (event is UpdateProfilePressed) {
        emit(ProfileDataLoading());
        try {
          bool? user = await userRepository.updateProfile(
              event.name, event.email, event.phone, event.image);
          if (user != null) {
            if (user) {
              print("SSS Profile Update ${user}");
              emit(ProfileSuccess());
            } else {
              //  print("SSS Error 1 ${user}");
              print("SSS Profile Update ${user}");
              emit(ProfileError(
                  message: "Something went wrong, please try again later."));
            }
          } else {
            //   print("SSS Error 2 ${user}");
            emit(ProfileError(
                message: "Something went wrong, please try again later."));
          }
        } on FirebaseAuthException catch (e) {
          if (e.code == "user-not-found") {
            emit(ProfileError(
                message:
                    "There is no user found corresponding to this email address."));
          } else if (e.code == "null") {
            emit(ProfileError(
                message:
                    "Some unexpected error while trying to update profile"));
          } else {
            //print("sss Error sss ${e.code+"-----"+e.toString()}");
            emit(ProfileError(
                message:
                    "Some unexpected error while trying to update profile, please try again later."));
          }
        } catch (e) {
          //user-not-found
          emit(ProfileError(
              message:
                  "Some unexpected error while trying to update profile, please try again later."));
        }
      }
    });
  }
}
