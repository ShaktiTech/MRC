import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mrc/model/report_model.dart';
import 'package:mrc/repository/report_repositories.dart';

part 'report_event.dart';
part 'report_state.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  ReportRepository userRepository;

  ReportBloc({required this.userRepository}) : super(ReportInitial()) {
    on<ReportEvent>((event, emit) async {
      if (event is ImageButtonPressed) {
        emit(ReportLoading());

        try {
          var user = await userRepository.uploadImage(event.source);
          if (user.isNotEmpty) {
            print("Upload Image 112 ${user}");
            emit(ImageUploadedSuccess(imgUrl: user));
          } else {
            emit(ImageUploadedFailure(message: "Something went wrong,"));
          }
        } catch (e) {}
      }

      if (event is IncidentButtonPressed) {
        if (event.incidentType.compareTo("Select Incident") == 0) {
          emit(IncidentNotSelectedState(message: "Select Incident"));
        } else {
          emit(IncidentSelectedState(incidentType: event.incidentType));
        }
      }

      if (event is SaveReportButtonPressed) {
        emit(ReportButtonLoading());
        try {
          bool value = await userRepository.addReport(
              event.latLong,
              event.incidentType,
              event.description,
              event.imageUrl,
              event.userId,
              event.userName,
              event.userImage,
              event.userEmail,
              event.userPhone);
          if (value) {
            emit(ReportSaveSucccess());
          } else {
            emit(ReportFailure(
                message: "Somethig went wrong, please try againg later"));
          }
        } catch (e) {
          emit(ReportFailure(
              message: "Somethig went wrong, please try againg later"));
        }
      }

      if (event is GetDataEvent) {
        emit(ReportLoading());
        await Future.delayed(const Duration(seconds: 1));
        try {
          final data = await userRepository.getReport();
          print("get Data SSS ${data}");
          emit(ReportLoadedState(data));
        } catch (e) {
          print("get Data SSS error ${e}");
          emit(ReportFailure(message: e.toString()));
        }
      }
    });
  }
}
