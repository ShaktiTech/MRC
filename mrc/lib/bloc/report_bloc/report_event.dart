part of 'report_bloc.dart';

abstract class ReportEvent extends Equatable {
  const ReportEvent();

  @override
  List<Object> get props => [];
}

class ImageButtonPressed extends ReportEvent {
  ImageSource source;
  ImageButtonPressed({required this.source});
}

class IncidentButtonPressed extends ReportEvent {
  String incidentType;
  IncidentButtonPressed({required this.incidentType});
}

class SaveReportButtonPressed extends ReportEvent {
  String latLong;
  String incidentType;
  String description;
  String imageUrl;
  String userId;
  String userName;
  String userImage;
  String userEmail;
  String userPhone;
  SaveReportButtonPressed(
      {required this.latLong,
      required this.incidentType,
      required this.description,
      required this.imageUrl,
      required this.userId,
      required this.userName,
      required this.userImage,
      required this.userEmail,
      required this.userPhone});
}

class GetDataEvent extends ReportEvent {
  GetDataEvent();
}
