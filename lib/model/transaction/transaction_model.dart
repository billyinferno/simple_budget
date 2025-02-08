// To parse this JSON data, do
//
//     final transactionModel = transactionModelFromJson(jsonString);

import 'dart:convert';

TransactionModel transactionModelFromJson(String str) => TransactionModel.fromJson(json.decode(str));

String transactionModelToJson(TransactionModel data) => json.encode(data.toJson());

class TransactionModel {
    final int id;
    final DateTime date;
    final double amount;
    final String description;

    TransactionModel({
        required this.id,
        required this.date,
        required this.amount,
        required this.description,
    });

    factory TransactionModel.fromJson(Map<String, dynamic> json) => TransactionModel(
        id: json["id"],
        date: DateTime.parse(json["date"]),
        amount: (json["amount"] == null ? 0 : json["amount"]?.toDouble()),
        description: json["description"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "amount": amount,
        "description": description,
    };
}
