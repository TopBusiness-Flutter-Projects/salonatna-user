import 'package:flutter/foundation.dart';

class ProductCartCheckout {
  int? orderId;
  int? userId;
  String? cartId;
  String? totalPrice;
  String? paymentGateway;
  String? paymentUrl;
  String? paymentId;
  String? paymentStatus;
  int? status;

  DateTime? createdAt;

  ProductCartCheckout();

  ProductCartCheckout.fromJson(Map<String, dynamic> json) {
    try {
      orderId = json['order_id'] != null ? int.parse('${json['order_id']}') : null;
      userId = json['user_id'] != null ? int.parse('${json['user_id']}') : null;
      cartId = json['cart_id'];
      totalPrice = json['total_price'];
      paymentGateway = json['payment_gateway'];
      paymentId = json['payment_id'];
      paymentStatus = json['payment_status'];
      paymentUrl = json['payment_url'];
      status = json['status'] != null ? int.parse('${json['status']}') : null;
      createdAt = json['created_at'] != null ? DateTime.parse(json['created_at'].toString()).toLocal() : null;
    } catch (e) {
      debugPrint("Exception - product_cart_checkout_model.dart - ProductCartCheckout.fromJson():$e");
    }
  }
}
