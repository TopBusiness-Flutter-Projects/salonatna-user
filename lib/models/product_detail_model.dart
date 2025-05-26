import 'package:app/models/review_model.dart';
import 'package:flutter/foundation.dart';

class ProductDetail {
  int? id;
  String? productName;
  String? productImage;
  String? price;
  String? quantity;
  String? description;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? vendorId;
  int? rating;
  String? salonName;
  String? owner;
  late bool isFavourite;
  List<Review> review = [];

  ProductDetail();

  ProductDetail.fromJson(Map<String, dynamic> json) {
    try {
      salonName = json['salon_name'];
      owner = json['owner'];
      id = json['id'] != null ? int.parse('${json['id']}') : null;
      productName = json['product_name'];
      productImage = json['product_image'];
      price = json['price'];
      quantity = json['quantity'];
      description = json['description'];
      vendorId = json['vendor_id'] != null ? int.parse('${json['vendor_id']}') : null;
      rating = json['rating'] != null ? int.parse('${json['rating']}') : null;
      isFavourite = json['isFavourite'] != null && json['isFavourite'] == true ? true : false;
      review = json['review'] != null && json['review'] != [] ? List<Review>.from(json['review'].map((x) => Review.fromJson(x))) : [];
    } catch (e) {
      debugPrint("Exception - product_detail_model.dart - ProductDetail.fromJson():$e");
    }
  }
}
