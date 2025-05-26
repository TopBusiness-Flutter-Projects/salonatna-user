import 'package:app/models/pay_stack_model.dart';
import 'package:app/models/razorpay_model.dart';
import 'package:app/models/stripe_model.dart';
import 'package:flutter/foundation.dart';

class PaymentGateway {
  RazorpayMethod? razorpay;
  StripeMethod? stripe;
  PayStackMethod? paystack;
  PaymentGateway();

  PaymentGateway.fromJson(Map<String, dynamic> json) {
    try {
      razorpay = json['razorpay'] != null ? RazorpayMethod.fromJson(json['razorpay']) : null;
      stripe = json['stripe'] != null ? StripeMethod.fromJson(json['stripe']) : null;
      paystack = json['paystack'] != null ? PayStackMethod.fromJson(json['paystack']) : null;
    } catch (e) {
      debugPrint("Exception - payment_gateway_model.dart - PaymentGateway.fromJson():$e");
    }
  }
}
