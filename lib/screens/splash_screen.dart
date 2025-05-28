import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:app/models/businessLayer/base_route.dart';
import 'package:app/models/businessLayer/global.dart' as global;
import 'package:app/models/user_model.dart';
import 'package:app/provider/local_provider.dart';
import 'package:app/screens/intro_screen.dart';
import 'package:app/widgets/bottom_navigation_widget.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class SplashScreen extends BaseRoute {
  const SplashScreen({super.key, super.a, super.o}) : super(r: 'SplashScreen');

  @override
  BaseRouteState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends BaseRouteState<SplashScreen> {
  GlobalKey<ScaffoldState>? _scaffoldKey;
  bool isloading = true;
  _SplashScreenState() : super();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, result) {
        if(didPop) {
          return;
        }

        exitAppDialog();
      },
      child:
        Scaffold(
          body: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                'assets/splash.jpg',
                
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
              ),
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 0.5, sigmaY: 0.5),
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.black.withOpacity(0.7),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 100),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    children: [
                      const CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 120,
                        backgroundImage: AssetImage(
                          'assets/logo_splash.png',
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Text(
                          AppLocalizations.of(context)!.lbl_loading,
                          style: const TextStyle(color: Colors.white, fontSize: 22),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 70, left: 10, right: 10),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(style: const TextStyle(color: Colors.white, fontSize: 18), children: [
                        TextSpan(text: AppLocalizations.of(context)!.txt_welcome_to +' '),
                        TextSpan(
                          text: AppLocalizations.of(context)!.lbl_gofresha,
                          style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 18),
                        ),
                        TextSpan(text:' '+ AppLocalizations.of(context)!.txt_app, style: const TextStyle(color: Colors.white, fontSize: 18))
                      ])),
                ),
              )
            ],
          ),
        ),
      );
  }

  void init() async {
    try {
      await br.getSharedPreferences();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final provider = Provider.of<LocaleProvider>(context, listen: false);
        if (global.sp.getString("selectedLanguage") == null) {
          var locale = provider.locale ?? const Locale('en');
          global.languageCode = locale.languageCode;
        } else {
          global.languageCode = global.sp.getString("selectedLanguage");
          provider.setLocale(Locale(global.languageCode!));
        }
        if (global.rtlLanguageCodeLList.contains(global.languageCode)) {
          global.isRTL = true;
        } else {
          global.isRTL = false;
        }
      });

      // We execute this functions in parallel and store the results into configResults
      final List<dynamic> configResults = await Future.wait([
        _getMapBox(),
// _getToken(),
  _getCurrency(),
        br.checkConnectivity()
      ]);

      // global.appDeviceId = configResults[1];
      bool isConnected = configResults[2];

      if (isConnected) {
        if (global.sp.getString('currentUser') != null) {
          global.user = CurrentUser.fromJson(json.decode(global.sp.getString("currentUser")!));
          await getCurrentPosition().then((_) async {
            if (global.lat != null && global.lng != null) {
              setState(() {});
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                  builder: (context) => BottomNavigationWidget(
                    a: widget.analytics,
                    o: widget.observer,
                  )), (route) => false);
            } else {
              hideLoader();
              showSnackBar(key: _scaffoldKey, snackBarMessage: 'Please enable location permission to use this App');
            }
          });
        } else {
          await getCurrentPosition();
          if(!mounted) return;
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => IntroScreen(
                a: widget.analytics,
                o: widget.observer,
              )));
        }
        _getToken();
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
    } catch (e) {
      debugPrint("Exception - splash_screen.dart - init():$e");
    }
  }

  @override
  void initState() {
    super.initState();
    init();
  }
_getToken(){
  try {
    FirebaseMessaging.instance.getToken().then((token) {
      if (token != null) {
        global.appDeviceId = token;
         
      }
    });
  } catch (e) {
    debugPrint("Exception - splash_screen.dart - _getToken(): $e");
  }
 
}
  _getCurrency() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        await apiHelper!.getCurrency().then((result) {
          if (result != null) {
            if (result.status == "1") {
              global.currency = result.recordList;

              setState(() {});
            } else {}
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
    } catch (e) {
      debugPrint("Exception - splash_screen.dart - _getCurrency(): $e");
    }
  }

  _getMapBox() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        await apiHelper!.getMapGateway().then((result) {
          if (result != null) {
            if ('${result.status}' == '1') {
              if('${result.recordList.data.googleMap}'=='1'){
                global.isGoogleMap = true;
                apiHelper!.getGoogleMap().then((valRes){
                  global.mapGBoxModel = valRes.recordList;
                });
              } else if('${result.recordList.data.mapbox}'=='1'){
                global.isGoogleMap = false;
                apiHelper!.getMapBox().then((valRes){
                  global.mapBoxModel = valRes.recordList;
                });
              }
            }
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
    } catch (e) {
      debugPrint("Exception - splash_screen.dart - _getMapBox():$e");
    } finally {
      setState(() {});
    }
  }
}
