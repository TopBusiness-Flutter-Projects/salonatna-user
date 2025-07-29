import 'dart:io';

import 'package:app/models/businessLayer/base_route.dart';
import 'package:app/models/future_app_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class FutureApp extends BaseRoute {
  const FutureApp({super.key, super.a, super.o}) : super(r: 'FutureApp');

  @override
  BaseRouteState<FutureApp> createState() => _FutureAppState();
}

class _FutureAppState extends BaseRouteState<FutureApp> {
  late GlobalKey<ScaffoldState> _scaffoldKey;
  FutureAppModel? futureAppModel;
  bool _isDataLoaded = false;

  _FutureAppState() : super();
  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        child: Scaffold(
            appBar: AppBar(
              title: RichText(
                text: TextSpan(
                    text: AppLocalizations.of(context)!.future_app,
                    style: Theme.of(context).appBarTheme.titleTextStyle,
                    children: [
                      TextSpan(
                          text: AppLocalizations.of(context)!
                              .txt_future_app_will_shown_here,
                          style: Theme.of(context).primaryTextTheme.titleMedium)
                    ]),
              ),
            ),
            body: Stack(
              children: [
                Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                    ),
                    margin: const EdgeInsets.only(top: 0),
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Container(
                      margin: const EdgeInsets.only(
                        left: 10,
                        right: 10,
                      ),
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          _isDataLoaded
                              ? futureAppModel?.data?.apps?.isNotEmpty == true
                                  ? Expanded(
                                      child: ListView.builder(
                                        itemCount: futureAppModel
                                                ?.data?.apps?.length ??
                                            0,
                                        itemBuilder: (context, index) {
                                          final app = futureAppModel
                                              ?.data?.apps?[index];
                                          final url = Platform.isAndroid
                                              ? app?.androidUrl
                                              : app?.iosUrl;

                                          return InkWell(
                                            onTap: () async {
                                              if (url != null &&
                                                  await canLaunchUrl(
                                                      Uri.parse(url))) {
                                                await launchUrl(Uri.parse(url),
                                                    mode: LaunchMode
                                                        .externalApplication);
                                              } else {
                                                print("لا يمكن فتح الرابط");
                                              }
                                            },
                                            child: FutureAppCard(
                                              nameApp: app?.name ?? "",
                                              image: app?.icon ?? "",
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  : Expanded(
                                      child: Center(
                                        child: Lottie.asset(
                                          'assets/json/no task.json',
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    )
                              : _shimmer()
                        ],
                      ),
                    ))
              ],
            )));
  }

  getFutureApps() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        await apiHelper?.getFutureApps().then((result) {
          if (result != null) {
            if (result.status == "1") {
              futureAppModel = result.recordList;
            } else {
              futureAppModel = null;
            }
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
    } catch (e) {
      debugPrint("Exception - future_app_screen.dart - _getFutureApp():$e");
    }
  }

  init() async {
    try {
      await getFutureApps();
      _isDataLoaded = true;
      setState(() {});
    } catch (e) {
      debugPrint("Exception - future_app_screen.dart - init():$e");
    }
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  Widget _shimmer() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: 5,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                height: 85,
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      child: Card(),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0, top: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 30,
                              child: const Card(
                                margin:
                                    EdgeInsets.only(bottom: 5, left: 5, top: 5),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 30,
                              child: const Card(
                                  margin: EdgeInsets.only(
                                      bottom: 5, left: 5, top: 5)),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}

class FutureAppCard extends StatelessWidget {
  final String nameApp;
  final String image;

  const FutureAppCard({
    super.key,
    required this.nameApp,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              image,
              width: 45,
              height: 45,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image, size: 40),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              nameApp,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.black,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
