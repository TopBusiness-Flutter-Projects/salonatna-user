import 'package:app/models/businessLayer/base_route.dart';
import 'package:app/models/terms_and_condition_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_html/flutter_html.dart';

class TermsOfServices extends BaseRoute {
  const TermsOfServices({super.key, super.a, super.o}) : super(r: 'TermsOfServices');

  @override
  BaseRouteState<TermsOfServices> createState() => _TermsOfServicesState();
}

class _TermsOfServicesState extends BaseRouteState<TermsOfServices> {
  GlobalKey<ScaffoldState>? _scaffoldKey;
  TermsAndCondition? _termsAndCondition;
  bool _isDataLoaded = false;

  _TermsOfServicesState() : super();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.lbl_terms_of_service),
        ),
        body: _isDataLoaded
            ? SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Html(
                          data: _termsAndCondition!.termcondition,
                          style: {
                            'body': Style(textAlign: TextAlign.justify),
                          },
                        )),
                  ),
                ),
              )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }


  @override
  void initState() {
    super.initState();
    _init();
  }

  _getTermsAndCondition() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        await apiHelper!.getTermsAndCondition().then((result) {
          if (result != null) {
            if (result.status == "1") {
              _termsAndCondition = result.data;
              _isDataLoaded = true;
              setState(() {});
            }
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
    } catch (e) {
      debugPrint("Exception - terms_of_services_screen.dart - _getTermsAndCondition():$e");
    }
  }

  _init() async {
    try {
      await _getTermsAndCondition();
    } catch (e) {
      debugPrint("Exception - terms_of_services_screen.dart - _init():$e");
    }
  }
}
