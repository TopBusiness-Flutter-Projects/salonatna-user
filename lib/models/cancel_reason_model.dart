import 'package:flutter/foundation.dart';

class CancelReasons {
  int? resId;
  String? reason;
  CancelReasons();

  CancelReasons.fromJson(Map<String, dynamic> json) {
    try {
      resId = json['res_id'] != null ? int.parse(json['res_id']) : null;
      reason = json['reason'];
    } catch (e) {
      debugPrint("Exception - cancelReasonsModel.dart - CancelReasons.fromJson():$e");
    }
  }
}
