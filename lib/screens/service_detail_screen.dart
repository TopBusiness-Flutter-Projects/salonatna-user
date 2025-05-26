import 'package:app/models/barber_shop_model.dart';
import 'package:app/models/businessLayer/base_route.dart';
import 'package:app/models/businessLayer/global.dart' as global;
import 'package:app/screens/barber_shop_description_screen.dart';
import 'package:app/screens/book_appointment_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shimmer/shimmer.dart';

class ServiceDetailScreen extends BaseRoute {
  final String? serviceName;
  final String? serviceImage;
  const ServiceDetailScreen({super.key, super.a, super.o, this.serviceName, this.serviceImage}) : super(r: 'ServiceDetailScreen');
  @override
  BaseRouteState<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends BaseRouteState<ServiceDetailScreen> {
  GlobalKey<ScaffoldState>? _scaffoldKey;
  bool _isDataLoaded = false;
  int? selectedVendorId;
  List<BarberShop>? _barberShopList = [];
  _ServiceDetailScreenState() : super();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: Scaffold(
          body: SafeArea(
            top: false,
            child: _isDataLoaded
                ? _barberShopList!.isNotEmpty
                ? Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
              CachedNetworkImage(
                imageUrl: global.baseUrlForImage + widget.serviceImage!,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                  ),
                  height: MediaQuery.of(context).size.height * 0.24,
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.black, Colors.transparent],
                            begin: Alignment.bottomCenter,
                            end: Alignment.center,
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: global.isRTL ? EdgeInsets.only(right: 8, top: MediaQuery.viewPaddingOf(context).top) : EdgeInsets.only(left: 8, top: MediaQuery.viewPaddingOf(context).top),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: SizedBox(
                                    height: 30,
                                    width: 30,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.black26,
                                      child: Center(
                                        child: Icon(
                                          global.isRTL ? MdiIcons.chevronRight : MdiIcons.chevronLeft,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          ListTile(
                            title: Text(
                              '${widget.serviceName}',
                              style: Theme.of(context).primaryTextTheme.displayLarge,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => Container(
                  decoration: const BoxDecoration(),
                  height: MediaQuery.of(context).size.height * 0.24,
                  width: MediaQuery.of(context).size.width,
                  child: Text(AppLocalizations.of(context)!.lbl_no_image),
                ),
              ),
              Expanded(
                child: Padding(
                    padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _barberShopList!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            shape: selectedVendorId != null && selectedVendorId == _barberShopList![index].vendorId ? RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0), side: BorderSide(color: Theme.of(context).primaryColor, width: 2)) : null,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          if (selectedVendorId == _barberShopList![index].vendorId) {
                                            selectedVendorId = null;
                                          } else {
                                            selectedVendorId = _barberShopList![index].vendorId;
                                          }

                                          setState(() {});
                                        },
                                        child: CachedNetworkImage(
                                          imageUrl: global.baseUrlForImage + _barberShopList![index].vendorLogo!,
                                          imageBuilder: (context, imageProvider) => Container(
                                            height: 80,
                                            width: 90,
                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), image: DecorationImage(fit: BoxFit.cover, image: imageProvider)),
                                            child: selectedVendorId != null && selectedVendorId == _barberShopList![index].vendorId
                                                ? Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.white.withOpacity(0.6),
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                    child: const Icon(
                                                      Icons.check,
                                                      color: Color(0xFF171D2C),
                                                      size: 45,
                                                    ),
                                                  )
                                                : null,
                                          ),
                                          placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                          errorWidget: (context, url, error) => const Icon(Icons.error),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(builder: (context) => BarberShopDescriptionScreen(_barberShopList![index].vendorId, a: widget.analytics, o: widget.observer)),
                                          );
                                        },
                                        child: Padding(
                                          padding: global.isRTL ? const EdgeInsets.only(right: 5) : const EdgeInsets.only(left: 5),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(left: 6),
                                                child: Text(
                                                  '${_barberShopList![index].vendorName}',
                                                  style: Theme.of(context).primaryTextTheme.titleSmall,
                                                ),
                                              ),
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const Icon(
                                                    Icons.location_on_outlined,
                                                    size: 20,
                                                  ),
                                                  SizedBox(
                                                    width: MediaQuery.of(context).size.width - 150,
                                                    child: Text(
                                                      '${_barberShopList![index].vendorLoc}',
                                                      style: Theme.of(context).primaryTextTheme.titleMedium,
                                                      overflow: TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        })),
              )
            ])
                : Center(
              child: Text(
                AppLocalizations.of(context)!.txt_nearby_shopw_will_shown_here,
                style: Theme.of(context).primaryTextTheme.titleSmall,
              ),
            )
                : _shimmer(),
          ),
          bottomNavigationBar: _barberShopList!.isNotEmpty && selectedVendorId != null
              ? SafeArea(
                child: Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => BookAppointmentScreen(selectedVendorId, a: widget.analytics, o: widget.observer)),
                              );
                            },
                            child: Text(AppLocalizations.of(context)!.lbl_book_now,style: TextStyle(color: Colors.white))),
                      ],
                    ),
                  ),
              )
              : null),
    );
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  _getSalonListForServices() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        await apiHelper!.getSalonListForServices(global.lat, global.lng, widget.serviceName).then((result) {
          if (result != null) {
            if (result.status == "1") {
              _barberShopList = result.recordList;
            } else {
              showSnackBar(key: _scaffoldKey, snackBarMessage: result.message.toString());
            }
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
    } catch (e) {
      debugPrint("Exception - service_detail_screen.dart - _getSalonListForServices():$e");
    }
  }

  _init() async {
    try {
      await _getSalonListForServices();
      _isDataLoaded = true;
      setState(() {});
    } catch (e) {
      debugPrint("Exception - service_detail_screen.dart - _init():$e");
    }
  }

  Widget _shimmer() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 140,
              child: const Card(margin: EdgeInsets.only(top: 5, bottom: 15)),
            ),
            ListView.builder(
                shrinkWrap: true,
                itemCount: 5,
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
          ],
        ),
      ),
    );
  }
}
