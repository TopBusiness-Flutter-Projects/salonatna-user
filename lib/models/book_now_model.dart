import 'package:app/models/service_type_model.dart';
import 'package:flutter/foundation.dart';

class BookNow {
  int? id;
  String? cartId;
  int? userId;
  int? vendorId;
  int? staffId;
  String? totalPrice;
  String? remPrice;
  String? paymentMethod;
  String? paymentStatus;
  String? serviceDate;
  String? serviceTime;
  int? status;
  int? orderStatus;
  String? mobile;
  int? couponId;
  String? couponDiscount;
  String? rewardUse;
  String? rewardDiscount;
  String? paymentGateway;
  String? paymentId;
  String? deliveryDate;
  String? timeSlot;
  String? lang;

  List<ServiceType> serviceTypeVariantIdList = [];

  BookNow();
  Map<String, dynamic> toJson() => {
        'order_array': serviceTypeVariantIdList,
        'user_id': userId,
        'delivery_date': deliveryDate,
        'time_slot': timeSlot,
        'vendor_id': vendorId,
        'staff_id': staffId,
        'payment_method': paymentMethod,
        'payment_status': paymentStatus,
        'payment_id': paymentId,
        'payment_gateway': paymentGateway,
        'cart_id': cartId,
        'lang': lang,
      };

  BookNow.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'] != null ? int.parse('${json['id']}') : null;
      cartId = json['cart_id'];
      userId = json['user_id'] != null ? int.parse('${json['user_id']}') : null;
      vendorId = json['vendor_id'] != null ? int.parse('${json['vendor_id']}') : null;
      staffId = json['staff_id'] != null ? int.parse('${json['staff_id']}') : null;
      totalPrice = json['total_price'];
      remPrice = json['rem_price'];
      couponDiscount = json['coupon_discount'];
      rewardDiscount = json['reward_discount'];
      rewardUse = json['reward_use'];
      paymentMethod = json['payment_method'];
      paymentStatus = json['payment_status'];
      serviceDate = json['service_date'];
      serviceTime = json['service_time'];
      status = json['status'] != null ? int.parse('${json['status']}') : null;
      orderStatus = json['order_status'] != null ? int.parse('${json['order_status']}') : null;
      mobile = json['mobile'];
      couponId = json['coupon_id'] != null ? int.parse('${json['coupon_id']}') : null;
      paymentGateway = json['payment_gateway'];
      paymentId = json['payment_id'];
      deliveryDate = json['delivery_date'];
      timeSlot = json['time_slot'];
    } catch (e) {
      debugPrint("Exception - BookNowModel.dart - BookNow.fromJson():$e");
    }
  }
}
