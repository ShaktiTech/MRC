part of 'report_bloc.dart';

abstract class ReportState extends Equatable {
  const ReportState();
  
  @override
  List<Object> get props => [];
}

class ReportInitial extends ReportState {}
class ReportLoading extends ReportState {}
class ReportButtonLoading extends ReportState {}
class ImageUploadedSuccess extends ReportState {
    String imgUrl;
  ImageUploadedSuccess({required this.imgUrl});
}
class ImageUploadedFailure extends ReportState {
   String message;
  ImageUploadedFailure({required this.message});
}
class IncidentSelectedState extends ReportState {
    String incidentType;
  IncidentSelectedState({required this.incidentType});
}
class IncidentNotSelectedState extends ReportState {
    String message;
  IncidentNotSelectedState({required this.message});
}
class ReportFailure extends ReportState {
   String message;
  ReportFailure({required this.message});
}
class ReportSaveSucccess extends ReportState {

}
class ReportLoadedState extends ReportState {
    List<ReportModel> reportList =[];
  ReportLoadedState(this.reportList);
}