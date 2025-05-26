import 'package:flutter/foundation.dart';

class Product {
  int? id;
  int? subCatId;
  String? productName;
  String? productImage;
  String? price;
  String? quantity;
  String? description;
  int? vendorId;
  String? vendorName;
  int? deliveryRange;
  double? distance;
  int? cartQty;
  int? storeOrderId;
  int? productId;
  int? qty; //
  String? totalPrice;
  String? orderCartId;
  String? orderDate;
  int? userId;
  String? status;
  bool? isFavourite;
  int? wishId;

  Product();

  Product.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'] != null ? int.parse('${json['id']}') : null;
      subCatId = json['subcat_id'] != null ? int.parse('${json['subcat_id']}') : null;
      productName = json['product_name'];
      productImage = json['product_image'] ?? '';
      vendorId = json['vendor_id'] != null ? int.parse('${json['vendor_id']}') : null;
      price = json['price'];
      quantity = json['quantity'];
      description = json['description'];
      vendorName = json['vendor_name'];
      deliveryRange = json['delivery_range'] != null ? int.parse('${json['delivery_range']}') : null;
      distance = json['distance'] != null ? double.parse(json['distance'].toString()) : null;
      storeOrderId = json['store_order_id'] != null ? int.parse('${json['store_order_id']}') : null;
      productId = json['product_id'] != null ? int.parse('${json['product_id']}') : null;
      qty = json['qty'] != null ? int.parse('${json['qty']}') : null;
      totalPrice = json['total_price'];
      orderCartId = json['order_cart_id'];
      orderDate = json['order_date'];
      userId = json['user_id'] != null ? int.parse('${json['user_id']}') : null;
      status = json['status'];
      isFavourite = json['isFavourite'] != null && json['isFavourite'] == true ? true : false;
      wishId = json['wish_id'] != null ? int.parse('${json['wish_id']}') : null;
      cartQty = json['cart_qty'] != null ? int.parse('${json['cart_qty']}') : null;
    } catch (e) {
      debugPrint("Exception - product_model.dart - Product.fromJson():$e");
    }
  }
}
