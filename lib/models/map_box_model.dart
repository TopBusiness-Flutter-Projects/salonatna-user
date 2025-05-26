import 'package:flutter/foundation.dart';

class MapBoxModel {
  int? mapId;
  String? mapboxApi;

  MapBoxModel();

  MapBoxModel.fromJson(Map<String, dynamic> json) {
    try {
      mapId = json['map_id'] != null ? int.parse('${json['map_id']}') : null;
      mapboxApi = json['mapbox_api'];
    } catch (e) {
      debugPrint("Exception - map_box_model.dart - MapBoxModel.fromJson():$e");
    }
  }
}
