// To parse this JSON data, do
//
//     final callBackModel = callBackModelFromJson(jsonString);

import 'dart:convert';

CallBackModel callBackModelFromJson(String str) => CallBackModel.fromJson(json.decode(str));

String callBackModelToJson(CallBackModel data) => json.encode(data.toJson());

class CallBackModel {
    String? status;
    String? message;

    CallBackModel({
        this.status,
        this.message,
    });

    factory CallBackModel.fromJson(Map<String, dynamic> json) => CallBackModel(
        status: json["status"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
    };
}
