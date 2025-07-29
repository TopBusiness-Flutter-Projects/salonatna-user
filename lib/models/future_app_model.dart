// To parse this JSON data, do
//
//     final futureAppModel = futureAppModelFromJson(jsonString);

import 'dart:convert';

FutureAppModel futureAppModelFromJson(String str) =>
    FutureAppModel.fromJson(json.decode(str));

String futureAppModelToJson(FutureAppModel data) => json.encode(data.toJson());

class FutureAppModel {
  String? msg;
  Data? data;
  String? status;

  FutureAppModel({
    this.msg,
    this.data,
    this.status,
  });

  factory FutureAppModel.fromJson(Map<String, dynamic> json) => FutureAppModel(
        msg: json["msg"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "msg": msg,
        "data": data?.toJson(),
        "status": status,
      };
}

class Data {
  List<App>? apps;

  Data({
    this.apps,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        apps: json["apps"] == null
            ? []
            : List<App>.from(json["apps"]!.map((x) => App.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "apps": apps == null
            ? []
            : List<dynamic>.from(apps!.map((x) => x.toJson())),
      };
}

class App {
  int? id;
  String? name;
  String? androidUrl;
  String? iosUrl;
  String? icon;

  App({
    this.id,
    this.name,
    this.androidUrl,
    this.iosUrl,
    this.icon,
  });

  factory App.fromJson(Map<String, dynamic> json) => App(
        id: json["id"],
        name: json["name"],
        androidUrl: json["android_url"],
        iosUrl: json["ios_url"],
        icon: json["icon"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "android_url": androidUrl,
        "ios_url": iosUrl,
        "icon": icon,
      };
}
