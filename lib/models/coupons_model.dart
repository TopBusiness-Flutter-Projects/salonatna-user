import 'package:flutter/foundation.dart';

class Coupons {
  int? couponId;
  String? couponName;
  String? couponCode;
  String? couponDescription;
  DateTime? startDate;
  DateTime? endDate;
  int? cartValue;
  String? amount;
  String? type;
  int? usesRestriction;
  int? couponVendorId;
  int? vendorId;
  String? vendorName;
  String? owner;
  String? cityAdminId;
  String? vendorEmail;
  String? vendorPhone;
  String? vendorLogo;
  String? vendorLoc;
  String? lat;
  String? lng;
  String? description;
  String? vendorPass;
  String? openingTime;
  String? closingTime;
  int? commission;
  int? deliveryRange;
  String? deviceId;
  String? otp;
  int? phoneVerified;
  String? onlineStatus;
  int? shopType;
  int? bookingAmount;
  int? adminApproval;

  Coupons();

  Coupons.fromJson(Map<String, dynamic> json) {
    try {
      couponId = json['coupon_id'] != null ? int.parse('${json['coupon_id']}') : null;
      couponName = json['coupon_name'];
      couponCode = json['coupon_code'];
      couponDescription = json['coupon_description'];
      cartValue = json['cart_value'] != null ? int.parse('${json['cart_value']}') : null;
      amount = json['amount'];
      type = json['type'];
      usesRestriction = json['uses_restriction'] != null ? int.parse('${json['uses_restriction']}') : null;
      vendorId = json['vendor_id'] != null ? int.parse('${json['vendor_id']}') : null;
      couponVendorId = json['coupon_vendor_id'] != null ? int.parse('${json['coupon_vendor_id']}') : null;
      startDate = json['start_date'] != null ? DateTime.parse(json['start_date'].toString()).toLocal() : null;
      endDate = json['end_date'] != null ? DateTime.parse(json['end_date'].toString()).toLocal() : null;
      vendorName = json['vendor_name'];
      cityAdminId = json['cityadmin_id'];
      vendorEmail = json['vendor_email'];
      vendorPhone = json['vendor_phone'];
      vendorLogo = json['vendor_logo'];
      vendorLoc = json['vendor_loc'];
      description = json['description'];
      vendorPass = json['vendor_pass'];
      openingTime = json['opening_time'];
      closingTime = json['closing_time'];
      commission = json['comission'] != null ? int.parse('${json['comission']}') : null;
      deliveryRange = json['delivery_range'] != null ? int.parse('${json['delivery_range']}') : null;
      deviceId = json['device_id'];
      otp = json['otp'];
      phoneVerified = json['phone_verified'] != null ? int.parse('${json['phone_verified']}') : null;
      onlineStatus = json['online_status'];
      shopType = json['shop_type'] != null ? int.parse('${json['shop_type']}') : null;
      bookingAmount = json['booking_amount'] != null ? int.parse('${json['booking_amount']}') : null;
      adminApproval = json['admin_approval'] != null ? int.parse('${json['admin_approval']}') : null;
    } catch (e) {
      debugPrint("Exception - coupons_model.dart - Coupons.fromJson():$e");
    }
  }
}
