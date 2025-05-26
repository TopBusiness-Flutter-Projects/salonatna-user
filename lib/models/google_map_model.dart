import 'package:flutter/foundation.dart';

class GoogleMapModel {
  int? keyId;
  String? mapApiKey;

  GoogleMapModel();

  GoogleMapModel.fromJson(Map<String, dynamic> json) {
    try {
      keyId = json['key_id'] != null ? int.parse('${json['key_id']}') : null;
      mapApiKey = json['map_api_key'];
    } catch (e) {
      debugPrint("Exception - google_map_model.dart - GoogleMapModel.fromJson():$e");
    }
  }

  @override
  String toString() {
    return 'GoogleMapModel{key_id: $keyId, map_api_key: $mapApiKey}';
  }
}
