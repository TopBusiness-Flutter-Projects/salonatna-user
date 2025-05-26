import 'package:app/models/product_model.dart';
import 'package:flutter/foundation.dart';

class BarberShop {
  String? vendorName;
  String? owner;
  String? vendorEmail;
  String? vendorPhone;
  String? vendorLogo;
  String? vendorLoc;
  String? lat;
  String? lng;
  String? openingTime;
  String? closingTime;
  int? vendorId;
  int? deliveryRange;
  int? shopType;
  double? distance;
  String? description;
  DateTime? createdAt;
  int? phoneVerified;
  String? onlineStatus;
  double? rating;

  List<Product> products = [];

  BarberShop();

  BarberShop.fromJson(Map<String, dynamic> json) {
    try {
      vendorName = json['vendor_name'];
      owner = json['owner'];
      vendorEmail = json['vendor_email'];
      vendorPhone = json['vendor_phone'];
      vendorLogo = json['vendor_logo'] ?? '';
      vendorLoc = json['vendor_loc'];
      lat = json['lat'];
      lng = json['lng'];
      openingTime = json['opening_time'];
      closingTime = json['closing_time'];
      vendorId = json['vendor_id'] != null ? int.parse('${json['vendor_id']}') : null;
      deliveryRange = json['delivery_range'] != null ? int.parse('${json['delivery_range']}') : null;
      shopType = json['shop_type'] != null ? int.parse('${json['shop_type']}') : null;
      distance = json['distance'] != null ? double.parse(json['distance'].toString()) : null;

      rating = json['rating'] != null ? double.parse(json['rating'].toString()) : null;
      description = json['description'];

      phoneVerified = json['phone_verified'] != null ? int.parse('${json['phone_verified']}') : null;
      onlineStatus = json['online_status'];

      products = json['products'] != null && json['products'] != [] ? List<Product>.from(json['products'].map((x) => Product.fromJson(x))) : [];
    } catch (e) {
      debugPrint("Exception - barber_shop_model.dart - BarberShop.fromJson():$e");
    }
  }

  Map<String, dynamic> toJson() => {'vendor_id': vendorId};
}
