import 'package:app/models/businessLayer/base_route.dart';
import 'package:app/models/privacy_policy_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class PrivacyAndPolicy extends BaseRoute {
  const PrivacyAndPolicy({super.key, super.a, super.o}) : super(r: 'PrivacyAndPolicy');
  @override
  BaseRouteState<PrivacyAndPolicy> createState() => _PrivacyAndPolicyState();
}

class _PrivacyAndPolicyState extends BaseRouteState<PrivacyAndPolicy> {
  GlobalKey<ScaffoldState>? _scaffoldKey;
  PrivacyPolicy? _privacyAndPolicy;
  bool _isDataLoaded = false;
  _PrivacyAndPolicyState() : super();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: sc(Scaffold(
        appBar: AppBar(
          title: const Text('Privacy And Policy'),
        ),
        body: _isDataLoaded
            ? SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Html(
                          data: _privacyAndPolicy!.privacyPolicy,
                          style: {
                            'body': Style(textAlign: TextAlign.justify),
                          },
                        )),
                  ),
                ),
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      )),
    );
  }


  @override
  void initState() {
    super.initState();
    _init();
  }

  _getPrivacyPolicy() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        await apiHelper!.privacyPolicy().then((result) {
          if (result != null) {
            if (result.status == "1") {
              _privacyAndPolicy = result.data;
              _isDataLoaded = true;
              setState(() {});
            }
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
    } catch (e) {
      debugPrint("Exception - privacy_and_policy.dart - _getPrivacyPolicy():$e");
    }
  }

  _init() async {
    await _getPrivacyPolicy();
  }
}
