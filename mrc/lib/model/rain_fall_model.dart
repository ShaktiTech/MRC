// To parse this JSON data, do
//
//     final welcome2 = welcome2FromJson(jsonString);

import 'dart:convert';

RainFallModel RainFallModelFromJson(String str) => RainFallModel.fromJson(json.decode(str));

String RainFallModelToJson(RainFallModel data) => json.encode(data.toJson());

class RainFallModel {
    RainFallModel({
       required this.type,
       required this.features,
    });

    String type;
    List<Feature> features;

    factory RainFallModel.fromJson(Map<String, dynamic> json) => RainFallModel(
        type: json["type"],
        features: List<Feature>.from(json["features"].map((x) => Feature.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "features": List<dynamic>.from(features.map((x) => x.toJson())),
    };
}

class Feature {
    Feature({
       required this.type,
       required this.geometry,
       required this.properties,
    });

    String type;
    Geometry geometry;
    Properties properties;

    factory Feature.fromJson(Map<String, dynamic> json) => Feature(
        type: json["type"],
        geometry: Geometry.fromJson(json["geometry"]),
        properties: Properties.fromJson(json["properties"]),
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "geometry": geometry.toJson(),
        "properties": properties.toJson(),
    };
}

class Geometry {
    Geometry({
       required this.type,
       required this.coordinates,
    });

    String type;
    List<double> coordinates;

    factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
        type: json["type"],
        coordinates: List<double>.from(json["coordinates"].map((x) => x.toDouble())),
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "coordinates": List<dynamic>.from(coordinates.map((x) => x)),
    };
}

class Properties {
    Properties({
       required this.hymos,
       required this.longCo,
       required this.latCo,
       required this.staName,
       required this.mm,
    });

    int hymos;
    double longCo;
    double latCo;
    String staName;
    num mm;

    factory Properties.fromJson(Map<String, dynamic> json) => Properties(
        hymos: json["HYMOS"],
        longCo: json["LONG_CO"].toDouble(),
        latCo: json["LAT_CO"].toDouble(),
        staName: json["StaName"],
        mm: json["mm"],
    );

    Map<String, dynamic> toJson() => {
        "HYMOS": hymos,
        "LONG_CO": longCo,
        "LAT_CO": latCo,
        "StaName": staName,
        "mm": mm,
    };
}
