import 'package:app/models/businessLayer/base_route.dart';
import 'package:app/models/cookies_policy_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class CookiesPolicy extends BaseRoute {
  const CookiesPolicy({super.key, super.a, super.o}) : super(r: 'CookiesPolicy');
  @override
  BaseRouteState<CookiesPolicy> createState() => _CookiesPolicyState();
}

class _CookiesPolicyState extends BaseRouteState<CookiesPolicy> {
  GlobalKey<ScaffoldState>? _scaffoldKey;
  Cookies? _cookiesPolicy;
  bool _isDataLoaded = false;
  _CookiesPolicyState() : super();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: sc(Scaffold(
        appBar: AppBar(
          title: const Text('Cookies Policy'),
        ),
        body: _isDataLoaded
            ? SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Html(
                          data: _cookiesPolicy!.cookiesPolicy,
                          style: {
                            'body': Style(textAlign: TextAlign.justify),
                          },
                        )),
                  ),
                ),
              )
            : const Center(child: CircularProgressIndicator()),
      )),
    );
  }


  @override
  void initState() {
    super.initState();
    _init();
  }

  _getCookiesPolicy() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        await apiHelper!.cookiesPolicy().then((result) {
          if (result != null) {
            if (result.status == "1") {
              _cookiesPolicy = result.data;
              _isDataLoaded = true;
              setState(() {});
            }
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
    } catch (e) {
      debugPrint("Exception - cookies_policy_screen.dart - _getCookiesPolicy():$e");
    }
  }

  _init() async {
    await _getCookiesPolicy();
  }
}
