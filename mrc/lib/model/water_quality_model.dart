// ignore_for_file: prefer_null_aware_operators

import 'dart:convert';

List<WaterQualityModel> waterQualityModelFromJson(String str) => List<WaterQualityModel>.from(json.decode(str).map((x) => WaterQualityModel.fromJson(x)));

String waterQualityModelToJson(List<WaterQualityModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class WaterQualityModel {
    WaterQualityModel({
       required this.the2010,
       required this.the2011,
       required this.the2012,
       required this.the2013,
       required this.the2014,
       required this.the2015,
       required this.the2016,
       required this.the2017,
       required this.the2018,
       required this.the2019,
       required this.the2020,
       required this.the2021,
       required this.no,
       required this.stationName,
       required this.river,
       required this.country,
       required this.lat,
       required this.lon,
    });

    String the2010;
    String the2011;
    String the2012;
    String the2013;
    String the2014;
    String the2015;
    String the2016;
    String the2017;
    String the2018;
    String the2019;
    String the2020;
    String the2021;
    int no;
    String? stationName;
    String? river;
    String? country;
    double? lat;
    double? lon;

    factory WaterQualityModel.fromJson(Map<String, dynamic> json) => WaterQualityModel(
        the2010: json["2010"],
        the2011: json["2011"],
        the2012: json["2012"],
        the2013: json["2013"],
        the2014: json["2014"],
        the2015: json["2015"],
        the2016: json["2016"],
        the2017: json["2017"],
        the2018: json["2018"],
        the2019: json["2019"],
        the2020: json["2020"],
        the2021: json["2021"],
        no: json["No."],
        stationName: json["StationName"],
        river: json["River"],
        country: json["Country"],
        lat: json["Lat"]!=null?json["Lat"].toDouble():null,
        lon: json["Lon"]!=null?json["Lon"].toDouble():null,
    );

    Map<String, dynamic> toJson() => {
        "2010": the2010,
        "2011": the2011,
        "2012": the2012,
        "2013": the2013,
        "2014": the2014,
        "2015": the2015,
        "2016": the2016,
        "2017": the2017,
        "2018": the2018,
        "2019": the2019,
        "2020": the2020,
        "2021": the2021,
        "No.": no,
        "StationName": stationName,
        "River": river,
        "Country": country,
        "Lat": lat,
        "Lon": lon,
    };
}
