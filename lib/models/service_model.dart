import 'package:app/models/service_type_model.dart';
import 'package:flutter/foundation.dart';

class Service {
  int? serviceId;
  String? serviceName;
  String? serviceImage;
  int? vendorId;
  int? shopType;
  List<ServiceType> serviceType = [];

  Service();

  Service.fromJson(Map<String, dynamic> json) {
    try {
      serviceName = json['service_name'];
      serviceImage = json['service_image'] ?? '';

      serviceId = json['service_id'] != null ? int.parse('${json['service_id'] }'): null;
      vendorId = json['vendor_id'] != null ? int.parse('${json['vendor_id']}') : null;

      shopType = json['shop_type'] != null ? int.parse('${json['shop_type']}') : null;
      serviceType = json['service_type'] != null && json['service_type'] != [] ? List<ServiceType>.from(json['service_type'].map((x) => ServiceType.fromJson(x))) : [];
    } catch (e) {
      debugPrint("Exception - seviceModel.dart - Service.fromJson():$e");
    }
  }
}
