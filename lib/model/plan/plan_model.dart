// To parse this JSON data, do
//
//     final planModel = planModelFromJson(jsonString);

import 'dart:convert';

PlanModel planModelFromJson(String str) => PlanModel.fromJson(json.decode(str));

String planModelToJson(PlanModel data) => json.encode(data.toJson());

class PlanModel {
    final String uid;
    final String name;
    final DateTime startDate;
    final DateTime endDate;
    final String description;
    final double amount;
    final bool readOnly;

    PlanModel({
        required this.uid,
        required this.name,
        required this.startDate,
        required this.endDate,
        required this.description,
        required this.amount,
        required this.readOnly,
    });

    factory PlanModel.fromJson(Map<String, dynamic> json) => PlanModel(
        uid: json["uid"],
        name: json["name"],
        startDate: DateTime.parse(json["startDate"]),
        endDate: DateTime.parse(json["endDate"]),
        description: json["description"],
        amount: json["amount"]?.toDouble(),
        readOnly: (json["readOnly"] ?? true),
    );

    Map<String, dynamic> toJson() => {
        "uid": uid,
        "name": name,
        "startDate": "${startDate.year.toString().padLeft(4, '0')}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}",
        "endDate": "${endDate.year.toString().padLeft(4, '0')}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}",
        "description": description,
        "amount": amount,
        "readOnly": readOnly,
    };
}
