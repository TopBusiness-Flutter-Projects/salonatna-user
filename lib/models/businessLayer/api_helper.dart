import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:app/models/all_bookings_model.dart';
import 'package:app/models/banner_model.dart';
import 'package:app/models/barber_shop_desc_model.dart';
import 'package:app/models/barber_shop_model.dart';
import 'package:app/models/book_appointment_model.dart';
import 'package:app/models/book_now_model.dart';
import 'package:app/models/businessLayer/api_result.dart';
import 'package:app/models/businessLayer/dio_result.dart';
import 'package:app/models/businessLayer/global.dart' as global;
import 'package:app/models/call_back_model.dart';
import 'package:app/models/cancel_reason_model.dart';
import 'package:app/models/cart_model.dart';
import 'package:app/models/cookies_policy_model.dart';
import 'package:app/models/coupons_model.dart';
import 'package:app/models/currency_model.dart';
import 'package:app/models/favorite_model.dart';
import 'package:app/models/google_map_model.dart';
import 'package:app/models/map_box_model.dart';
import 'package:app/models/may_by_model.dart';
import 'package:app/models/notification_model.dart';
import 'package:app/models/payment_gateway_model.dart';
import 'package:app/models/popular_barbers_model.dart';
import 'package:app/models/privacy_policy_model.dart';
import 'package:app/models/product_cart_checkout_model.dart';
import 'package:app/models/product_detail_model.dart';
import 'package:app/models/product_model.dart';
import 'package:app/models/product_order_history_model.dart';
import 'package:app/models/scratch_card_model.dart';
import 'package:app/models/service_model.dart';
import 'package:app/models/terms_and_condition_model.dart';
import 'package:app/models/time_slot_model.dart';
import 'package:app/models/user_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class APIHelper {
  Future<dynamic> addSalonRating(int? userId, int? vendorId, double rating, String description) async {
    try {
      final response = await http.post(
        Uri.parse("${global.baseUrl}add_salon_rating"),
        headers: await global.getApiHeaders(true),
        body: json.encode({
          "user_id": userId,
          "vendor_id": vendorId,
          "rating": rating,
          "description": description,
        }),
      );log("statusCode: ${response.statusCode} url: ${response.request!.url} response: ${response.body} ");
      dynamic recordList;
      if (response.statusCode == 200) {
        return getAPIResult(response, recordList);
      }
    } catch (e) {
      debugPrint("Exception - addSalonRating(): $e");
    }
  }

  Future<dynamic> addStaffRating(int? userId, int? staffId, double rating, String description) async {
    try {
      final response = await http.post(
        Uri.parse("${global.baseUrl}add_staff_rating"),
        headers: await global.getApiHeaders(true),
        body: json.encode({
          "user_id": userId,
          "staff_id": staffId,
          "rating": rating,
          "description": description,
        }),
      );log("statusCode: ${response.statusCode} url: ${response.request!.url} response: ${response.body} ");

      dynamic recordList;
      if (response.statusCode == 200) {
        return getAPIResult(response, recordList);
      }
    } catch (e) {
      debugPrint("Exception - addStaffRating(): $e");
    }
  }

  Future<dynamic> addToCart(int? userId, int? productId, int qty) async {
    try {
      final response = await http.post(
        Uri.parse("${global.baseUrl}add_to_cart"),
        headers: await global.getApiHeaders(true),
        body: json.encode({"user_id": userId, "product_id": productId, "qty": qty}),
      );

      dynamic recordList;log("statusCode: ${response.statusCode} url: ${response.request!.url} response: ${response.body} ");

      if (response.statusCode == 200 && json.decode(response.body)["status"] == "1") {
        recordList = Cart.fromJson(json.decode(response.body)["data"]);
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint("Exception - addToCart(): $e");
    }
  }

  Future<dynamic> addToFavorite(int? userId, int? productId) async {
    try {
      final response = await http.post(
        Uri.parse("${global.baseUrl}add_to_fav"),
        headers: await global.getApiHeaders(true),
        body: json.encode({"user_id": userId, "product_id": productId}),
      );log("statusCode: ${response.statusCode} url: ${response.request!.url} response: ${response.body} ");

      dynamic recordList;
      if (response.statusCode == 200 && json.decode(response.body)["status"] == "1") {
        recordList = Favorites.fromJson(json.decode(response.body)["data"]);
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint("Exception - addToFavorite(): $e");
    }
  }

  Future<dynamic> applyRewardsAndCoupons(String? cartId, String type, {String? couponCode}) async {
    try {
      final response = await http.post(
        Uri.parse("${global.baseUrl}apply_coupon_or_rewards"),
        headers: await global.getApiHeaders(true),
        body: json.encode({
          "cart_id": cartId,
          "type": type,
          "coupon_code": couponCode,
          
        }),
      );log("statusCode: ${response.statusCode} url: ${response.request!.url} response: ${response.body} ");

      dynamic recordList;
      if (response.statusCode == 200 && json.decode(response.body)["status"] == "1") {
        recordList = BookNow.fromJson(json.decode(response.body)["data"]);
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint("Exception - applyRewardsAndCoupons(): $e");
    }
  }

  Future<dynamic> bookAppointment(int? vendorId , {
   required int inSalon ,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("${global.baseUrl}booking_appointment"),
        headers: await global.getApiHeaders(true),
        body: json.encode({"vendor_id": vendorId, "in_salon" : inSalon, "lang": global.languageCode}),
      );
      log("statusCode: ${response.statusCode} url: ${response.request!.url} response: ${response.body} ");

      dynamic recordList;
      if (response.statusCode == 200 && json.decode(response.body)["status"] == "1") {
        recordList = BookAppointment.fromJson(json.decode(response.body)["data"]);
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint("Exception - bookAppointment(): $e");
    }
  }

  Future<dynamic> bookNow(BookNow bookNow) async {
    try {
      bookNow.lang = global.languageCode;
      final response = await http.post(
        Uri.parse("${global.baseUrl}book_now"),
        headers: await global.getApiHeaders(true),
        body: json.encode(bookNow),
      );log("statusCode: ${response.statusCode} url: ${response.request!.url} response: ${response.body} ");

      dynamic recordList;
      if (response.statusCode == 200 && json.decode(response.body)["status"] == "1") {
        recordList = BookNow.fromJson(json.decode(response.body)["data"]);
      } else {
        recordList = null;
      }

      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint("Exception - bookNow(): $e");
    }
  }

  Future<dynamic> cancelBooking(String? cartId, String? reason) async {
    try {
      final response = await http.post(
        Uri.parse("${global.baseUrl}cancel_booking"),
        headers: await global.getApiHeaders(true),
        body: json.encode({"cart_id": cartId, "reason": reason}),
      );log("statusCode: ${response.statusCode} url: ${response.request!.url} response: ${response.body} ");

      dynamic recordList;
      if (response.statusCode == 200) {
        return getAPIResult(response, recordList);
      }
    } catch (e) {
      debugPrint("Exception - cancelBooking(): $e");
    }
  }

  Future<dynamic> cancelOrder(String? cartId, String reason) async {
    try {
      final response = await http.post(
        Uri.parse("${global.baseUrl}cancel_product_orders"),
        headers: await global.getApiHeaders(true),
        body: json.encode({"cart_id": cartId, "reason": reason}),
      );log("statusCode: ${response.statusCode} url: ${response.request!.url} response: ${response.body} ");

      dynamic recordList;
      if (response.statusCode == 200) {
        return getAPIResult(response, recordList);
      }
    } catch (e) {
      debugPrint("Exception - cancelOrder(): $e");
    }
  }

  Future<dynamic> changePassword(String? userEmail, String userPassword) async {
    try {
      final response = await http.post(
        Uri.parse("${global.baseUrl}change_password"),
        headers: await global.getApiHeaders(false),
        body: json.encode({"user_email": userEmail, "user_password": userPassword}),
      );log("statusCode: ${response.statusCode} url: ${response.request!.url} response: ${response.body} ");

      dynamic recordList;
      if (response.statusCode == 200 && jsonDecode(response.body)["status"] == "1") {
        recordList = CurrentUser.fromJson(json.decode(response.body)["data"]);
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint("Exception - changePassword(): $e");
    }
  }

  Future<dynamic> checkOut(BookNow bookNow) async {
      try {
      bookNow.lang = global.languageCode;
      log ("checkout model: ${bookNow.toJson()}" );
      final response = await http.post(
        Uri.parse("${global.baseUrl}checkout"),
        headers: await global.getApiHeaders(true),
        body: json.encode(bookNow),
      );log("statusCode: ${response.statusCode} url: ${response.request!.url} response: ${response.body} ");

      dynamic recordList;
      if (response.statusCode == 200 && json.decode(response.body)["status"].toString() == "1") {
        recordList = BookNow.fromJson(json.decode(response.body)["data"]);
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint("Exception - checkOut(): $e");
    }
  }
  Future<dynamic> checkOutCallBack(int orderId) async {
      try {
      final response = await http.post(
        Uri.parse("${global.baseUrl}checkout-callback"),
        headers: await global.getApiHeaders(true),
        body: json.encode({"order_id": orderId, }),
      );log("statusCode: ${response.statusCode} url: ${response.request!.url} response: ${response.body} ");

      dynamic recordList;
      // if (response.statusCode == 200 ) {
      if (response.statusCode == 200 && json.decode(response.body)["status"].toString() == "1") {
        recordList = CallBackModel.fromJson(json.decode(response.body)["data"]);
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint("Exception - checkOut(): $e");
    }
  }

  Future<dynamic> clearCart(int? userId) async {
    try {
      final response = await http.post(
        Uri.parse("${global.baseUrl}clear_cart"),
        headers: await global.getApiHeaders(true),
        body: json.encode({"user_id": userId}),
      );log("statusCode: ${response.statusCode} url: ${response.request!.url} response: ${response.body} ");

      dynamic recordList;
      if (response.statusCode == 200) {
        return getAPIResult(response, recordList);
      }
    } catch (e) {
      debugPrint("Exception - delFromCart(): $e");
    }
  }

  Future<dynamic> cookiesPolicy() async {
    try {
      Response response;
      var dio = Dio();

      response = await dio.get('${global.baseUrl}cookies',
          queryParameters: {
            'lang': global.languageCode,
          },
          options: Options(
            headers: await global.getApiHeaders(false),
          ));log("statusCode: ${response.statusCode} url: ${response.requestOptions.uri} response: ${response.data} ");
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = Cookies.fromJson(response.data['data']);
      } else {
        recordList = null;
      }

      return getDioResult(response, recordList);
    } catch (e) {
      debugPrint("Exception - cookiesPolicy(): $e");
    }
  }

  Future<dynamic> deleteAllNotifications(int? userId) async {
    try {
      final response = await http.post(
        Uri.parse("${global.baseUrl}delete_all_notifications"),
        headers: await global.getApiHeaders(true),
        body: json.encode({"user_id": userId}),
      );log("statusCode: ${response.statusCode} url: ${response.request!.url} response: ${response.body} ");

      dynamic recordList;
      if (response.statusCode == 200) {
        return getAPIResult(response, recordList);
      }
    } catch (e) {
      debugPrint("Exception - deleteAllNotifications(): $e");
    }
  }
     Future<dynamic> deleteAccount(int? userId) async {
      try {
        if(userId == null) {
          throw "Empty user id passed to deleteAcccount()";
        }
        final response = await http.post(
          Uri.parse("${global.baseUrl}delete_all_user_data"),
          headers: await global.getApiHeaders(true),
          body: json.encode({"id": userId})
        );log("statusCode: ${response.statusCode} url: ${response.request!.url} response: ${response.body} ");
        dynamic recordList;
        if(response.statusCode == 200) {
          return getAPIResult(response, recordList);
        }
      } catch (e) {
        debugPrint("Exception - deleteAccount(): $e");
      }
    }

  Future<dynamic> delFromCart(int? userId, int? productId) async {
    try {
      final response = await http.post(
        Uri.parse("${global.baseUrl}del_frm_cart"),
        headers: await global.getApiHeaders(true),
        body: json.encode({"user_id": userId, "product_id": productId}),
      );log("statusCode: ${response.statusCode} url: ${response.request!.url} response: ${response.body} ");

      dynamic recordList;
      if (response.statusCode == 200 && json.decode(response.body)["status"] == "1") {
        recordList = Cart.fromJson(json.decode(response.body)["data"]);
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint("Exception - delFromCart(): $e");
    }
  }

  Future<dynamic> forgotPassword(String userEmail) async {
    try {
      final response = await http.post(
        Uri.parse("${global.baseUrl}forget_password"),
        headers: await global.getApiHeaders(false),
        body: json.encode({"user_email": userEmail}),
      );log("statusCode: ${response.statusCode} url: ${response.request!.url} response: ${response.body} ");

      dynamic recordList;
      if (response.statusCode == 200 && json.decode(response.body) != null && json.decode(response.body)["status"] == "1") {
        recordList = CurrentUser.fromJson(json.decode(response.body)["data"]);
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint("Exception - forgotPassword(): $e");
    }
  }
  

  Future<dynamic> getAllBookings(int? userId) async {
    try {
      final response = await http.post(
        Uri.parse("${global.baseUrl}all_booking"),
        headers: await global.getApiHeaders(true),
        body: json.encode({"user_id": userId, "lang": global.languageCode}),
      );log("statusCode: ${response.statusCode} url: ${response.request!.url} response: ${response.body} ");

      dynamic recordList;
      if (response.statusCode == 200 && json.decode(response.body)["status"] == "1") {
        recordList = List<AllBookings>.from(json.decode(response.body)["data"].map((x) => AllBookings.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint("Exception - getAllBookings(): $e");
    }
  }

  dynamic getAPIResult<T>(final response, T recordList) {
    try {
      dynamic result;
      result = APIResult.fromJson(json.decode(response.body), recordList);
      return result;
    } catch (e) {
      debugPrint("Exception - getAPIResult():$e");
    }
  }

  Future<dynamic> getBarbersDescription(int? staffId) async {
    try {
      final response = await http.post(
        Uri.parse("${global.baseUrl}barber_desc"),
        headers: await global.getApiHeaders(false),
        body: json.encode({"staff_id": staffId, "lang": global.languageCode}),
      );log("statusCode: ${response.statusCode} url: ${response.request!.url} response: ${response.body} ");

      dynamic recordList;

      if (response.statusCode == 200 && json.decode(response.body)["status"] == "1") {
        recordList = PopularBarbers.fromJson(json.decode(response.body)["data"]);
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint("Exception - getBarbersDescription(): $e");
    }
  }

  Future<dynamic> getBarberShopDescription(int? vendorId, String? lat, String? lng) async {
    try {
      final response = await http.post(
        Uri.parse("${global.baseUrl}salon_desc"),
        headers: await global.getApiHeaders(false),
        body: json.encode({"vendor_id": vendorId, "lat": lat, "lng": lng, "lang": global.languageCode}),
      );log("statusCode: ${response.statusCode} url: ${response.request!.url} response: ${response.body} ");

      dynamic recordList;
      if (response.statusCode == 200 && json.decode(response.body)!=null && json.decode(response.body)["status"] == "1") {
        recordList = BarberShopDesc.fromJson(json.decode(response.body)["data"]);
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint("Exception - getPopularBarbersList(): $e");
    }
  }

  Future<dynamic> getCancelReasons() async {
    try {
      Response response;
      var dio = Dio();
      response = await dio.get('${global.baseUrl}cancel_reasons',        
          options: Options(
            headers: await global.getApiHeaders(true),
          ));
      log("statusCode: ${response.statusCode} url: ${response.requestOptions.uri} response: ${response.data} ");
      dynamic recordList;
      if (response.statusCode == 200 && response.data["status"] == "1") {
        recordList = List<CancelReasons>.from(response.data["data"].map((x) => CancelReasons.fromJson(x)));
      } else {
        recordList = null;
      }
      return getDioResult(response, recordList);
    } catch (e) {
      debugPrint("Exception - getCancelReasons(): $e");
    }
  }

  Future<dynamic> getCartItems(int? userId) async {
    try {
      final response = await http.post(
        Uri.parse("${global.baseUrl}show_cart"),
        headers: await global.getApiHeaders(true),
        body: json.encode({"user_id": userId, "lang": global.languageCode}),
      );log("statusCode: ${response.statusCode} url: ${response.request!.url} response: ${response.body} ");

      dynamic recordList;
      if (response.statusCode == 200 && json.decode(response.body)["status"] == "1") {
        recordList = Cart.fromJson(json.decode(response.body)["data"]);
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint("Exception - getCartItems(): $e");
    }
  }

  Future<dynamic> getCouponsList(String? cartId) async {
    try {
      final response = await http.post(
        Uri.parse("${global.baseUrl}couponlist"),
        headers: await global.getApiHeaders(true),
        body: json.encode({"cart_id": cartId, "lang": global.languageCode}),
      );log("statusCode: ${response.statusCode} url: ${response.request!.url} response: ${response.body} ");

      dynamic recordList;
      if (response.statusCode == 200 && json.decode(response.body)["status"] == "1") {
        recordList = List<Coupons>.from(json.decode(response.body)["data"].map((x) => Coupons.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint("Exception - getCouponsList(): $e");
    }
  }

  Future<dynamic> getCurrency() async {
    try {
      final response = await http.get(
        Uri.parse("${global.baseUrl}currency"),
      );log("statusCode: ${response.statusCode} url: ${response.request!.url} response: ${response.body} ");

      dynamic recordList;
      if (response.statusCode == 200 && json.decode(response.body)["status"] == "1") {
        recordList = Currency.fromJson(json.decode(response.body)["data"]);
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint("Exception - getCurrency(): $e");
    }
  }

  dynamic getDioResult<T>(final response, T recordList) {
    try {
      dynamic result;
      result = DioResult.fromJson(response, recordList);
      return result;
    } catch (e) {
      debugPrint("Exception - getDioResult():$e");
    }
  }

  Future<dynamic> getFavoriteList(int? userId) async {
    try {
      final response = await http.post(
        Uri.parse("${global.baseUrl}show_fav"),
        headers: await global.getApiHeaders(true),
        body: json.encode({"user_id": userId, "lang": global.languageCode}),
      );log("statusCode: ${response.statusCode} url: ${response.request!.url} response: ${response.body} ");

      dynamic recordList;
      if (response.statusCode == 200 && json.decode(response.body)["status"] == "1") {
        recordList = Favorites.fromJson(json.decode(response.body)["data"]);
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint("Exception - getFavoriteList(): $e");
    }
  }

  Future<dynamic> getGoogleMap() async {
    try {
      final response = await http.get(
        Uri.parse("${global.baseUrl}google_map"),
      );log("statusCode: ${response.statusCode} url: ${response.request!.url} response: ${response.body} ");

      dynamic recordList;
      if (response.statusCode == 200 && json.decode(response.body)["status"] == "1") {
        recordList = GoogleMapModel.fromJson(json.decode(response.body)["data"]);
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint("Exception - getGoogleMap(): $e");
    }
  }

  Future<dynamic> getMapBox() async {
    try {
      final response = await http.get(
        Uri.parse("${global.baseUrl}mapbox"),
      );
log("statusCode: ${response.statusCode} url: ${response.request!.url} response: ${response.body} ");

      dynamic recordList;
      if (response.statusCode == 200 && json.decode(response.body)["status"] == "1") {
        recordList = MapBoxModel.fromJson(json.decode(response.body)["data"]);
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint("Exception - getMapBox(): $e");
    }
  }

  Future<dynamic> getMapGateway() async {
    try {
      final response = await http.get(
        Uri.parse("${global.baseUrl}mapby"),
      );
log("statusCode: ${response.statusCode} url: ${response.request!.url} response: ${response.body} ");

      dynamic recordList;
      if (response.statusCode == 200 && json.decode(response.body)["status"] == "1") {
        recordList = MapByModel.fromJson(json.decode(response.body));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint("Exception - getMapGateway(): $e");
    }
  }

  Future<dynamic> getNearByBanners(String? lat, String? lng) async {
    try {
      final response = await http.post(
        Uri.parse("${global.baseUrl}getnearbanner"),
        headers: await global.getApiHeaders(false),
        body: json.encode({
          "lat": lat,
          "lng": lng,
          
        }),
      );
log("statusCode: ${response.statusCode} url: ${response.request!.url} response: ${response.body} ");

      
      dynamic recordList;
      if (response.statusCode == 200 && json.decode(response.body)["status"] == "1") {
        recordList = List<BannerModel>.from(json.decode(response.body)["data"].map((x) => BannerModel.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint("Exception - getNearByBanners(): $e");
    }
  }

  Future<dynamic> getNearByBarberShops(String? lat, String? lng, int pageNumber, {String? searchstring}) async {
    try {
      final response = await http.post(
        Uri.parse("${global.baseUrl}getnearbysalons?page=${pageNumber.toString()}"),
        headers: await global.getApiHeaders(false),
        body: json.encode({
          "lat": lat,
          "lng": lng,
          "searchstring": searchstring,
          "lang": global.languageCode,
        }),
      );
log("statusCode: ${response.statusCode} url: ${response.request!.url} response: ${response.body} ");
     
      dynamic recordList;
      if (response.statusCode == 200 && json.decode(response.body)["status"] == "1") {
        recordList = List<BarberShop>.from(json.decode(response.body)["data"].map((x) => BarberShop.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint("Exception - getNearByBarberShops(): $e");
    }
  }

  Future<dynamic> getNearByCouponsList(String? lat, String? lng) async {
    try {
      final response = await http.post(
        Uri.parse("${global.baseUrl}getnearcouponlist"),
        headers: await global.getApiHeaders(true),
        body: json.encode({"lat": lat, "lng": lng, "lang": global.languageCode}),
      );
log("statusCode: ${response.statusCode} url: ${response.request!.url} response: ${response.body} ");

      dynamic recordList;
      if (response.statusCode == 200 && json.decode(response.body)["status"] == "1") {
        recordList = List<Coupons>.from(json.decode(response.body)["data"].map((x) => Coupons.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint("Exception - getNearByCouponsList(): $e");
    }
  }

  Future<dynamic> getNotifications(int? userId) async {
    try {
      final response = await http.post(
        Uri.parse("${global.baseUrl}allnotifications"),
        headers: await global.getApiHeaders(true),
        body: json.encode({
          "user_id": userId,
          
        }),
      );
log("statusCode: ${response.statusCode} url: ${response.request!.url} response: ${response.body} ");

      dynamic recordList;
      if (response.statusCode == 200 && json.decode(response.body)["status"] == "1") {
        recordList = List<NotificationList>.from(json.decode(response.body)["data"].map((x) => NotificationList.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint("Exception - getNotifications(): $e");
    }
  }

  Future<dynamic> getPaymentGateways() async {
    try {
      final response = await http.get(Uri.parse("${global.baseUrl}payment_gateways"), headers: await global.getApiHeaders(true));
log("statusCode: ${response.statusCode} url: ${response.request!.url} response: ${response.body} ");
      dynamic recordList;
      if (response.statusCode == 200 && json.decode(response.body)["status"] == "1") {
        recordList = PaymentGateway.fromJson(json.decode(response.body)["data"]);
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint("Exception - getPaymentGateways(): $e");
    }
  }

  Future<dynamic> getPopularBarbersList(String? lat, String? lng, int pageNumber, String? searchstring) async {
    try {
      final response = await http.post(
        Uri.parse("${global.baseUrl}popular_barber?page=${pageNumber.toString()}"),
        headers: await global.getApiHeaders(false),
        body: json.encode({
          "lat": lat,
          "lng": lng,
          "searchstring": searchstring,
          "lang": global.languageCode,
        }),
      );
log("statusCode: ${response.statusCode} url: ${response.request!.url} response: ${response.body} ");

      dynamic recordList;
      if (response.statusCode == 200 && json.decode(response.body)["status"] == "1") {
        recordList = List<PopularBarbers>.from(json.decode(response.body)["data"].map((x) => PopularBarbers.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint("Exception - getPopularBarbersList(): $e");
    }
  }

  Future<dynamic> getProductDetails(int? productId) async {
    try {
      final response = await http.post(
        Uri.parse("${global.baseUrl}product_det"),
        headers: await global.getApiHeaders(false),
        body: json.encode({"product_id": productId, "user_id": global.user!.id, "lang": global.languageCode}),
      );
log("statusCode: ${response.statusCode} url: ${response.request!.url} response: ${response.body} ");

      dynamic recordList;

      if (response.statusCode == 200 && json.decode(response.body)["status"] == "1") {
        recordList = ProductDetail.fromJson(json.decode(response.body)["data"]);
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint("Exception - getProductDetails(): $e");
    }
  }

  Future<dynamic> getProductOrderHistory() async {
    try {
      final response = await http.post(
        Uri.parse("${global.baseUrl}product_orders"),
        headers: await global.getApiHeaders(true),
        body: json.encode({"user_id": global.user!.id, "lang": global.languageCode}),
      );
log("statusCode: ${response.statusCode} url: ${response.request!.url} response: ${response.body} ");

      dynamic recordList;
      if (response.statusCode == 200 && json.decode(response.body)["status"] == "1") {
        recordList = List<ProductOrderHistory>.from(json.decode(response.body)["data"].map((x) => ProductOrderHistory.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint("Exception - getProductOrderHistory(): $e");
    }
  }

  Future<dynamic> getProducts(String? lat, String? lng, int pageNumber, String searchstring) async {
    try {
      final response = await http.post(
        Uri.parse("${global.baseUrl}salon_products?page=${pageNumber.toString()}"),
        headers: await global.getApiHeaders(false),
        body: json.encode({"lat": lat, "lng": lng, "user_id": global.user!.id, "searchstring": searchstring, "lang": global.languageCode}),
      );
log("statusCode: ${response.statusCode} url: ${response.request!.url} response: ${response.body} ");
      dynamic recordList;
      if (response.statusCode == 200 && json.decode(response.body)["status"] == "1") {
        recordList = List<Product>.from(json.decode(response.body)["data"].map((x) => Product.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint("Exception - getProducts(): $e");
    }
  }

  Future<dynamic> getReferandEarn() async {
    try {
      Response response;
      var dio = Dio();

      response = await dio.get('${global.baseUrl}refer_n_earn',
          
          options: Options(
            headers: await global.getApiHeaders(true),
          ));log("statusCode: ${response.statusCode} url: ${response.requestOptions.uri} response: ${response.data} ");
      dynamic recordList;
      if (response.statusCode == 200 && response.data["status"] == "1") {
        recordList = response.data["data"];
      } else {
        recordList = null;
      }
      return getDioResult(response, recordList);
    } catch (e) {
      debugPrint("Exception - getReferandEarn(): $e");
    }
  }

  Future<dynamic> getSalonListForServices(String? lat, String? lng, String? serviceName) async {
    try {
      final response = await http.post(
        Uri.parse("${global.baseUrl}service_salons"),
        headers: await global.getApiHeaders(false),
        body: json.encode({
          "lat": lat,
          "lng": lng,
          "service_name": serviceName,
        }),
      );log("statusCode: ${response.statusCode} url: ${response.request!.url} response: ${response.body} ");

      dynamic recordList;
      if (response.statusCode == 200 && json.decode(response.body)["status"] == "1") {
        recordList = List<BarberShop>.from(json.decode(response.body)["data"].map((x) => BarberShop.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint("Exception - getNearByBarberShops(): $e");
    }
  }

  Future<dynamic> getScratchCards() async {
    try {
      final response = await http.post(
        Uri.parse("${global.baseUrl}user_scratch_cards"),
        headers: await global.getApiHeaders(true),
        body: json.encode({
          "user_id": global.user!.id,
          
        }),
      );log("statusCode: ${response.statusCode} url: ${response.request!.url} response: ${response.body} ");

      dynamic recordList;
      if (response.statusCode == 200 && json.decode(response.body)["status"] == "1") {
        recordList = List<ScratchCard>.from(json.decode(response.body)["data"].map((x) => ScratchCard.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint("Exception - getScratchCards(): $e");
    }
  }

  Future<dynamic> getServices(String? lat, String? lng, int pageNumber, {String? searchstring}) async {
    try {
      final response = await http.post(
        Uri.parse("${global.baseUrl}services?page=${pageNumber.toString()}"),
        headers: await global.getApiHeaders(false),
        body: json.encode({"lat": lat, "lng": lng, "searchstring": searchstring, "lang": global.languageCode}),
      );log("statusCode: ${response.statusCode} url: ${response.request!.url} response: ${response.body} ");

      dynamic recordList;
      if (response.statusCode == 200 && json.decode(response.body)["status"] == "1") {
        recordList = List<Service>.from(json.decode(response.body)["data"].map((x) => Service.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint("Exception - getServices(): $e");
    }
  }

  Future<dynamic> getTermsAndCondition() async {
    try {
      Response response;
      var dio = Dio();

      response = await dio.get('${global.baseUrl}terms',
          queryParameters: {
            'lang': global.languageCode,
          },
          options: Options(
            headers: await global.getApiHeaders(false),
          ));
log("statusCode: ${response.statusCode} url: ${response.requestOptions.uri} response: ${response.data} ");
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = TermsAndCondition.fromJson(response.data['data']);
      } else {
        recordList = null;
      }
      return getDioResult(response, recordList);
    } catch (e) {
      debugPrint("Exception - getTermsAndCondition(): $e");
    }
  }

  Future<dynamic> getTimeSLot(String? selectedDate, int? staffId, int? vendorId) async {
    try {
      final response = await http.post(
        Uri.parse("${global.baseUrl}timeslot"),
        headers: await global.getApiHeaders(true),
        body: json.encode({
          "selected_date": selectedDate,
          "staff_id": staffId,
          "vendor_id": vendorId,
          
        }),
      );log("statusCode: ${response.statusCode} url: ${response.request!.url} response: ${response.body} ");

      dynamic recordList;
      if (response.statusCode == 200 && json.decode(response.body)["status"] == "1") {
        recordList = List<TimeSlot>.from(json.decode(response.body)["data"].map((x) => TimeSlot.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint("Exception - getTimeSLot(): $e");
    }
  }

  Future<dynamic> getUserProfile(int? id) async {
    try {
      final response = await http.post(
        Uri.parse("${global.baseUrl}myprofile"),
        headers: await global.getApiHeaders(true),
        body: json.encode({
          "id": id,
          
        }),
      );log("statusCode: ${response.statusCode} url: ${response.request!.url} response: ${response.body} ");

      dynamic recordList;
      if (response.statusCode == 200 && json.decode(response.body)["status"] == "1") {
        recordList = CurrentUser.fromJson(json.decode(response.body)["data"]);
        recordList.token = json.decode(response.body)["token"];
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint("Exception - getUserProfile(): $e");
    }
  }

  Future<dynamic> loginWithEmail(CurrentUser user) async {
    try {
      final response = await http.post(
        Uri.parse("${global.baseUrl}login_with_email"),
        headers: await global.getApiHeaders(false),
        body: json.encode(user),
      );log("statusCode: ${response.statusCode} url: ${response.request!.url} response: ${response.body} ");

        
      dynamic recordList;
      if (response.statusCode == 200 && json.decode(response.body) != null && json.decode(response.body)["data"] != null) {
        recordList = CurrentUser.fromJson(json.decode(response.body)["data"]["user"]);
        recordList.cartCount = json.decode(response.body)['data']["cart_count"];
        recordList.token = json.decode(response.body)["token"];
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint("Exception - loginWithEmail(): $e");
    }
  }

  Future<dynamic> loginWithPhone(CurrentUser user) async {
    try {
      final response = await http.post(
        Uri.parse("${global.baseUrl}login_with_phone"),
        headers: await global.getApiHeaders(false),
        body: json.encode(user),
      );
    log("statusCode: ${response.statusCode} url: ${response.request!.url} response: ${response.body} ");

      dynamic recordList;
      if (response.statusCode == 200 && json.decode(response.body) != null && json.decode(response.body)["data"] != null) {
        recordList = CurrentUser.fromJson(json.decode(response.body)["data"]);
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint("Exception - loginWithPhone(): $e");
    }
  }

  Future<dynamic> onScratch(int? scratchId, int? userId) async {
    try {
      final response = await http.post(
        Uri.parse("${global.baseUrl}scratch"),
        headers: await global.getApiHeaders(true),
        body: json.encode({"user_id": userId, "scratch_id": scratchId}),
      );log("statusCode: ${response.statusCode} url: ${response.request!.url} response: ${response.body} ");

      dynamic recordList;
      if (response.statusCode == 200 && json.decode(response.body)["status"] == "1") {
        recordList = ScratchCard.fromJson(json.decode(response.body)["data"]);
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint("Exception - onScratch(): $e");
    }
  }

  Future<dynamic> privacyPolicy() async {
    try {
      Response response;
      var dio = Dio();

      response = await dio.get('${global.baseUrl}privacy',
          queryParameters: {
            'lang': global.languageCode,
          },
          options: Options(
            headers: await global.getApiHeaders(false),
          ));
       log("statusCode: ${response.statusCode} url: ${response.requestOptions.uri} response: ${response.data} ");
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = PrivacyPolicy.fromJson(response.data['data']);
      } else {
        recordList = null;
      }
      return getDioResult(response, recordList);
    } catch (e) {
      debugPrint("Exception - privacyPolicy(): $e");
    }
  }
  Future<dynamic> productCartCheckout(int? userId, String paymentStatus, String paymentGateway, {String? paymentId}) async {
    try {
      log( "sss userId: $userId, paymentStatus: $paymentStatus, paymentGateway: $paymentGateway, paymentId: $paymentId");
      final response = await http.post(
        Uri.parse("${global.baseUrl}product_cart_checkout"),
        headers: await global.getApiHeaders(true),
        body: json.encode({"user_id": userId, "payment_status": paymentStatus, "payment_gateway": paymentGateway, "payment_id": paymentId, "lang": global.languageCode}),
      );log("statusCode: ${response.statusCode} url: ${response.request!.url} response: ${response.body} ");

      dynamic recordList;
      if (response.statusCode == 200 && json.decode(response.body)["status"] == "1" || json.decode(response.body)["status"] == "2") {
        recordList = ProductCartCheckout.fromJson(json.decode(response.body)["data"]["order"]);
        global.user!.cartCount = json.decode(response.body)['data']['cart_count'];
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint("Exception - productCartCheckout(): $e");
    }
  }

  Future<dynamic> signUp(CurrentUser user) async {
    try {
      Response response;
      var dio = Dio();
      log("user: ${user.toJson()}");
      var formData = FormData.fromMap({
        'user_name': user.username,
        'user_email': user.userEmail,
        'user_phone': user.userPhone,
        'user_password': user.userPassword,
        'device_id': global.appDeviceId,
        'referral_code': user.referralCode,
        'fb_id': user.fbId,
        'user_image': user.userImage != null ? await MultipartFile.fromFile(user.userImage!.path.toString()) : null,
        'apple_id': user.appleId
      });      
      response = await dio.post('${global.baseUrl}signup',
          data: formData,
          options: Options(
            headers: await global.getApiHeaders(false),
          ));
   log("statusCode: ${response.statusCode} url: ${response.requestOptions.uri} response: ${response.data} ");
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = CurrentUser.fromJson(response.data['data']);
      } else {
        recordList = null;
      }
     return getDioResult(response, recordList);
    } catch (e) {
      debugPrint("Exception - signUp(): $e");
    }
  }

  Future<dynamic> socialLogin({String? userEmail, String? facebookId, String? emailId, String? type, String? appleId}) async {
    try {
      final response = await http.post(
        Uri.parse("${global.baseUrl}social_login"),
        headers: await global.getApiHeaders(false),
        body: json.encode({"user_email": userEmail, "facebook_id": facebookId, "email_id": emailId, "type": type, "apple_id": appleId}),
      );log("statusCode: ${response.statusCode} url: ${response.request!.url} response: ${response.body} ");

      dynamic recordList;
      if (response.statusCode == 200 && jsonDecode(response.body)["status"] == "1") {
        recordList = CurrentUser.fromJson(json.decode(response.body)["data"]["user"]);
        recordList.cartCount = json.decode(response.body)['data']["cart_count"];
        recordList.token = json.decode(response.body)["token"];
      } else if (response.statusCode == 200 && jsonDecode(response.body)["status"] == "4") {
        recordList = null;
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint("Exception - socialLogin(): $e");
    }
  }

  Future<dynamic> updateProfile(
    int? id,
    String? userName,
    File? userImage, {
    String? userPassword,
  }) async {
    try {
      Response response;
      var dio = Dio();
      var formData = FormData.fromMap({
        'id': id,
        'user_name': userName,
        'user_password': userPassword,
        
        'user_image': userImage != null ? await MultipartFile.fromFile(userImage.path.toString()) : null,
      });
      
      response = await dio.post('${global.baseUrl}profile_edit',
          data: formData,
          options: Options(
            headers: await global.getApiHeaders(true),
          ));log("statusCode: ${response.statusCode} url: ${response.requestOptions.uri} response: ${response.data} ");
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = CurrentUser.fromJson(response.data['data']);
        recordList.token = response.data["token"];
      } else {
        recordList = null;
      }
      return getDioResult(response, recordList);
    } catch (e) {
      debugPrint("Exception - updateProfile(): $e");
    }
  }

  Future<dynamic> verifyOtpAfterLogin(String? userPhone, String? status, String? deviceId) async {
    try {
      final response = await http.post(
        Uri.parse("${global.baseUrl}login_verifyotpfirebase"),
        headers: await global.getApiHeaders(false),
        body: json.encode({"user_phone": userPhone, "status": status, "device_id": deviceId}),
      );log("statusCode: ${response.statusCode} url: ${response.request!.url} response: ${response.body} ");

      dynamic recordList;
      if (response.statusCode == 200 && json.decode(response.body) != null && json.decode(response.body)["data"] != null) {
        recordList = CurrentUser.fromJson(json.decode(response.body)["data"]["user"]);
        recordList.cartCount = json.decode(response.body)['data']["cart_count"];
        recordList.token = json.decode(response.body)["token"];
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint("Exception - verifyOtpAfterLogin(): $e");
    }
  }

  Future<dynamic> verifyOtpAfterRegistration(String? userPhone, String? status, String? referralCode, String? deviceId) async {
    try {
    log("status :$status");  
    log("referralCode :$referralCode");
    log("deviceId :$deviceId");
    log("userPhone :$userPhone");
     final response = await http.post(
        Uri.parse("${global.baseUrl}verify_via_firebase"),
        headers: await global.getApiHeaders(false),
        body: json.encode({"user_phone": userPhone, "status": status, "referral_code": referralCode, "device_id": deviceId}),
      );
     log("statusCode: ${response.statusCode} url: ${response.request!.url} response: ${response.body} ");

      dynamic recordList;
      if (response.statusCode == 200 && jsonDecode(response.body)["status"] == "1") {
        recordList = CurrentUser.fromJson(json.decode(response.body)["data"]);
        recordList.token = json.decode(response.body)["token"];
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint("Exception - verifyOtpAfterRegistration(): $e");
    }
  }
  Future<dynamic> verifyOtpForgotPassword(String? userEmail, String otp) async {
    try {
      final response = await http.post(
        Uri.parse("${global.baseUrl}verify_otp"),
        headers: await global.getApiHeaders(false),
        body: json.encode({"user_email": userEmail, "otp": otp}),
      );log("statusCode: ${response.statusCode} url: ${response.request!.url} response: ${response.body} ");

      dynamic recordList;
      if (response.statusCode == 200 && jsonDecode(response.body)["status"] == "1") {
        recordList = CurrentUser.fromJson(json.decode(response.body)["data"]);
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint("Exception - verifyOtpForgotPassword(): $e");
    }
  }
}

