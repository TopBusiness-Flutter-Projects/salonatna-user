import 'package:app/models/businessLayer/base_route.dart';
import 'package:app/models/businessLayer/global.dart' as global;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shimmer/shimmer.dart';

class ReferAndEarnScreen extends BaseRoute {
  const ReferAndEarnScreen({super.key, super.a, super.o}) : super(r: 'ReferAndEarnScreen');

  @override
  BaseRouteState<ReferAndEarnScreen> createState() => _ReferAndEarnScreenState();
}

class _ReferAndEarnScreenState extends BaseRouteState<ReferAndEarnScreen> {
  GlobalKey<ScaffoldState>? _scaffoldKey;
  bool _isDataLoaded = false;
  String? referMessage;

  _ReferAndEarnScreenState() : super();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.lbl_invite_earn),
          ),
          body: _isDataLoaded
              ? referMessage != null
                  ? ScrollConfiguration(
                      behavior: const ScrollBehavior(),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: MediaQuery.of(context).size.height * 0.18,
                              ),
                              Text(
                                referMessage!,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).primaryTextTheme.titleSmall,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                AppLocalizations.of(context)!.txt_share_your_code_below_and_ask_them_to_enter_it,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).primaryTextTheme.titleMedium,
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Card(
                                child: InkWell(
                                  customBorder: Theme.of(context).cardTheme.shape,
                                  onTap: () {
                                    Clipboard.setData(ClipboardData(text: "${global.user!.referralCode}"));
                                  },
                                  child: Container(
                                    width: 180,
                                    margin: const EdgeInsets.all(10),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "${global.user!.referralCode}",
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context).primaryTextTheme.titleSmall!.copyWith(color: Theme.of(context).primaryColor),
                                        ),
                                        Text(
                                          AppLocalizations.of(context)!.txt_top_to_copy,
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context).primaryTextTheme.bodyMedium,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  : Center(
                      child: Text(
                      AppLocalizations.of(context)!.txt_nothing_is_yet_to_see_here,
                      style: Theme.of(context).primaryTextTheme.titleSmall,
                    ))
              : _shimmer(),
          bottomNavigationBar: global.user!.referralCode != null && _isDataLoaded
              ? SafeArea(
                child: Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              br.inviteFriendShareMessage();
                            },
                            child: Text(AppLocalizations.of(context)!.btn_invite_friends,style: TextStyle(color: Colors.white))),
                      ],
                    ),
                  ),
              )
              : null,
        ),
    );
  }


  @override
  void initState() {
    super.initState();

    _init();
  }

  _getReferandEarn() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        await apiHelper!.getReferandEarn().then((result) {
          if (result != null) {
            if (result.status == "1") {
              referMessage = result.data;
            }
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
    } catch (e) {
      debugPrint("Exception - refer_and_earn_screen.dart - getReferandEarn():$e");
    }
  }

  _init() async {
    try {
      await _getReferandEarn();
      _isDataLoaded = true;
      setState(() {});
    } catch (e) {
      debugPrint("Exception - refer_and_earn_screen.dart - _init():$e");
    }
  }

  Widget _shimmer() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.18,
              ),
              SizedBox(
                height: 20,
                width: MediaQuery.of(context).size.width,
                child: const Card(),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 20,
                width: MediaQuery.of(context).size.width - 100,
                child: const Card(),
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                height: 20,
                width: MediaQuery.of(context).size.width,
                child: const Card(),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 20,
                width: MediaQuery.of(context).size.width - 150,
                child: const Card(),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 20,
                width: MediaQuery.of(context).size.width - 200,
                child: const Card(),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: 180,
                margin: const EdgeInsets.all(10),
                height: 50,
                child: const Card(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
