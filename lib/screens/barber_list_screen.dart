import 'package:app/models/businessLayer/base_route.dart';
import 'package:app/models/businessLayer/global.dart' as global;
import 'package:app/models/popular_barbers_model.dart';
import 'package:app/screens/barber_detail_screen.dart';
import 'package:app/screens/search_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class BarberListScreen extends BaseRoute {
  const BarberListScreen({super.key, super.a, super.o}) : super(r: 'BarberListScreen');
  @override
  BaseRouteState<BarberListScreen> createState() => _BarberListScreenState();
}

class _BarberListScreenState extends BaseRouteState<BarberListScreen> {
  GlobalKey<ScaffoldState>? _scaffoldKey;
  List<PopularBarbers> _popularBarbersList = [];
  bool _isDataLoaded = false;
  bool _isRecordPending = true;
  bool _isMoreDataLoaded = false;
  final ScrollController _scrollController = ScrollController();
  int pageNumber = 0;

  _BarberListScreenState() : super();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: Scaffold(
          appBar: AppBar(
            title: Text('Popular Barbers', style: AppBarTheme.of(context).titleTextStyle),
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => SearchScreen(1, a: widget.analytics, o: widget.observer)),
                    );
                  },
                  icon: const Icon(Icons.search))
            ],
          ),
          body: _isDataLoaded
              ? _popularBarbersList.isNotEmpty
                  ? ListView.builder(
                      controller: _scrollController,
                      itemCount: _popularBarbersList.length,
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
                                  MaterialPageRoute(builder: (context) => BarberDetailScreen(_popularBarbersList[index].staffId, a: widget.analytics, o: widget.observer)),
                                );
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: global.isRTL
                                      ? const BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          bottomLeft: Radius.circular(10),
                                          topRight: Radius.circular(30.0),
                                          bottomRight: Radius.circular(30.0),
                                        )
                                      : const BorderRadius.only(
                                          topLeft: Radius.circular(30),
                                          bottomLeft: Radius.circular(30),
                                          topRight: Radius.circular(10.0),
                                          bottomRight: Radius.circular(10.0),
                                        ),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CachedNetworkImage(
                                          imageUrl: global.baseUrlForImage + _popularBarbersList[index].staffImage!,
                                          imageBuilder: (context, imageProvider) => CircleAvatar(radius: 30, backgroundImage: imageProvider),
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
                                                  '${_popularBarbersList[index].staffName}',
                                                  style: Theme.of(context).primaryTextTheme.titleSmall,
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  '${_popularBarbersList[index].vendorName}',
                                                  style: Theme.of(context).primaryTextTheme.titleMedium,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const Icon(Icons.keyboard_arrow_right)
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
                        "POPULAR BARBER'S WILL BE SHOWN HERE",
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

  _getPopularBarbers() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        if (_isRecordPending) {
          setState(() {
            _isMoreDataLoaded = true;
          });

          if (_popularBarbersList.isEmpty) {
            pageNumber = 1;
          } else {
            pageNumber++;
          }
          await apiHelper!.getPopularBarbersList(global.lat, global.lng, pageNumber, '').then((result) {
            if (result != null) {
              if (result.status == "1") {
                List<PopularBarbers> tList = result.recordList;

                if (tList.isEmpty) {
                  _isRecordPending = false;
                }

                _popularBarbersList.addAll(tList);
                setState(() {
                  _isMoreDataLoaded = false;
                });
              } else {
                _popularBarbersList = [];
              }
            }
          });
        }
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
    } catch (e) {
      debugPrint("Exception - barber_list_screen.dart - _getServices():$e");
    }
  }

  _init() async {
    try {
      await _getPopularBarbers();
      _scrollController.addListener(() async {
        if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !_isMoreDataLoaded) {
          setState(() {
            _isMoreDataLoaded = true;
          });
          await _getPopularBarbers();
          setState(() {
            _isMoreDataLoaded = false;
          });
        }
      });
      _isDataLoaded = true;
      setState(() {});
    } catch (e) {
      debugPrint("Exception - barber_list_screen.dart - _initFinal():$e");
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
                      const CircleAvatar(
                        radius: 40,
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
