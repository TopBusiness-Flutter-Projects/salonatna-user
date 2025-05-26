import 'package:app/models/popular_barbers_model.dart';
import 'package:app/models/service_model.dart';
import 'package:app/models/time_slot_model.dart';
import 'package:flutter/foundation.dart';

class BookAppointment {
  String? salonName;
  String? owner;
  String? description;
  int? type;
  String? vendorLogo;
  String? vendorLoc;
  int? vendorId;
  double? rating;
  int? staffId;
  String? selectedDate;
  List<Service> services = [];
  List<TimeSlot>? timeSlot = [];
  List<PopularBarbers> barber = [];

  BookAppointment();

  BookAppointment.fromJson(Map<String, dynamic> json) {
    try {
      salonName = json['salon_name'];
      owner = json['owner'];
      description = json['description'];
      type = json['type'] != null ? int.parse('${json['type']}') : null;
      rating = json['rating'] != null ? double.parse('${json['rating']}') : null;
      vendorLogo = json['vendor_logo'];
      vendorLoc = json['vendor_loc'];
      vendorId = json['vendor_id'] != null ? int.parse('${json['vendor_id']}') : null;
      staffId = json['staff_id'] != null ? int.parse('${json['staff_id']}') : null;
      selectedDate = json['selected_date'];
      barber = json['barber'] != null && json['barber'] != [] ? List<PopularBarbers>.from(json['barber'].map((x) => PopularBarbers.fromJson(x))) : [];
      timeSlot = json['time_slot'] != null && json['time_slot'] != [] ? List<TimeSlot>.from(json['time_slot'].map((x) => TimeSlot.fromJson(x))) : [];
      services = json['services'] != null && json['services'] != [] ? List<Service>.from(json['services'].map((x) => Service.fromJson(x))) : [];
    } catch (e) {
      debugPrint("Exception - book_appointment_model.dart - BookAppointment.fromJson():$e");
    }
  }
}
