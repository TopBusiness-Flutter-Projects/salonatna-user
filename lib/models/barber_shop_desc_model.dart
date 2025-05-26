import 'package:app/models/barber_shop_model.dart';
import 'package:app/models/gallery_model.dart';
import 'package:app/models/popular_barbers_model.dart';
import 'package:app/models/product_model.dart';
import 'package:app/models/review_model.dart';
import 'package:app/models/service_model.dart';
import 'package:app/models/weekly_time_model.dart';
import 'package:flutter/foundation.dart';

class BarberShopDesc {
  String? salonName;
  String? owner;
  String? description;
  int? type;
  double? rating;
  String? vendorLogo;
  String? vendorLoc;
  String? vendorPhone;
  String? vendorWhatsapp;
  int? vendorId;
  List<WeekTimeSlot> weeklyTime = [];
  List<PopularBarbers> barber = [];
  List<Product> products = [];
  List<Service> services = [];
  List<Review> review = [];
  List<Gallery> gallery = [];
  List<BarberShop> similarSalons = [];

  BarberShopDesc();
  BarberShopDesc.fromJson(Map<String, dynamic> json) {
    try {
      salonName = json['salon_name'];
      owner = json['owner'];
      description = json['description'];

      vendorLogo = json['vendor_logo'];
      vendorLoc = json['vendor_loc'];
      vendorPhone = json['vendor_phone'];
      vendorWhatsapp = json['vendor_whatsapp'];
      vendorId = json['vendor_id'] != null ? int.parse('${json['vendor_id']}') : null;
      type = json['type'] != null ? int.parse('${json['type']}') : null;
      rating = json['rating'] != null ? double.parse(json['rating'].toString()) : null;
      weeklyTime = json['weekly_time'] != null && json['weekly_time'] != [] ? List<WeekTimeSlot>.from(json['weekly_time'].map((x) => WeekTimeSlot.fromJson(x))) : [];
      barber = json['barber'] != null && json['barber'] != [] ? List<PopularBarbers>.from(json['barber'].map((x) => PopularBarbers.fromJson(x))) : [];
      products = json['products'] != null && json['products'] != [] ? List<Product>.from(json['products'].map((x) => Product.fromJson(x))) : [];
      services = json['services'] != null && json['services'] != [] ? List<Service>.from(json['services'].map((x) => Service.fromJson(x))) : [];
      review = json['review'] != null && json['review'] != [] ? List<Review>.from(json['review'].map((x) => Review.fromJson(x))) : [];
      gallery = json['gallery'] != null && json['gallery'] != [] ? List<Gallery>.from(json['gallery'].map((x) => Gallery.fromJson(x))) : [];
      similarSalons = json['similar_salons'] != null && json['similar_salons'] != [] ? List<BarberShop>.from(json['similar_salons'].map((x) => BarberShop.fromJson(x))) : [];
    } catch (e) {
      debugPrint("Exception - BarberShopDescModel.dart - BarberShopDesc.fromJson():$e");
    }
  }
}
