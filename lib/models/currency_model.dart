import 'package:flutter/foundation.dart';

class Currency {
  dynamic currencyId;
  String? currency;
  String? currencySign;

  Currency({this.currencyId, this.currency, this.currencySign});

  Currency.fromJson(Map<String, dynamic> json) {
    try {
      currencyId = json['currency_id'];
      currency = json['currency'];
      currencySign = json['currency_sign'];
    } catch (e) {
      debugPrint("Exception - currency_model.dart - Currency.fromJson():$e");
    }
  }
}
