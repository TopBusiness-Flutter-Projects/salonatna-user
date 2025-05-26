import 'package:flutter/foundation.dart';

class BannerModel {
  int? bannerId;
  String? bannerName;
  String? bannerImage;
  int? service;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? vendorId;
  BannerModel();

  BannerModel.fromJson(Map<String, dynamic> json) {
    try {
      bannerId = json['banner_id'] != null ? int.parse('${json['banner_id']}') : null;
      bannerName = json['banner_name'];
      bannerImage = json['banner_image'] != null && json['banner_image'] != '' && json['banner_image'] != 'N/A' && json['banner_image'] != 'NA' ? json['banner_image'] : null;
      service = json['service'] != null ? int.parse('${json['service']}') : null;
      vendorId = json['vendor_id'];
    } catch (e) {
      debugPrint("Exception - banner_model.dart - Banner.fromJson():$e");
    }
  }

  Map<String, dynamic> toJson() => {
        'banner_id': bannerId,
        'banner_name': bannerName != null && bannerName!.isNotEmpty ? bannerName : null,
        'banner_image': bannerImage != null && bannerImage!.isNotEmpty ? bannerImage : null,
        'service': service,
        'vendor_id': vendorId,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
      };
}
