import 'dart:convert';

import 'package:app/models/currency_model.dart';
import 'package:app/models/google_map_model.dart';
import 'package:app/models/map_box_model.dart';
import 'package:app/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? appDeviceId;
String appName = 'Salonatna';
String appShareMessage = "I'm inviting you to use $appName, a simple and easy app to find saloon services and products near by your location. Here's my code [CODE] - jusy enter it while registration.";
String appVersion = '1.0';
String baseUrl = 'https://salony.topbusiness.ebharbook.com/api/';
String baseUrlForImage = 'https://salony.topbusiness.ebharbook.com/';
// String baseUrl = 'https://gofresha.tecmanic.com/api/';
// String baseUrlForImage = 'https://gofresha.tecmanic.com/';
Currency currency = Currency();
late String currentLocation;
String googleAPIKey = "AIzaSyCfg_eIB8dSjOehFq0O-nMTPQlNL6Lu58g";
bool isRTL = false;
String? languageCode;
String? lat;
String? lng;
bool isGoogleMap = false;
MapBoxModel? mapBoxModel = MapBoxModel();
GoogleMapModel? mapGBoxModel = GoogleMapModel();
List<String> rtlLanguageCodeLList = ['ar', 'arc', 'ckb', 'dv', 'fa', 'ha', 'he', 'khw', 'ks', 'ps', 'ur', 'uz_AF', 'yi'];
late SharedPreferences sp;
CurrentUser? user = CurrentUser();
Future<Map<String, String>> getApiHeaders(bool authorizationRequired) async {
  Map<String, String> apiHeader = <String, String>{};
  if (authorizationRequired) {
    sp = await SharedPreferences.getInstance();
    if (sp.getString("currentUser") != null) {
      CurrentUser currentUser = CurrentUser.fromJson(json.decode(sp.getString("currentUser")!));
      apiHeader.addAll({"Authorization": "Bearer${currentUser.token!}"});
    }
  }
  apiHeader.addAll({"Content-Type": "application/json"});
  apiHeader.addAll({"Accept": "application/json"});
  return apiHeader;
}

// Future<String?> getDeviceId() async {
//   String? deviceId;
//   DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
//
//   if (Platform.isAndroid) {
//     AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
//     deviceId = androidDeviceInfo.androidId;
//   } else if (Platform.isIOS) {
//     IosDeviceInfo androidDeviceInfo = await deviceInfo.iosInfo;
//     deviceId = androidDeviceInfo.identifierForVendor;
//   }
//   return deviceId;
// }
