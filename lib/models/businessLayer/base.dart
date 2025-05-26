import 'dart:core';
import 'dart:io';
import 'package:app/models/businessLayer/api_helper.dart';
import 'package:app/models/businessLayer/business_rule.dart';
import 'package:app/models/businessLayer/global.dart' as global;
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
class Base extends StatefulWidget {
  final FirebaseAnalytics? analytics;
  final FirebaseAnalyticsObserver? observer;
  final String? routeName;
  const Base({super.key, this.analytics, this.observer, this.routeName});
  @override
  BaseState createState() => BaseState();
}
class BaseState<T extends Base> extends State<T> with TickerProviderStateMixin, WidgetsBindingObserver {
  bool bannerAdLoaded = false;
  late Position _currentPosition;
  APIHelper? apiHelper;
  late BusinessRule br;

  BaseState() {
    apiHelper = APIHelper();
    br = BusinessRule(apiHelper);
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
  void closeDialog() {
    Navigator.of(context).pop();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }


  Future<bool> dontCloseDialog() async {
    return false;
  }

  Future exitAppDialog() async {
    try {
      showCupertinoDialog(
          context: context,
          builder: (BuildContext context) {
            return Theme(
              data: ThemeData(dialogBackgroundColor: Colors.white),
              child: CupertinoAlertDialog(
                title: const Text(
                  "Exit app",
                ),
                content: const Text(
                  "Are you sure you want to exit app?",
                ),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.red),
                    ),
                    onPressed: () {
                      // Dismiss the dialog but don't
                      // dismiss the swiped item
                      return Navigator.of(context).pop(false);
                    },
                  ),
                  CupertinoDialogAction(
                    child: const Text("Exit"),
                    onPressed: () async {
                      exit(0);
                    },
                  ),
                ],
              ),
            );
          });
    } catch (e) {
      debugPrint('Exception - base.dart - exitAppDialog(): $e');
    }
  }

  getAddressFromLatLng() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(_currentPosition.latitude, _currentPosition.longitude);

      Placemark place = placemarks[0];

      setState(() {
        global.currentLocation = "${place.name}, ${place.locality} ";
      });
    } catch (e) {
      debugPrint("Exception -  base.dart - getAddressFromLatLng():$e");
    }
  }

  getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);

      global.lat = position.latitude.toString();
      global.lng = position.longitude.toString();
      _currentPosition = position;
      await getAddressFromLatLng();
      setState(() {});
    } catch(e) {
      debugPrint("Exception -  base.dart - getCurrentLocation():$e");
    }
  }

  getCurrentPosition() async {
    try {
      if (Platform.isIOS) {
        LocationPermission s = await Geolocator.checkPermission();
        if (s == LocationPermission.denied || s == LocationPermission.deniedForever) {
          s = await Geolocator.requestPermission();
        }
        if (s != LocationPermission.denied || s != LocationPermission.deniedForever) {
          await getCurrentLocation();
        }
      } else {
        PermissionStatus permissionStatus = await Permission.location.status;
        if (permissionStatus.isDenied || permissionStatus.isPermanentlyDenied) {
          permissionStatus = await Permission.location.request();
        }
        if (permissionStatus.isGranted) {
          await getCurrentLocation();
        }
      }
    } catch (e) {
      debugPrint("Exception -  base.dart - getCurrentPosition():$e");
    }
  }

  void hideLoader() {
    Navigator.pop(context);
  }

  @override
  void initState() async {
    super.initState();
  }

  Widget sc(Widget body) {
    return SafeArea(child: body);
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  showNetworkErrorSnackBar(GlobalKey<ScaffoldState>? scaffoldKey) {
    try {
      bool isConnected;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: const Duration(days: 1),
        content: const Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.signal_wifi_off,
              color: Colors.white,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  left: 16.0,
                ),
                child: Text(
                  'No internet available',
                  textAlign: TextAlign.start,
                ),
              ),
            ),
          ],
        ),
        action: SnackBarAction(
            textColor: Colors.white,
            label: 'RETRY',
            onPressed: () async {
              isConnected = await br.checkConnectivity();
              if (isConnected && mounted) {
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
              } else {
                showNetworkErrorSnackBar(scaffoldKey);
              }
            }),
        backgroundColor: Colors.grey,
      ));
    } catch (e) {
      debugPrint("Exception -  base.dart - showNetworkErrorSnackBar():$e");
    }
  }

  showOnlyLoaderDialog() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Dialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  void showSnackBar({required String snackBarMessage, Key? key}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      key: key,
      content: Text(
        snackBarMessage,
        textAlign: TextAlign.center,
      ),
      duration: const Duration(seconds: 2),
    ));
  }
}
