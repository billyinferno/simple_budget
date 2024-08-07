// To parse this JSON data, do
//
//     final pinVerifyModel = pinVerifyModelFromJson(jsonString);

import 'dart:convert';

PinVerifyModel pinVerifyModelFromJson(String str) => PinVerifyModel.fromJson(json.decode(str));

String pinVerifyModelToJson(PinVerifyModel data) => json.encode(data.toJson());

class PinVerifyModel {
    final String uid;
    final String pin;

    PinVerifyModel({
        required this.uid,
        required this.pin,
    });

    factory PinVerifyModel.fromJson(Map<String, dynamic> json) => PinVerifyModel(
        uid: json["uid"],
        pin: json["pin"],
    );

    Map<String, dynamic> toJson() => {
        "uid": uid,
        "pin": pin,
    };
}
