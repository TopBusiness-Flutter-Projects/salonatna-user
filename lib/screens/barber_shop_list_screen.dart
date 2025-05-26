import 'package:app/models/barber_shop_model.dart';
import 'package:app/models/businessLayer/base_route.dart';
import 'package:app/models/businessLayer/global.dart' as global;
import 'package:app/screens/barber_shop_description_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shimmer/shimmer.dart';

class BarberShopListScreen extends BaseRoute {
  const BarberShopListScreen({super.key, super.a, super.o}) : super(r: 'BarberShopListScreen');
  @override
  BaseRouteState<BarberShopListScreen> createState() => _BarberShopListScreenState();
}

class _BarberShopListScreenState extends BaseRouteState<BarberShopListScreen> {
  GlobalKey<ScaffoldState>? _scaffoldKey;
  List<BarberShop> _barberShopList = [];
  bool _isDataLoaded = false;
  bool _isRecordPending = true;
  bool _isMoreDataLoaded = false;
  final ScrollController _scrollController = ScrollController();
  int pageNumber = 0;
  _BarberShopListScreenState() : super();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.lbl_barber_shop),
        ),
        body: SafeArea(
          child: _isDataLoaded
              ? _barberShopList.isNotEmpty
              ? ListView.builder(
            controller: _scrollController,
            physics: const ClampingScrollPhysics(),
            itemCount: _barberShopList.length,
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
                      MaterialPageRoute(builder: (context) => BarberShopDescriptionScreen(_barberShopList[index].vendorId, a: widget.analytics, o: widget.observer)),
                    );
                  },
                  child: Card(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CachedNetworkImage(
                          imageUrl: global.baseUrlForImage + _barberShopList[index].vendorLogo!,
                          imageBuilder: (context, imageProvider) => Container(
                            height: 85,
                            width: 100,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), image: DecorationImage(fit: BoxFit.cover, image: imageProvider)),
                          ),
                          placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => Container(
                            height: 85,
                            width: 100,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                            child: Center(child: Text(AppLocalizations.of(context)!.txt_no_image_availa)),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            isThreeLine: true,
                            title: Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text(
                                '${_barberShopList[index].vendorName}',
                                style: Theme.of(context).primaryTextTheme.bodyLarge,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on_outlined,
                                      size: 20,
                                    ),
                                    Expanded(
                                      child: Text(
                                        _barberShopList[index].vendorLoc != null && _barberShopList[index].vendorLoc != "" ? '${_barberShopList[index].vendorLoc}' : 'Location not provided',
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context).primaryTextTheme.bodyMedium,
                                      ),
                                    ),
                                  ],
                                ),
                                if (_barberShopList[index].rating != null)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text('${_barberShopList[index].rating}', style: Theme.of(context).primaryTextTheme.bodyLarge),
                                        _barberShopList[index].rating != null
                                            ? RatingBar.builder(
                                          initialRating: _barberShopList[index].rating!,
                                          minRating: 0,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          itemSize: 8,
                                          itemPadding: const EdgeInsets.symmetric(horizontal: 0),
                                          itemBuilder: (context, _) => const Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                          ignoreGestures: true,
                                          updateOnDrag: false,
                                          onRatingUpdate: (rating) {

                                          },
                                        )
                                            : const SizedBox()
                                      ],
                                    ),
                                  )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          )
              : Center(
            child: Text(
              AppLocalizations.of(context)!.txt_near_by_barbershop_list_will_shown_here,
              style: Theme.of(context).primaryTextTheme.titleSmall,
              textAlign: TextAlign.center,
            ),
          )
              : _shimmer(),
        ),
      ),
    );
  }


  @override
  void initState() {
    super.initState();
    _init();
  }

  _getNearByBarberShops() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        if (_isRecordPending) {
          setState(() {
            _isMoreDataLoaded = true;
          });

          if (_barberShopList.isEmpty) {
            pageNumber = 1;
          } else {
            pageNumber++;
          }
          await apiHelper!.getNearByBarberShops(global.lat, global.lng, pageNumber).then((result) {
            if (result != null) {
              if (result.status == "1") {
                List<BarberShop> tList = result.recordList;

                if (tList.isEmpty) {
                  _isRecordPending = false;
                }

                _barberShopList.addAll(tList);
                setState(() {
                  _isMoreDataLoaded = false;
                });
              } else {
                _barberShopList = [];
              }
            }
          });
        }
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
    } catch (e) {
      debugPrint("Exception - barber_shop_list_screen.dart - _getNearByBarberShops():$e");
    }
  }

  _init() async {
    try {
      await _getNearByBarberShops();
      _scrollController.addListener(() async {
        if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !_isMoreDataLoaded) {
          setState(() {
            _isMoreDataLoaded = true;
          });
          await _getNearByBarberShops();
          setState(() {
            _isMoreDataLoaded = false;
          });
        }
      });
      _isDataLoaded = true;
      setState(() {});
    } catch (e) {
      debugPrint("Exception - barber_shop_list_screen.dart - _init():$e");
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
            itemCount: 12,
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
