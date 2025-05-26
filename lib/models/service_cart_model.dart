import 'package:flutter/foundation.dart';

class ServiceCart {
  int? orderCartId;
  String? serviceName;
  int? serviceId;
  String? variant;
  int? variantId;
  String? cartId;
  int? userId;
  int? vendorId;
  String? status;
  String? price;
  DateTime? createdAt;
  ServiceCart();

   ServiceCart.fromJson(Map<String, dynamic> json) {
    try {
      orderCartId = json['order_cart_id'] != null ? int.parse('${json['order_cart_id']}') : null;
      serviceName = json['service_name'] != null && json['service_name'] != 'n/a'  ? json['service_name'] : '';
      serviceId = json['service_id'] != null ? int.parse('${json['service_id']}') : null;
      variant = json['varient'];
      variantId = json['varient_id'] != null ? int.parse('${json['varient_id']}') : null;
      cartId = json['cart_id'];
      userId = json['user_id'] != null ? int.parse('${json['user_id']}') : null;
      status = json['status'];
      vendorId = json['vendor_id'] != null ? int.parse('${json['vendor_id']}') : null;
      price = json['price'];
      createdAt = json['created_at'] != null ? DateTime.parse(json['created_at'].toString()).toLocal() : null;
   
    } catch (e) {
      debugPrint("Exception - service_cart_model.dart - ServiceCart.fromJson():$e");
    }
  }
}
