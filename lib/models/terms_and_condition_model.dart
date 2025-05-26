import 'package:flutter/foundation.dart';

class TermsAndCondition {
  int? id;
  String? termcondition;
  TermsAndCondition();
  TermsAndCondition.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'] != null ? int.parse('${json['id']}') : null;
      termcondition = json['termcondition'] ?? 'No policy found';
    } catch (e) {
      debugPrint("Exception - terms_and_condition_model.dart - TermsAndCondition.fromJson():$e");
    }
  }
}
