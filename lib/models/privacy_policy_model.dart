import 'package:flutter/foundation.dart';

class PrivacyPolicy {
  int? id;
  String? privacyPolicy;
  PrivacyPolicy();
  PrivacyPolicy.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'] != null ? int.parse('${json['id']}') : null;
      privacyPolicy = json['privacy_policy'];
    } catch (e) {
      debugPrint("Exception - privacy_policy_model.dart - PrivacyPolicy.fromJson():$e");
    }
  }
}
