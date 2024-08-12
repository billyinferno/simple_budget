// To parse this JSON data, do
//
//     final planUidModel = planUidModelFromJson(jsonString);

import 'dart:convert';

PlanUidModel planUidModelFromJson(String str) => PlanUidModel.fromJson(json.decode(str));

String planUidModelToJson(PlanUidModel data) => json.encode(data.toJson());

class PlanUidModel {
    final String uid;

    PlanUidModel({
        required this.uid,
    });

    factory PlanUidModel.fromJson(Map<String, dynamic> json) => PlanUidModel(
        uid: json["uid"],
    );

    Map<String, dynamic> toJson() => {
        "uid": uid,
    };
}
