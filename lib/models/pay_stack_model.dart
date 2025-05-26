import 'package:flutter/foundation.dart';

class PayStackMethod {
  String? payStackStatus;
  String? payStackPublicKey;
  String? payStackSecretKey;
  PayStackMethod();

  PayStackMethod.fromJson(Map<String, dynamic> json) {
    try {
      payStackStatus = json['paystack_status'] != null ? '${json['paystack_status']}' : null;
      payStackPublicKey = json['paystack_public_key'] != null ? '${json['paystack_public_key']}' : null;
      payStackSecretKey = json['paystack_secret_key'] != null ? '${json['paystack_secret_key']}' : null;
    } catch (e) {
      debugPrint("Exception - payStackMethodModel.dart - PayStackMethod.fromJson():$e");
    }
  }
}
