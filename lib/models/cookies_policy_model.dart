import 'package:flutter/foundation.dart';

class Cookies {
  int? id;
  String? cookiesPolicy;
  Cookies();
  Cookies.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'] != null ? int.parse('${json['id']}') : null;
      cookiesPolicy = json['cookies_policy'];
    } catch (e) {
      debugPrint("Exception - cookies_policy_model.dart - Cookies.fromJson():$e");
    }
  }
}
