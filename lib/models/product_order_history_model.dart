import 'package:app/models/barber_shop_model.dart';
import 'package:flutter/foundation.dart';

class ProductOrderHistory {
  int? orderId;
  int? userId;
  String? cartId;
  String? totalPrice;
  String? paymentGateway;
  String? paymentId;
  String? paymentStatus;
  int? status;
  int? count;
  String? cancellingReason;
  List<BarberShop> vendor = [];
  DateTime? createdAt;
  ProductOrderHistory();

  ProductOrderHistory.fromJson(Map<String, dynamic> json) {
    try {
      orderId = json['order_id'] != null ? int.parse('${json['order_id']}') : null;
      userId = json['user_id'] != null ? int.parse('${json['user_id']}') : null;
      cartId = json['cart_id'];
      totalPrice = json['total_price'];
       count = json['count'] != null ? int.parse('${json['count']}') : null;
      paymentGateway = json['payment_gateway'];
      paymentId = json['payment_id'];
      paymentStatus = json['payment_status'];
      status = json['status'] != null ? int.parse('${json['status']}') : null;
      cancellingReason = json['cancelling_reason'];
      vendor = json['vendor'] != null && json['vendor'] != [] ? List<BarberShop>.from(json['vendor'].map((x) => BarberShop.fromJson(x))) : [];
      createdAt = json['created_at'] != null ? DateTime.parse(json['created_at'].toString()).toLocal() : null;
    } catch (e) {
      debugPrint("Exception - product_order_history_model.dart - ProductOrderHistory.fromJson():$e");
    }
  }
}
