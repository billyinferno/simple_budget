// To parse this JSON data, do
//
//     final planModel = planModelFromJson(jsonString);

import 'dart:convert';

import 'package:simple_budget/model/_index.g.dart';

PlanModel planModelFromJson(String str) => PlanModel.fromJson(json.decode(str));

String planModelToJson(PlanModel data) => json.encode(data.toJson());

enum ContributionStatus {
  none, full, partial
}
class PlanModel {
    final String uid;
    final String name;
    final DateTime startDate;
    final DateTime endDate;
    final String description;
    final double amount;
    final bool readOnly;
    final String pin;
    final List<ParticipationModel> participations;
    final Map<String, List<ContributionModel>>? contributions;
    final List<TransactionModel>? transactions;

    PlanModel({
        required this.uid,
        required this.name,
        required this.startDate,
        required this.endDate,
        required this.description,
        required this.amount,
        required this.readOnly,
        required this.pin,
        required this.participations,
        this.contributions,
        this.transactions,
    });

    factory PlanModel.fromJson(Map<String, dynamic> json) => PlanModel(
        uid: json["uid"],
        name: json["name"],
        startDate: DateTime.parse(json["startDate"]),
        endDate: DateTime.parse(json["endDate"]),
        description: (json["description"] ?? ''),
        amount: (json["amount"] == null ? 0 : json["amount"]?.toDouble()),
        readOnly: (json["readOnly"] ?? true),
        pin: json["pin"],
        participations: List<ParticipationModel>.from(json["participations"].map((x) => ParticipationModel.fromJson(x))),
        contributions: (json["contributions"] == null ? {} : Map.from(json["contributions"]).map((k, v) => MapEntry<String, List<ContributionModel>>(k, List<ContributionModel>.from(v.map((x) => ContributionModel.fromJson(x)))))),
        transactions: (json["transactions"] == null ? [] : List<TransactionModel>.from(json["transactions"].map((x) => TransactionModel.fromJson(x)))),
    );

    Map<String, dynamic> toJson() => {
        "uid": uid,
        "name": name,
        "startDate": "${startDate.year.toString().padLeft(4, '0')}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}",
        "endDate": "${endDate.year.toString().padLeft(4, '0')}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}",
        "description": description,
        "amount": amount,
        "readOnly": readOnly,
        "pin": pin,
        "participations": List<dynamic>.from(participations.map((x) => x.toJson())),
        "contributions": (contributions == null ? "{}" : Map.from(contributions!).map((k, v) => MapEntry<String, dynamic>(k, List<dynamic>.from(v.map((x) => x.toJson()))))),
        "transactions": (transactions == null ? "[]" : List<dynamic>.from(transactions!.map((x) => x.toJson()))),
    };
}
