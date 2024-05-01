class ReportModel {
  final String image;
  final String description;
  final String incidentType;
  final String userName;
  final String location;
  final String userImage;
  final String userEmail;
  final String userPhone;

  ReportModel(
      {required this.image,
      required this.description,
      required this.incidentType,
      required this.location,
      required this.userName,
      required this.userImage,
      required this.userEmail,
      required this.userPhone}); 

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      image: json['image'],
      description: json['description'],
      incidentType: json['incidentType'],
      location: json['location'],
      userName: json['userName'],
      userImage: json['userImage'],
      userEmail: json['userEmail'],
      userPhone: json['userPhone']
    );
  }
}// userName: json['userName'], userImage: json['userImage']