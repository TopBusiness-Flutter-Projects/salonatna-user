import 'dart:io';

import 'package:app/models/businessLayer/global.dart' as global;
import 'package:flutter/foundation.dart';

class CurrentUser {
  int? id;
  String? userPhone;
  String? name;
  String? firstName;
  String? lastName;
  String? image;
  String? email;
  int? otp;
  String? facebookId;
  DateTime? emailVerifiedAt;
  String? password;
  String? deviceId;
  int? walletCredits;
  int? rewards;
  bool? phoneVerified;
  String? referralCode;
  String? rememberToken;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? token;

  String? username;
  String? userEmail;
  String? userPassword;
  File? userImage;
  String? fbId;
  int? cartCount;
  String? appleId;
  CurrentUser();

  CurrentUser.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'] != null ? int.parse('${json['id']}') : null;
      userPhone = json['user_phone'];
      name = json['name'];
      lastName = json['lastname'];
      firstName = json['firstname'];
      image = json['image'] != null && json['image'].toString() != 'N/A' ? json['image'] : '';
      otp = json['otp'] != null ? int.parse('${json['otp']}') : null;
      facebookId = json['facebook_id'];
      email = json['email'];
      password = json['password'];
      emailVerifiedAt = json['email_verified_at'] != null ? DateTime.parse(json['email_verified_at'].toString()).toLocal() : null;
      deviceId = json['device_id'];
      walletCredits = json['wallet_credits'] != null ? int.parse('${json['wallet_credits']}') : null;
      rewards = json['rewards'] != null ? int.parse('${json['rewards']}') : null;
      phoneVerified = json['phone_verified'] != null && int.parse('${json['phone_verified']}') == 1 ? true : false;
      referralCode = json['referral_code'];
      rememberToken = json['remember_token'];
      createdAt = json['created_at'] != null ? DateTime.parse(json['created_at'].toString()).toLocal() : null;
      updatedAt = json['updated_at'] != null ? DateTime.parse(json['updated_at'].toString()).toLocal() : null;
      token = json['token'];
      cartCount = json['cart_count'] != null ? int.parse('${json['cart_count']}') : null;
      appleId = json['apple_id'];
    } catch (e) {
      debugPrint("Exception - user_model.dart - User.fromJson():$e");
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_phone': userPhone != null && userPhone!.isNotEmpty ? userPhone : null,
        'user_name': username != null && username!.isNotEmpty ? username : null,
        'name': name != null && name!.isNotEmpty ? name : null,
        'firstname': firstName != null && firstName!.isNotEmpty ? firstName : null,
        'lastname': lastName != null && lastName!.isNotEmpty ? lastName : null,
        'user_image': userImage,
        'image': image,
        'user_email': userEmail != null && userEmail!.isNotEmpty ? userEmail : null,
        'email_verified_at': emailVerifiedAt?.toIso8601String(),
        'fb_id': fbId != null && fbId!.isNotEmpty ? fbId : null,
        'password': userPassword != null && userPassword!.isNotEmpty ? userPassword : null,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
        'otp': otp,
        'device_id': deviceId != null && deviceId!.isNotEmpty ? global.appDeviceId : null,
        'wallet_credits': walletCredits,
        'rewards': rewards,
        'phone_verified': phoneVerified != null && phoneVerified == true ? 1 : 0,
        'referral_code': referralCode != null && referralCode!.isNotEmpty ? referralCode : null,
        'remember_token': rememberToken != null && rememberToken!.isNotEmpty ? rememberToken : null,
        'token': token != null && token!.isNotEmpty ? token : null,
        'cart_count': cartCount,
        'apple_id': appleId
      };
}
