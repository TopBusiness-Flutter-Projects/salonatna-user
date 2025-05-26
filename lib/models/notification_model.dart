import 'package:flutter/foundation.dart';

class NotificationList {
  int? notificationId;
  int? userId;
  String? notificationTitle;
  String? notificationMessage;
  String? image;
  int? readByUser;
  DateTime? createdAt;
  NotificationList();

  NotificationList.fromJson(Map<String, dynamic> json) {
    try {
      notificationId = json['noti_id'] != null ? int.parse('${json['noti_id']}') : null;
      userId = json['user_id'] != null ? int.parse('${json['user_id']}') : null;
      notificationTitle = json['noti_title'];
      notificationMessage = json['noti_message'];
      image = json['image'] ?? '';
      readByUser = json['read_by_user'] != null ? int.parse('${json['read_by_user']}') : null;
      createdAt = json['created_at'] != null ? DateTime.parse(json['created_at'].toString()).toLocal() : null;
    } catch (e) {
      debugPrint("Exception - notificationListModel.dart - NotificationList.fromJson():$e");
    }
  }
}
