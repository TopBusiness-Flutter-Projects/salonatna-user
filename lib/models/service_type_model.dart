import 'package:flutter/foundation.dart';

class ServiceType {
  int? variantId;
  int? serviceId;
  String? variant;
  int? price;
  int? time;
  String? serviceName;
  int? vendorId;

  ServiceType();

  ServiceType.fromJson(Map<String, dynamic> json) {
    try {
      variantId = json['varient_id'] != null ? int.parse('${json['varient_id']}') : null;
      serviceId = json['service_id'] != null ? int.parse('${json['service_id']}') : null;
      variant = json['varient'];
      time = json['time'] != null ? int.parse('${json['time']}') : null;
      // vendor_id = json['vendor_id'] != null ? json['vendor_id'] : null;
      price = json['price'] != null ? int.parse('${json['price']}') : null;
      serviceName = json['service_name'];
      vendorId = json['vendor_id'] != null ? int.parse('${json['vendor_id']}') : null;
    } catch (e) {
      debugPrint("Exception - service_type_model.dart - ServiceType.fromJson():$e");
    }
  }

  Map<String, dynamic> toJson() => {
        'varient_id': variantId?.toString(),
      };
}
