import 'package:app/dialogs/open_image_dialog.dart';
import 'package:app/models/barber_shop_desc_model.dart';
import 'package:app/models/businessLayer/base_route.dart';
import 'package:app/models/businessLayer/global.dart' as global;
import 'package:app/screens/barber_detail_screen.dart';
import 'package:app/screens/book_appointment_screen.dart';
import 'package:app/screens/product_detail_screen.dart';
import 'package:app/screens/service_detail_screen.dart';
import 'package:app/screens/sign_in_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher_string.dart';

class BarberShopDescriptionScreen extends BaseRoute {
  final int? vendorId;

  const BarberShopDescriptionScreen(this.vendorId, {super.key, super.a, super.o}) : super(r: 'BarberShopDescriptionScreen');

  @override
  BaseRouteState<BarberShopDescriptionScreen> createState() => _BarberShopDescriptionScreenState();
}

class _BarberShopDescriptionScreenState extends BaseRouteState<BarberShopDescriptionScreen> {
  GlobalKey<ScaffoldState>? _scaffoldKey;
  BarberShopDesc? _barberShopDesc;
  TabController? _tabController;
  int _currentIndex = 0;
  bool _isDataLoaded = false;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
        child:
          (_barberShopDesc != null)
              ? DefaultTabController(
                  length: 5,
                  initialIndex: _currentIndex,
                  child: Scaffold(
                      key: _scaffoldKey,
                      body: SafeArea(
                        top: false,
                        child: _isDataLoaded
                            ? _barberShopDesc != null
                            ? Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CachedNetworkImage(
                              imageUrl: global.baseUrlForImage +
                                  _barberShopDesc!.vendorLogo!,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    height:
                                    MediaQuery.sizeOf(context).height *
                                        0.24,
                                    width:
                                    MediaQuery.sizeOf(context).width,
                                    child: Stack(
                                      alignment: Alignment.bottomCenter,
                                      children: [
                                        Container(
                                          height: MediaQuery.of(context)
                                              .size
                                              .height *
                                              0.24,
                                          decoration: const BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Colors.black,
                                                Colors.transparent
                                              ],
                                              begin: Alignment.bottomCenter,
                                              end: Alignment.center,
                                            ),
                                          ),
                                        ),
                                        global.isRTL
                                            ? Positioned(
                                          right: 8,
                                          top: MediaQuery.viewPaddingOf(context).top + 16,
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.of(context)
                                                  .pop();
                                            },
                                            child: SizedBox(
                                              height: 36,
                                              width: 36,
                                              child: CircleAvatar(
                                                backgroundColor:
                                                Colors.black26,
                                                child: Center(
                                                  child: Icon(
                                                    MdiIcons
                                                        .chevronRight,
                                                    color:
                                                    Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                            : Positioned(
                                          left: 8,
                                          top: MediaQuery.viewPaddingOf(context).top + 16,
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.of(context)
                                                  .pop();
                                            },
                                            child: SizedBox(
                                              height: 30,
                                              width: 30,
                                              child: CircleAvatar(
                                                backgroundColor:
                                                Colors.black26,
                                                child: Center(
                                                  child: Icon(
                                                    MdiIcons
                                                        .chevronLeft,
                                                    color:
                                                    Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        ListTile(
                                          title: Text(
                                            "${_barberShopDesc!.salonName}",
                                            style: Theme.of(context)
                                                .primaryTextTheme
                                                .displayLarge,
                                          ),
                                          subtitle: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: [
                                              const Icon(
                                                Icons.location_on_outlined,
                                                size: 15,
                                                color: Colors.white70,
                                              ),
                                              SizedBox(
                                                width: 180,
                                                child: Text(
                                                  "${_barberShopDesc!.vendorLoc}",
                                                  overflow:
                                                  TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  style: Theme.of(context)
                                                      .primaryTextTheme
                                                      .displayMedium,
                                                ),
                                              ),
                                            ],
                                          ),
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                _barberShopDesc!.rating !=
                                                    null
                                                    ? "${_barberShopDesc!.rating}"
                                                    : AppLocalizations.of(
                                                    context)!
                                                    .lbl_no_rating,
                                                style: Theme.of(context)
                                                    .primaryTextTheme
                                                    .displayMedium,
                                              ),
                                              _barberShopDesc!.rating !=
                                                  null
                                                  ? RatingBar.builder(
                                                initialRating:
                                                _barberShopDesc!
                                                    .rating!,
                                                minRating: 0,
                                                direction:
                                                Axis.horizontal,
                                                allowHalfRating: true,
                                                itemCount: 5,
                                                itemSize: 15,
                                                itemPadding: const EdgeInsets
                                                    .symmetric(
                                                    horizontal:
                                                    1.0),
                                                itemBuilder:
                                                    (context, _) =>
                                                    const Icon(
                                                      Icons.star,
                                                      color: Colors.amber,
                                                    ),
                                                ignoreGestures: true,
                                                updateOnDrag: false,
                                                onRatingUpdate:
                                                    (rating) {},
                                              )
                                                  : const SizedBox()
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                              placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) =>
                                  Container(
                                    height:
                                    MediaQuery.of(context).size.height *
                                        0.24,
                                    width:
                                    MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(10),
                                        image: const DecorationImage(
                                            fit: BoxFit.cover,
                                            image: AssetImage(
                                              'assets/s1.jpg',
                                            ))),
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceBetween,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: [
                                            BackButton(
                                              color: Colors.white,
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        ),
                                        ListTile(
                                          title: Text(
                                            "${_barberShopDesc!.salonName}",
                                            style: Theme.of(context)
                                                .primaryTextTheme
                                                .displayLarge,
                                          ),
                                          subtitle: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: [
                                              const Icon(
                                                Icons.location_on_outlined,
                                                size: 15,
                                                color: Colors.white70,
                                              ),
                                              SizedBox(
                                                width: 150,
                                                child: Text(
                                                  "${_barberShopDesc!.vendorLoc}",
                                                  overflow:
                                                  TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  style: Theme.of(context)
                                                      .primaryTextTheme
                                                      .displayMedium,
                                                ),
                                              ),
                                            ],
                                          ),
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                _barberShopDesc!.rating !=
                                                    null
                                                    ? "${_barberShopDesc!.rating}"
                                                    : AppLocalizations.of(
                                                    context)!
                                                    .lbl_no_rating,
                                                style: Theme.of(context)
                                                    .primaryTextTheme
                                                    .displayMedium,
                                              ),
                                              _barberShopDesc!.rating !=
                                                  null
                                                  ? RatingBar.builder(
                                                initialRating:
                                                _barberShopDesc!
                                                    .rating!,
                                                minRating: 0,
                                                direction:
                                                Axis.horizontal,
                                                allowHalfRating: true,
                                                itemCount: 5,
                                                itemSize: 15,
                                                itemPadding: const EdgeInsets
                                                    .symmetric(
                                                    horizontal:
                                                    1.0),
                                                itemBuilder:
                                                    (context, _) =>
                                                    const Icon(
                                                      Icons.star,
                                                      color: Colors.amber,
                                                    ),
                                                ignoreGestures: true,
                                                updateOnDrag: false,
                                                onRatingUpdate:
                                                    (rating) {},
                                              )
                                                  : const SizedBox()
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                            ),
                            Container(
                              color: Theme.of(context)
                                  .bottomNavigationBarTheme
                                  .backgroundColor,
                              height: 35,
                              alignment: Alignment.center,
                              child: TabBar(
                                indicatorColor: const Color(0xFFFA692C),
                                labelColor: const Color(0xFFFA692C),
                                unselectedLabelColor: Colors.white,
                                controller: _tabController,
                                indicatorWeight: 0.1,
                                overlayColor: WidgetStateProperty.all(
                                    Colors.transparent),
                                tabs: [
                                  Text(AppLocalizations.of(context)!
                                      .lbl_about),
                                  Text(AppLocalizations.of(context)!
                                      .lbl_services),
                                  Text(AppLocalizations.of(context)!
                                      .lbl_barbers),
                                  Text(AppLocalizations.of(context)!
                                      .lbl_Review),
                                  Text(AppLocalizations.of(context)!
                                      .lbl_gallery),
                                ],
                                onTap: (index) {
                                  _currentIndex = index;
                                  setState(() {});
                                },
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 15),
                                child: TabBarView(
                                    controller: _tabController,
                                    children: [
                                      _aboutWidget(),
                                      _serviceWidget(),
                                      _barberWidget(),
                                      _reviewWidget(),
                                      _galleryWidget()
                                    ]),
                              ),
                            )
                          ],
                        )
                            : const Center(
                          child:
                          Text("BarberDescription not available"),
                        )
                            : _shimmer(),
                      ),
                      bottomNavigationBar: _isDataLoaded &&
                              (_currentIndex == 0 || _currentIndex == 1) &&
                              _barberShopDesc!.services.isNotEmpty
                          ? SafeArea(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                      onPressed: () {
                                        global.user?.id == null
                                            ? Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        SignInScreen(
                                                          a: widget.analytics,
                                                          o: widget.observer,
                                                        )),
                                              )
                                            : Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        BookAppointmentScreen(
                                                          widget.vendorId,
                                                          a: widget.analytics,
                                                          o: widget.observer,
                                                        )),
                                              );
                                      },
                                      child: Text(_currentIndex == 0
                                          ? AppLocalizations.of(context)!
                                              .lbl_book_appointment
                                          : AppLocalizations.of(context)!
                                              .lbl_book_now,
                                              style: TextStyle(color: Colors.white)
                                              )),
                                ],
                              ),
                            )
                          : null))
              : const Scaffold(
                  body: Center(child:
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 8),
                        Text('Loading...')
                      ],
                    )
                  ),
                ),
        );
  }

  _BarberShopDescriptionScreenState() : super();

  dialogToOpenImage({int? index}) {
    try {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return OpenImageDialog(
              a: widget.analytics,
              o: widget.observer,
              index: index,
              barberShopDesc: _barberShopDesc,
            );
          });
    } catch (e) {
      debugPrint("Exception - base.dart - dialogToOpenImage() $e");
    }
  }

  @override
  void dispose() {
    _tabController!.removeListener(_tabControllerListener);
    _tabController!.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: _currentIndex, length: 5, vsync: this);
    _tabController!.addListener(_tabControllerListener);
    _init();
  }

  Widget _aboutWidget() {
    try {
      return SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ListTile(
              title: Text(AppLocalizations.of(context)!.lbl_description, style: Theme.of(context).primaryTextTheme.titleSmall),
              subtitle: Text(
                "${_barberShopDesc!.description}",
                style: Theme.of(context).primaryTextTheme.titleMedium,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 15, right: 15),
              decoration: BoxDecoration(border: Border.all(width: 1), borderRadius: const BorderRadius.all(Radius.circular(5))),
              padding: const EdgeInsets.only(top: 10.0),
              child: ListTile(
                title: Row(
                  children: [
                    const Expanded(
                        child: Divider(
                      color: Colors.black,
                    )),
                    Padding(
                      padding: const EdgeInsets.only(right: 10, left: 10),
                      child: Text(AppLocalizations.of(context)!.lbl_opening_hours, textAlign: TextAlign.center, style: Theme.of(context).primaryTextTheme.titleSmall),
                    ),
                    const Expanded(
                        child: Divider(
                      color: Colors.black,
                    ))
                  ],
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _weekTimeSlotWidget(),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: ListTile(
                title: Text(AppLocalizations.of(context)!.lbl_contact_saloon, style: Theme.of(context).primaryTextTheme.titleSmall),
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(onPressed: _makePhoneCall, child: const Text("Call", style: TextStyle(color: Colors.white))),
                  ElevatedButton(onPressed: _openWhatsApp, child: const Text("WhatsApp", style: TextStyle(color: Colors.white)))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: ListTile(
                title: Text(AppLocalizations.of(context)!.lbl_products, style: Theme.of(context).primaryTextTheme.titleSmall),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: SizedBox(height: 95, child: Align(alignment: global.isRTL ? Alignment.centerRight : Alignment.centerLeft, child: _products())),
            ),
            ListTile(
              title: Text(AppLocalizations.of(context)!.txt_similar_barbershop_nearby, style: Theme.of(context).primaryTextTheme.titleSmall),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0, left: 10),
              child: SizedBox(height: 150, child: Align(alignment: global.isRTL ? Alignment.centerRight : Alignment.centerLeft, child: _similarBarberShop())),
            ),
            ListTile(
              title: Text(AppLocalizations.of(context)!.lbl_barbers, style: Theme.of(context).primaryTextTheme.titleSmall),
              trailing: InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  overlayColor: WidgetStateProperty.all(Colors.transparent),
                  onTap: () {
                    _tabController!.animateTo(2);
                  },
                  child: Text(AppLocalizations.of(context)!.lbl_view_all, style: Theme.of(context).primaryTextTheme.headlineSmall)),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: SizedBox(height: 110, child: Align(alignment: global.isRTL ? Alignment.centerRight : Alignment.centerLeft, child: _popularBarbers())),
            ),
            ListTile(
              title: Text(AppLocalizations.of(context)!.lbl_gallery, style: Theme.of(context).primaryTextTheme.titleSmall),
              trailing: InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  overlayColor: WidgetStateProperty.all(Colors.transparent),
                  onTap: () {
                    _tabController!.animateTo(4);
                  },
                  child: Text(AppLocalizations.of(context)!.lbl_view_all, style: Theme.of(context).primaryTextTheme.headlineSmall)),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: SizedBox(height: 100, child: Align(alignment: global.isRTL ? Alignment.centerRight : Alignment.centerLeft, child: _gallery())),
            ),
            ListTile(
              title: Text(AppLocalizations.of(context)!.lbl_Reviews, style: Theme.of(context).primaryTextTheme.titleSmall),
              trailing: InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  overlayColor: WidgetStateProperty.all(Colors.transparent),
                  onTap: () {
                    _tabController!.animateTo(3);
                  },
                  child: Text(AppLocalizations.of(context)!.lbl_view_all, style: Theme.of(context).primaryTextTheme.headlineSmall)),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0, left: 10),
              child: SizedBox(height: 130, child: Align(alignment: global.isRTL ? Alignment.centerRight : Alignment.centerLeft, child: _review())),
            ),
          ],
        ),
      );
    } catch (e) {
      debugPrint("Exception - barber_shop_description_screen.dart - _aboutWidget(): $e");

      return const SizedBox();
    }
  }

  Widget _barberWidget() {
    try {
      return _barberShopDesc!.barber.isNotEmpty
          ? ListView.builder(
              physics: const ClampingScrollPhysics(),
              itemCount: _barberShopDesc!.barber.length,
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
                        MaterialPageRoute(builder: (context) => BarberDetailScreen(_barberShopDesc!.barber[index].staffId, a: widget.analytics, o: widget.observer)),
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
                                imageUrl: global.baseUrlForImage + _barberShopDesc!.barber[index].staffImage!,
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
                                        '${_barberShopDesc!.barber[index].staffName}',
                                        style: Theme.of(context).primaryTextTheme.titleSmall,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        AppLocalizations.of(context)!.txt_specialist_in_hair_style,
                                        style: Theme.of(context).primaryTextTheme.titleMedium,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
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
                AppLocalizations.of(context)!.txt_nothing_is_yet_to_see_here,
                style: Theme.of(context).primaryTextTheme.titleMedium,
              ),
            );
    } catch (e) {
      debugPrint("Exception - barber_shop_description_screen.dart - _barberWidget() : $e");
      return const SizedBox();
    }
  }

  Widget _gallery() {
    return _barberShopDesc!.gallery.isNotEmpty
        ? ListView.builder(
            itemCount: _barberShopDesc!.gallery.length,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  dialogToOpenImage(index: index);
                },
                child: Padding(
                    padding: const EdgeInsets.only(left: 6.0, right: 6),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CachedNetworkImage(
                          imageUrl: global.baseUrlForImage + _barberShopDesc!.gallery[index].image!,
                          imageBuilder: (context, imageProvider) => Container(
                            width: 90,
                            height: 70,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), image: DecorationImage(fit: BoxFit.cover, image: imageProvider)),
                          ),
                          placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                        ),
                      ],
                    )),
              );
            })
        : Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                AppLocalizations.of(context)!.txt_nothing_is_yet_to_see_here,
                style: Theme.of(context).primaryTextTheme.titleMedium,
              ),
            ),
          );
  }

  Widget _galleryWidget() {
    try {
      return _barberShopDesc!.gallery.isNotEmpty
          ? GridView.count(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 1, bottom: 1),
              crossAxisCount: 3,
              children: List.generate(
                _barberShopDesc!.gallery.length,
                (index) => GestureDetector(
                  onTap: () {
                    dialogToOpenImage(index: index);
                  },
                  child: CachedNetworkImage(
                    imageUrl: global.baseUrlForImage + _barberShopDesc!.gallery[index].image!,
                    imageBuilder: (context, imageProvider) => Container(
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), image: DecorationImage(fit: BoxFit.cover, image: imageProvider)),
                    ),
                    placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => Container(
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(width: 1, color: Theme.of(context).primaryColor)),
                    ),
                  ),
                ),
              ),
            )
          : Center(
              child: Text(
                AppLocalizations.of(context)!.txt_nothing_is_yet_to_see_here,
                style: Theme.of(context).primaryTextTheme.titleMedium,
              ),
            );
    } catch (e) {
      debugPrint("Exception - barber_shop_description_screen.dart - _galleryWidget() : $e");
      return const SizedBox();
    }
  }

  _getBarberShopDescription() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        await apiHelper!.getBarberShopDescription(widget.vendorId, global.lat, global.lng).then((result) {

          if (result != null) {
            if (result.status == "1") {
              _barberShopDesc = result.recordList;
            } else {
              showSnackBar(key: _scaffoldKey, snackBarMessage: '${result.message}');
            }
          } else {
            _barberShopDesc = null;
            setState(() {});
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
    } catch (e) {
      debugPrint("Exception - barber_shop_description_screen.dart - _getBarberShopDescription():$e");
    }
  }

  _init() async {
    try {
      await _getBarberShopDescription();

      _isDataLoaded = true;

      setState(() {});
    } catch (e) {
      debugPrint("Exception - barber_shop_description_screen.dart - _init():$e");
    }
  }

  Widget _popularBarbers() {
    return _barberShopDesc!.barber.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.only(left: 7, right: 7),
            child: ListView.builder(
                itemCount: _barberShopDesc!.barber.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    overlayColor: WidgetStateProperty.all(Colors.transparent),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => BarberDetailScreen(_barberShopDesc!.barber[index].staffId, a: widget.analytics, o: widget.observer)),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      child: SizedBox(
                        width: 80,
                        height: 120,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CachedNetworkImage(
                              imageUrl: global.baseUrlForImage + _barberShopDesc!.barber[index].staffImage!,
                              imageBuilder: (context, imageProvider) => CircleAvatar(radius: 35, backgroundImage: imageProvider),
                              placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) => const CircleAvatar(
                                radius: 35,
                                child: Icon(Icons.person),
                              ),
                            ),
                            SizedBox(
                              height: 40,
                              child: Text(
                                _barberShopDesc!.barber[index].staffName!,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).primaryTextTheme.bodyLarge,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          )
        : Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                AppLocalizations.of(context)!.txt_nothing_is_yet_to_see_here,
                style: Theme.of(context).primaryTextTheme.titleMedium,
              ),
            ),
          );
  }

  Widget _products() {
    return _barberShopDesc!.products.isNotEmpty
        ? ListView.builder(
            itemCount: _barberShopDesc!.products.length,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => ProductDetailScreen(
                              _barberShopDesc!.products[index].id,
                              a: widget.analytics,
                              o: widget.observer,
                              isShowGoCartBtn: _barberShopDesc!.products[index].cartQty != null && _barberShopDesc!.products[index].cartQty! > 0 ? true : false,
                            )),
                  );
                },
                child: Padding(
                    padding: const EdgeInsets.only(left: 6.0, right: 6),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CachedNetworkImage(
                          imageUrl: global.baseUrlForImage + _barberShopDesc!.products[index].productImage!,
                          imageBuilder: (context, imageProvider) => Container(
                            width: 90,
                            height: 70,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), image: DecorationImage(fit: BoxFit.cover, image: imageProvider)),
                          ),
                          placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                        ),
                        SizedBox(
                            width: 80,
                            child: Text(
                              '${_barberShopDesc!.products[index].productName}',
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).primaryTextTheme.bodyMedium,
                            )),
                      ],
                    )),
              );
            })
        : Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                AppLocalizations.of(context)!.txt_nothing_is_yet_to_see_here,
                style: Theme.of(context).primaryTextTheme.titleMedium,
              ),
            ),
          );
  }

  Widget _review() {
    return _barberShopDesc!.review.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.only(left: 7, right: 7),
            child: ListView.builder(
                itemCount: _barberShopDesc!.review.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    overlayColor: WidgetStateProperty.all(Colors.transparent),
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      child: SizedBox(
                        width: 85,
                        height: 50,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _barberShopDesc!.review[index].image != 'N/A'
                                ? CachedNetworkImage(
                                    imageUrl: global.baseUrlForImage + _barberShopDesc!.review[index].image!,
                                    imageBuilder: (context, imageProvider) => CircleAvatar(radius: 35, backgroundImage: imageProvider),
                                    placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                    errorWidget: (context, url, error) => const CircleAvatar(
                                      radius: 35,
                                      child: Icon(Icons.person),
                                    ),
                                  )
                                : CircleAvatar(
                                    radius: 31,
                                    backgroundColor: Theme.of(context).primaryColor,
                                    child: const CircleAvatar(
                                      radius: 30,
                                      backgroundColor: Colors.white,
                                      child: Icon(Icons.person),
                                    ),
                                  ),
                            Text(
                              _barberShopDesc!.review[index].name!,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).primaryTextTheme.bodyLarge,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(),
                              child: RatingBar.builder(
                                initialRating: _barberShopDesc!.review[index].rating.toDouble(),
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemSize: 15,
                                itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                                itemBuilder: (context, _) => const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                ignoreGestures: true,
                                updateOnDrag: false,
                                onRatingUpdate: (rating) {
                                  
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          )
        : Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                AppLocalizations.of(context)!.txt_nothing_is_yet_to_see_here,
                style: Theme.of(context).primaryTextTheme.titleMedium,
              ),
            ),
          );
  }

  Widget _reviewWidget() {
    try {
      return _barberShopDesc!.review.isNotEmpty
          ? ListView.builder(
              itemCount: _barberShopDesc!.review.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                    margin: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 1),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                _barberShopDesc!.review[index].image != 'N/A'
                                    ? CachedNetworkImage(
                                        imageUrl: global.baseUrlForImage + _barberShopDesc!.review[index].image!,
                                        imageBuilder: (context, imageProvider) => CircleAvatar(
                                          radius: 30,
                                          backgroundImage: imageProvider,
                                        ),
                                        placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                        errorWidget: (context, url, error) => CircleAvatar(
                                          radius: 31,
                                          backgroundColor: Theme.of(context).primaryColor,
                                          child: const CircleAvatar(
                                            radius: 30,
                                            backgroundColor: Colors.white,
                                            child: Icon(Icons.person),
                                          ),
                                        ),
                                      )
                                    : CircleAvatar(
                                        radius: 31,
                                        backgroundColor: Theme.of(context).primaryColor,
                                        child: const CircleAvatar(
                                          radius: 30,
                                          backgroundColor: Colors.white,
                                          child: Icon(Icons.person),
                                        ),
                                      ),
                                Padding(
                                  padding: global.isRTL ? const EdgeInsets.only(right: 15) : const EdgeInsets.only(left: 15),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${_barberShopDesc!.review[index].name}',
                                        style: Theme.of(context).primaryTextTheme.titleSmall,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            br.calculateDurationDiff(_barberShopDesc!.review[index].createdAt)!,
                                            style: Theme.of(context).primaryTextTheme.titleMedium,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 10),
                                            child: RatingBar.builder(
                                              initialRating: _barberShopDesc!.review[index].rating.toDouble(),
                                              minRating: 1,
                                              direction: Axis.horizontal,
                                              allowHalfRating: true,
                                              itemCount: 5,
                                              itemSize: 15,
                                              itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                                              itemBuilder: (context, _) => const Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              ),
                                              ignoreGestures: true,
                                              updateOnDrag: false,
                                              onRatingUpdate: (rating) {
                                                
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        '${_barberShopDesc!.review[index].description}',
                                        textAlign: TextAlign.justify,
                                        style: Theme.of(context).primaryTextTheme.titleMedium,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ));
              })
          : Center(
              child: Text(
                AppLocalizations.of(context)!.txt_nothing_is_yet_to_see_here,
                style: Theme.of(context).primaryTextTheme.titleMedium,
              ),
            );
    } catch (e) {
      debugPrint("Exception - barber_shop_description_screen.dart - _reviewWidget() : $e");
      return const SizedBox();
    }
  }

  Widget _serviceWidget() {
    try {
      return _barberShopDesc!.services.isNotEmpty
          ? ListView.builder(
              itemCount: _barberShopDesc!.services.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => ServiceDetailScreen(
                                serviceName: _barberShopDesc!.services[index].serviceName,
                                a: widget.analytics,
                                o: widget.observer,
                                serviceImage: _barberShopDesc!.services[index].serviceImage,
                              )),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 0),
                    child: Card(
                      shape: RoundedRectangleBorder(side: BorderSide(color: Colors.grey[400]!, width: 0.5), borderRadius: BorderRadius.circular(3)),
                      color: const Color(0xFFEEEEEE),
                      child: ExpansionTile(
                        onExpansionChanged: (val) {
                          setState(() {});
                        },
                        backgroundColor: Colors.transparent,
                        collapsedBackgroundColor: Colors.transparent,
                        tilePadding: const EdgeInsets.only(left: 16, right: 27),
                        textColor: const Color(0xffedaa3a),
                        collapsedTextColor: const Color(0xff543520),
                        iconColor: const Color(0xFF565656),
                        collapsedIconColor: const Color(0xFF565656),
                        title: Text(_barberShopDesc!.services[index].serviceName!, style: Theme.of(context).primaryTextTheme.titleSmall),
                        children: [
                          ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _barberShopDesc!.services[index].serviceType.length,
                              itemBuilder: (BuildContext context, int i) {
                                int? hr;
                                hr = _barberShopDesc!.services[index].serviceType[i].time;

                                return Column(
                                  children: [
                                    ListTile(
                                        visualDensity: const VisualDensity(vertical: -3),
                                        tileColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(color: Colors.grey[100]!, width: 0.5),
                                        ),
                                        title: Padding(
                                          padding: const EdgeInsets.only(left: 10),
                                          child: Text('${_barberShopDesc!.services[index].serviceType[i].variant}', textAlign: TextAlign.justify, style: Theme.of(context).primaryTextTheme.titleMedium),
                                        ),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(alignment: Alignment.centerRight, width: 70, child: Text('$hr m', style: const TextStyle(fontSize: 12, color: Color(0xFF898A8D), fontWeight: FontWeight.w400))),
                                            const VerticalDivider(
                                              color: Color(0xFF898A8D),
                                              indent: 13,
                                              endIndent: 13,
                                              thickness: 1,
                                            ),
                                            SizedBox(width: 60, child: Text(' ${global.currency.currencySign} ${_barberShopDesc!.services[index].serviceType[i].price}', style: TextStyle(fontSize: 12, color: Theme.of(context).primaryColor, fontWeight: FontWeight.w400)))
                                          ],
                                        )),
                                  ],
                                );
                              })
                        ],
                      ),
                    ),
                  ),
                );
              })
          : Center(
              child: Text(
                AppLocalizations.of(context)!.txt_nothing_is_yet_to_see_here,
                style: Theme.of(context).primaryTextTheme.titleMedium,
              ),
            );
    } catch (e) {
      debugPrint("Exception - barber_shop_description_screen.dart - _serviceWidget(): $e");
      return const SizedBox();
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
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.24,
                width: MediaQuery.of(context).size.width,
                child: const Card(),
              ),
              SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width,
                child: const Card(
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                ),
              ),
              SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width,
                child: const Card(
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 7,
                    itemBuilder: (BuildContext context, int index) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const CircleAvatar(
                                radius: 5,
                                child: Card(),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.5,
                                height: 30,
                                child: const Card(margin: EdgeInsets.all(8)),
                              )
                            ],
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.2,
                            height: 30,
                            child: const Card(margin: EdgeInsets.all(8)),
                          )
                        ],
                      );
                    }),
              ),
              SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.4,
                child: const Card(
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                ),
              ),
              SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.55,
                child: const Card(
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _similarBarberShop() {
    return _barberShopDesc!.similarSalons.isNotEmpty
        ? ListView.builder(
            itemCount: _barberShopDesc!.similarSalons.length,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => BarberShopDescriptionScreen(_barberShopDesc!.similarSalons[index].vendorId, a: widget.analytics, o: widget.observer)),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 6, right: 6, bottom: 6),
                  child: Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CachedNetworkImage(
                          imageUrl: global.baseUrlForImage + _barberShopDesc!.similarSalons[index].vendorLogo!,
                          imageBuilder: (context, imageProvider) => Container(
                            width: 180,
                            height: 80,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), image: DecorationImage(fit: BoxFit.cover, image: imageProvider)),
                          ),
                          placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                        ),
                        SizedBox(
                          width: 180,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 7, right: 7, bottom: 5, top: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text('${_barberShopDesc!.similarSalons[index].vendorName}', style: Theme.of(context).primaryTextTheme.bodyLarge, maxLines: 1, overflow: TextOverflow.ellipsis),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [Text('${_barberShopDesc!.similarSalons[index].rating}', style: Theme.of(context).primaryTextTheme.bodyLarge), Icon(Icons.star, size: 13, color: Colors.yellow[600])],
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 180,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 7),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.location_on_outlined,
                                  size: 18,
                                ),
                                SizedBox(
                                  width: 130,
                                  child: Text(
                                    '${_barberShopDesc!.similarSalons[index].vendorLoc}',
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).primaryTextTheme.bodyMedium,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            })
        : Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                AppLocalizations.of(context)!.txt_nothing_is_yet_to_see_here,
                style: Theme.of(context).primaryTextTheme.titleMedium,
              ),
            ),
          );
  }

  void _tabControllerListener() {
    setState(() {
      _currentIndex = _tabController!.index;
    });
  }

  _weekTimeSlotWidget() {
    try {
      return ListView.builder(
          itemCount: _barberShopDesc!.weeklyTime.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int i) {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 6.0),
                          child: Text(
                            "${_barberShopDesc!.weeklyTime[i].days}",
                            style: Theme.of(context).primaryTextTheme.titleSmall,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "${_barberShopDesc!.weeklyTime[i].openHour} - ${_barberShopDesc!.weeklyTime[i].closeHour}",
                      style: Theme.of(context).primaryTextTheme.titleMedium,
                    )
                  ],
                ),
              ],
            );
          });
    } catch (e) {
      debugPrint("Exception - barber_shop_description_screen.dart - _weekTimeSlotWidget():$e");
    }
  }

  _makePhoneCall() async {
    final String phoneNumber = 'tel:${ _barberShopDesc?.vendorPhone ?? '' }';

    if(await canLaunchUrlString(phoneNumber)) {
      await launchUrlString(phoneNumber);
    }
  }

  _openWhatsApp() async {
    final String whatsAppURL = _barberShopDesc?.vendorWhatsapp ?? '';

    if(await canLaunchUrlString(whatsAppURL)) {
      launchUrlString(whatsAppURL);
    }
  }
}
