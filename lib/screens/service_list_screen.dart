import 'package:app/models/businessLayer/base_route.dart';
import 'package:app/models/businessLayer/global.dart' as global;
import 'package:app/models/service_model.dart';
import 'package:app/screens/search_screen.dart';
import 'package:app/screens/service_detail_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shimmer/shimmer.dart';

class ServiceListScreen extends BaseRoute {
  const ServiceListScreen({super.key, super.a, super.o}) : super(r: 'ServiceListScreen');
  @override
  BaseRouteState<ServiceListScreen> createState() => _ServiceListScreenState();
}

class _ServiceListScreenState extends BaseRouteState<ServiceListScreen> {
  GlobalKey<ScaffoldState>? _scaffoldKey;
  List<Service> _serviceList = [];
  bool _isDataLoaded = false;
  bool _isRecordPending = true;
  bool _isMoreDataLoaded = false;
  final ScrollController _scrollController = ScrollController();
  int pageNumber = 0;
  _ServiceListScreenState() : super();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.lbl_services, style: AppBarTheme.of(context).titleTextStyle),
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => SearchScreen(3, a: widget.analytics, o: widget.observer)),
                    );
                  },
                  icon: const Icon(Icons.search))
            ],
          ),
          body: _isDataLoaded
              ? _serviceList.isNotEmpty
                  ? ListView.builder(
                      controller: _scrollController,
                      physics: const ClampingScrollPhysics(),
                      itemCount: _serviceList.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                            padding: const EdgeInsets.only(top: 8, bottom: 8, left: 13, right: 13),
                            child: InkWell(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              overlayColor: WidgetStateProperty.all(Colors.transparent),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => ServiceDetailScreen(
                                            serviceName: _serviceList[index].serviceName,
                                            a: widget.analytics,
                                            o: widget.observer,
                                            serviceImage: _serviceList[index].serviceImage,
                                          )),
                                );
                              },
                              child: Card(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CachedNetworkImage(
                                          imageUrl: global.baseUrlForImage + _serviceList[index].serviceImage!,
                                          imageBuilder: (context, imageProvider) => Container(
                                            height: 85,
                                            width: 125,
                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), image: DecorationImage(fit: BoxFit.cover, image: imageProvider)),
                                          ),
                                          placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                          errorWidget: (context, url, error) => const Icon(Icons.error),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: global.isRTL ? const EdgeInsets.only(right: 18) : const EdgeInsets.only(left: 18),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  '${_serviceList[index].serviceName}',
                                                  style: Theme.of(context).primaryTextTheme.titleSmall,
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Icon(Icons.keyboard_arrow_right),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ));
                      },
                    )
                  : Center(
                      child: Text(
                        AppLocalizations.of(context)!.txt_service_will_shown_here,
                        style: Theme.of(context).primaryTextTheme.titleSmall,
                      ),
                    )
              : _shimmer()),
    );
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  _getServices() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        if (_isRecordPending) {
          setState(() {
            _isMoreDataLoaded = true;
          });

          if (_serviceList.isEmpty) {
            pageNumber = 1;
          } else {
            pageNumber++;
          }
          await apiHelper!.getServices(global.lat, global.lng, pageNumber).then((result) {
            if (result != null) {
              if (result.status == "1") {
                List<Service> tList = result.recordList;

                if (tList.isEmpty) {
                  _isRecordPending = false;
                }

                _serviceList.addAll(tList);
                setState(() {
                  _isMoreDataLoaded = false;
                });
              } else {
                _serviceList = [];
              }
            }
          });
        }
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
    } catch (e) {
      debugPrint("Exception - service_list_screen.dart - _getServices():$e");
    }
  }

  _init() async {
    try {
      await _getServices();
      _scrollController.addListener(() async {
        if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !_isMoreDataLoaded) {
          setState(() {
            _isMoreDataLoaded = true;
          });
          await _getServices();
          setState(() {
            _isMoreDataLoaded = false;
          });
        }
      });
      _isDataLoaded = true;
      setState(() {});
    } catch (e) {
      debugPrint("Exception - service_list_screen.dart - _init():$e");
    }
  }

  Widget _shimmer() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: 8,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: 80,
                        height: 80,
                        child: Card(margin: EdgeInsets.only(top: 5, bottom: 5)),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 220,
                            height: 40,
                            child: const Card(margin: EdgeInsets.only(top: 5, bottom: 5, left: 5)),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 120,
                            height: 40,
                            child: const Card(margin: EdgeInsets.only(top: 5, bottom: 5, left: 5)),
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  )
                ],
              );
            }),
      ),
    );
  }
}
