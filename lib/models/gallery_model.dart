import 'package:flutter/foundation.dart';

class Gallery {
  int? id;
  String? image;
  int? vendorId;

  Gallery();

  Gallery.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'] != null ? int.parse('${json['id']}') : null;
      vendorId = json['vendor_id'] != null ? int.parse('${json['vendor_id']}') : null;
      image = json['image'];
    } catch (e) {
      debugPrint("Exception - gallery_model.dart - Gallery.fromJson():$e");
    }
  }
}
