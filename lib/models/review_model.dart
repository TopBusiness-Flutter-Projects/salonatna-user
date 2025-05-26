import 'package:flutter/foundation.dart';

class Review {
  int? id;
  late double rating;
  String? description;
  int? userId;
  int? vendorId;
  int? productId;
  int? active;
  String? name;
  String? image;
  DateTime? createdAt;

  Review();

  Review.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'] != null ? int.parse('${json['id']}') : null;
      userId = json['user_id'] != null ? int.parse('${json['user_id']}') : null;
       productId = json['product_id'] != null ? int.parse('${json['product_id']}') : null;
      description = json['description'];
      vendorId = json['vendor_id'] != null ? int.parse('${json['vendor_id']}') : null;
      rating = json['rating'] != null ? double.parse(json['rating'].toString()) : 0;
      active = json['active'] != null ? int.parse('${json['active']}') : null;
      name = json['name'];
      image = json['image'];
      createdAt = json['created_at'] != null ? DateTime.parse(json['created_at'].toString()).toLocal() : null;
    } catch (e) {
      debugPrint("Exception - review_model.dart - Review.fromJson():$e");
    }
  }
}
