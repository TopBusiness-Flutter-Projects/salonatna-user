import 'package:app/models/review_model.dart';
import 'package:app/models/weekly_time_model.dart';
import 'package:flutter/foundation.dart';

class PopularBarbers {
  String? staffName;
  String? staffImage;
  int? staffId;
  int? count;
  int? vendorId;
  String? vendorName;
  String? vendorLogo;
  String? owner;
  String? vendorLoc;
  String? staffDescription;
  String? salonName;
  int? type;
  late double rating;
  List<WeekTimeSlot> weeklyTime = [];
  List<Review> review = [];

  PopularBarbers();

  PopularBarbers.fromJson(Map<String, dynamic> json) {
    try {
      staffName = json['staff_name'];
      staffImage = json['staff_image'];
      staffId = json['staff_id'] != null ? int.parse('${json['staff_id']}') : null;
      count = json['count'] != null ? int.parse('${json['count']}') : null;
      vendorLoc = json['vendor_loc'];
      vendorId = json['vendor_id'] != null ? int.parse('${json['vendor_id']}') : null;
      vendorName = json['vendor_name'];
      vendorLogo = json['vendor_logo'] ?? '';
      owner = json['owner'];
      staffDescription = json['staff_description'];
      salonName = json['salon_name'];
      type = json['type'] != null ? int.parse('${json['type']}') : null;
      rating = json['rating'] != null ? double.parse(json['rating'].toString()) : 0;
      weeklyTime = json['weekly_time'] != null && json['weekly_time'] != [] ? List<WeekTimeSlot>.from(json['weekly_time'].map((x) => WeekTimeSlot.fromJson(x))) : [];
      review = json['review'] != null && json['review'] != [] ? List<Review>.from(json['review'].map((x) => Review.fromJson(x))) : [];
    } catch (e) {
      debugPrint("Exception - popular_barbers_model.dart - PopularBarbers.fromJson():$e");
    }
  }
}
