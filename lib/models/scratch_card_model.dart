import 'package:flutter/foundation.dart';

class ScratchCard{
  int? id;
  int? userId;
  int? scratchId;
  String? earning;
  int? earnPoints;
  late bool isScratch;
  DateTime? createdAt;
  String? scratchCardImage;

 ScratchCard();

  ScratchCard.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'] != null ? int.parse('${json['id']}') : null;
      userId = json['user_id'] != null ? int.parse('${json['user_id']}') : null;
       scratchId = json['scratch_id'] != null ? int.parse('${json['scratch_id']}') : null;
      earning = json['earning'];
      earnPoints = json['earn_points'] != null ? int.parse('${json['earn_points']}') : null;
      isScratch = json['is_scratch'] != null && int.parse('${json['is_scratch']}') == 0 ? false : true;
      scratchCardImage = json['scratch_card_image'];
           createdAt = json['created_at'] != null ? DateTime.parse(json['created_at'].toString()).toLocal() : null;
    } catch (e) {
      debugPrint("Exception - scratch_card_model.dart - ScratchCard.fromJson():$e");
    }
  }

}