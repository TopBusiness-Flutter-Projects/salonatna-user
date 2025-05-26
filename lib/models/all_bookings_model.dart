import 'package:app/models/service_cart_model.dart';
import 'package:flutter/foundation.dart';

class AllBookings {
  String? username;
  String? vendorName;
  String? owner;
  String? vendorPhone;
  String? vendorEmail;
  String? vendorLoc;
  String? vendorLogo;
  String? serviceDate;
  String? serviceTime;
  String? paymentMethod;
  String? paymentStatus;
  String? staffName;
  String? cartId;
  String? price;
  int? status;
  String? remPrice;
  String? couponDiscount;
  String? rewardDiscount;
  int? staffId;
  int? vendorId;
  List<ServiceCart> cartServices = [];
  ReviewRating? vendorReview;
  ReviewRating? staffReview;

  AllBookings();

  AllBookings.fromJson(Map<String, dynamic> json) {
    try {
      username = json['user_name'];
      owner = json['owner'];
      serviceDate = json['service_date'];
      serviceTime = json['service_time'];
      paymentMethod = json['payment_method'];
      paymentStatus = json['payment_status'];
      staffName = json['staff_name'];
      cartId = json['cart_id'];
      price = json['price'];
      remPrice = json['rem_price'];
      vendorName = json['vendor_name'];
      status = json['status'] != null ? int.parse('${json['status']}') : null;
      couponDiscount = json['coupon_discount'];
      vendorEmail = json['vendor_email'];
      vendorPhone = json['vendor_phone'];
      vendorLogo = json['vendor_logo'];
      vendorLoc = json['vendor_loc'];
      rewardDiscount = json['reward_discount'];
      staffId = json['staff_id'] != null ? int.parse('${json['staff_id']}') : null;
      vendorId = json['vendor_id'] != null ? int.parse('${json['vendor_id']}') : null;
      cartServices = json['cart_services'] != null && json['cart_services'] != [] ? List<ServiceCart>.from(json['cart_services'].map((x) => ServiceCart.fromJson(x))) : [];
      vendorReview = json['vendor_review'] != null ? ReviewRating.fromJson(json['vendor_review']) : null;
      staffReview = json['staff_review'] != null ? ReviewRating.fromJson(json['staff_review']) : null;
    } catch (e) {
      debugPrint("Exception - all_bookings_model.dart - AllBookings.fromJson():$e");
    }
  }
}

class ReviewRating {
  double? rating;
  String? reviewDescription;
  String? description;
  ReviewRating();
  ReviewRating.fromJson(Map<String, dynamic> json) {
    try {
      rating = json['rating'] != null ? double.parse(json['rating'].toString()) : null;
      reviewDescription = json['review_description'];
      description = json['description'];
    } catch (e) {
      debugPrint("Exception - all_bookings_model.dart - ReviewRating.fromJson():$e");
    }
  }
}
