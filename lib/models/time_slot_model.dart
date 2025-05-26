import 'package:flutter/foundation.dart';

class TimeSlot {
  String? timeslot;
  bool? availibility;
  TimeSlot();

  TimeSlot.fromJson(Map<String, dynamic> json) {
    try {
      timeslot = json['timeslot'];
      availibility = json['availability'] != null && json['availability'] == 'true' ? true : false;
    } catch (e) {
      debugPrint("Exception - time_slot_model.dart - TimeSlot.fromJson():$e");
    }
  }
}
