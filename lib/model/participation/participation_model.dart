// To parse this JSON data, do
//
//     final participationModel = participationModelFromJson(jsonString);

import 'dart:convert';

ParticipationModel participationModelFromJson(String str) => ParticipationModel.fromJson(json.decode(str));

String participationModelToJson(ParticipationModel data) => json.encode(data.toJson());

class ParticipationModel {
    final int id;
    final String name;

    ParticipationModel({
        required this.id,
        required this.name,
    });

    factory ParticipationModel.fromJson(Map<String, dynamic> json) => ParticipationModel(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}
