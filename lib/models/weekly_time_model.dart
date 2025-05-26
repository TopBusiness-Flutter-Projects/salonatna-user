import 'package:flutter/foundation.dart';

class WeekTimeSlot {
  int? timeSlotId;
  String? openHour;
  String? closeHour;
  String? days;
  int? vendorId;
  int? status;

  WeekTimeSlot();
  WeekTimeSlot.fromJson(Map<String, dynamic> json) {
    try {
      timeSlotId = json['time_slot_id'] != null ? int.parse('${json['time_slot_id']}') : null;
      openHour = json['open_hour'];
      closeHour = json['close_hour'];
      days = json['days'];
      vendorId = json['vendor_id'] != null ? int.parse('${json['vendor_id']}') : null;
      status = json['status'] != null ? int.parse('${json['status']}') : null;
    } catch (e) {
      debugPrint("Exception - weekly_time_model.dart - WeekTimeSlot.fromJson():$e");
    }
  }
}
