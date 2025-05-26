import 'package:app/models/product_model.dart';
import 'package:flutter/foundation.dart';

class Cart {
  double? totalPrice;
  List<Product> cartItems = [];

  Cart();

  Cart.fromJson(Map<String, dynamic> json) {
    try {
      totalPrice = json['total_price'] != null ? double.parse('${json['total_price']}') : null;
      cartItems = json['cart_items'] != null && json['cart_items'] != [] ? List<Product>.from(json['cart_items'].map((x) => Product.fromJson(x))) : [];
    } catch (e) {
      debugPrint("Exception - CartModel.dart - Cart.fromJson():$e");
    }
  }
}
