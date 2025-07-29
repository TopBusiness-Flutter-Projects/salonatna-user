import 'package:app/models/banner_model.dart';
import 'package:app/models/barber_shop_model.dart';
import 'package:app/models/businessLayer/base_route.dart';
import 'package:app/models/businessLayer/global.dart' as global;
import 'package:app/models/popular_barbers_model.dart';
import 'package:app/models/product_model.dart';
import 'package:app/models/service_model.dart';
import 'package:app/screens/barber_detail_screen.dart';
import 'package:app/screens/barber_list_screen.dart';
import 'package:app/screens/barber_shop_description_screen.dart';
import 'package:app/screens/barber_shop_list_screen.dart';
import 'package:app/screens/notification_screen.dart';
import 'package:app/screens/product_detail_screen.dart';
import 'package:app/screens/product_list_screen.dart';
import 'package:app/screens/search_screen.dart';
import 'package:app/screens/service_detail_screen.dart';
import 'package:app/screens/service_list_screen.dart';
import 'package:app/screens/sign_in_screen.dart';
import 'package:app/widgets/bottom_navigation_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends BaseRoute {
  const HomeScreen({super.key, super.a, super.o}) : super(r: 'HomeScreen');
  @override
  BaseRouteState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends BaseRouteState<HomeScreen> {
  GlobalKey<ScaffoldState>? _scaffoldKey;
  List<BannerModel>? _bannerList = [];
  List<Service>? _serviceList = [];
  List<BarberShop>? _barberShopList = [];
  List<PopularBarbers>? _popularBarbersList = [];
  List<Product>? _productList = [];
  CarouselSliderController? _carouselController;
  int _currentIndex = 0;
  bool _isBannerDataLoaded = false;
  bool _isServicesDataLoaded = false;
  bool _isBarberShopDataLoaded = false;
  bool _isBarbersDataLoaded = false;
  bool _isProductsLoaded = false;

  _HomeScreenState() : super();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return Scaffold(
        body: SafeArea(
      top: false,
      child: SingleChildScrollView(
        child: Column(
          children: [
            _isBannerDataLoaded
                ? Container(
                    padding: EdgeInsets.only(
                        top: MediaQuery.viewPaddingOf(context).top + 16),
                    height: MediaQuery.of(context).size.height * 0.40,
                    decoration: const BoxDecoration(
                        color: Color(0xFF171D2C),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15))),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 13, right: 13),
                          child: Row(
                            children: [
                              (global.user?.image != null &&
                                      global.user?.image != "")
                                  ? CircleAvatar(
                                      radius: 26,
                                      backgroundColor: const Color(0xFFFA692C),
                                      child: CachedNetworkImage(
                                        imageUrl: global.baseUrlForImage +
                                            global.user!.image!,
                                        imageBuilder: (context,
                                                imageProvider) =>
                                            CircleAvatar(
                                                radius: 24,
                                                backgroundImage: imageProvider),
                                        placeholder: (context, url) =>
                                            const Center(
                                                child:
                                                    CircularProgressIndicator()),
                                        errorWidget: (context, url, error) =>
                                            const CircleAvatar(
                                          radius: 24,
                                          backgroundColor: Colors.white,
                                          child: Icon(Icons.person),
                                        ),
                                      ))
                                  : const CircleAvatar(
                                      radius: 24,
                                      backgroundColor: Colors.white,
                                      child: Icon(Icons.person),
                                    ),
                              Expanded(
                                child: Padding(
                                  padding: global.isRTL
                                      ? const EdgeInsets.only(right: 10)
                                      : const EdgeInsets.only(left: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                          global.user?.id == null ||
                                                  global.user?.name == ''
                                              ? AppLocalizations.of(context)!
                                                  .txt_sign_up_to_continue
                                              : '${global.user!.name}',
                                          style: Theme.of(context)
                                              .primaryTextTheme
                                              .displayLarge),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    BottomNavigationWidget(
                                                      a: widget.analytics,
                                                      o: widget.observer,
                                                      screenId: 1,
                                                    )),
                                          );
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                              Icons.location_on_outlined,
                                              size: 17,
                                            ),
                                            SizedBox(
                                              width: 130,
                                              child: Text(
                                                global.currentLocation,
                                                overflow: TextOverflow.ellipsis,
                                                style: Theme.of(context)
                                                    .primaryTextTheme
                                                    .displayMedium,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              IconButton(
                                  padding: const EdgeInsets.all(0),
                                  alignment: global.isRTL
                                      ? Alignment.centerLeft
                                      : Alignment.centerRight,
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) => SearchScreen(0,
                                              a: widget.analytics,
                                              o: widget.observer)),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.search,
                                    size: 22,
                                  )),
                              IconButton(
                                  padding: const EdgeInsets.all(0),
                                  alignment: global.isRTL
                                      ? Alignment.centerLeft
                                      : Alignment.centerRight,
                                  onPressed: () {
                                    global.user!.id == null
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
                                                    NotificationScreen(
                                                        a: widget.analytics,
                                                        o: widget.observer)),
                                          );
                                  },
                                  icon: const Icon(
                                    Icons.notifications,
                                    size: 22,
                                  ))
                            ],
                          ),
                        ),
                        _bannerList!.isNotEmpty
                            ? CarouselSlider(
                                items: _items(),
                                carouselController: _carouselController,
                                options: CarouselOptions(
                                    height: MediaQuery.of(context).size.height *
                                        0.25,
                                    aspectRatio: 1,
                                    viewportFraction: 0.93,
                                    initialPage: _currentIndex,
                                    enableInfiniteScroll: true,
                                    reverse: false,
                                    autoPlay: true,
                                    autoPlayInterval:
                                        const Duration(seconds: 3),
                                    autoPlayAnimationDuration:
                                        const Duration(milliseconds: 800),
                                    autoPlayCurve: Curves.fastOutSlowIn,
                                    enlargeCenterPage: true,
                                    scrollDirection: Axis.horizontal,
                                    onPageChanged: (index, _) {
                                      _currentIndex = index;
                                      setState(() {});
                                    }))
                            : SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.25,
                                child: Center(
                                    child: Text(
                                  AppLocalizations.of(context)!
                                      .txt_no_saloon_are_available_at_your_location,
                                  style: Theme.of(context)
                                      .primaryTextTheme
                                      .displayMedium,
                                ))),
                        _isBannerDataLoaded
                            ? _bannerList!.isNotEmpty
                                ? DotsIndicator(
                                    dotsCount: _bannerList!.length,
                                    position: _currentIndex,
                                    onTap: (i) {
                                      _currentIndex = i.toInt();
                                      _carouselController!.animateToPage(
                                          _currentIndex,
                                          duration:
                                              const Duration(microseconds: 1),
                                          curve: Curves.easeInOut);
                                    },
                                    decorator: DotsDecorator(
                                      activeSize: const Size(6, 6),
                                      size: const Size(6, 6),
                                      activeShape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50.0))),
                                      activeColor:
                                          Theme.of(context).primaryColor,
                                      color:
                                          Theme.of(context).primaryColorLight,
                                    ),
                                  )
                                : const SizedBox()
                            : const SizedBox()
                      ],
                    ),
                  )
                : _shimmer1(),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 13, right: 13),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(AppLocalizations.of(context)!.lbl_services,
                      style: Theme.of(context).primaryTextTheme.titleLarge),
                  InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      overlayColor: WidgetStateProperty.all(Colors.transparent),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => ServiceListScreen(
                                    a: widget.analytics,
                                    o: widget.observer,
                                  )),
                        );
                      },
                      child: Text(
                          AppLocalizations.of(context)!.lbl_see_services,
                          style:
                              Theme.of(context).primaryTextTheme.headlineSmall))
                ],
              ),
            ),
            SizedBox(
                height: 60,
                child: _isServicesDataLoaded
                    ? _serviceList!.isNotEmpty
                        ? _services()
                        : Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                AppLocalizations.of(context)!
                                    .txt_no_service_available_at_your_location,
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .titleMedium,
                              ),
                            ),
                          )
                    : _shimmer2()),
            Padding(
              padding: const EdgeInsets.only(top: 18, left: 13, right: 13),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(AppLocalizations.of(context)!.lbl_recommended_barbershop,
                      style: Theme.of(context).primaryTextTheme.titleLarge),
                  InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      overlayColor: WidgetStateProperty.all(Colors.transparent),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => BarberShopListScreen(
                                  a: widget.analytics, o: widget.observer)),
                        );
                      },
                      child: Text(AppLocalizations.of(context)!.lbl_see_more,
                          style:
                              Theme.of(context).primaryTextTheme.headlineSmall))
                ],
              ),
            ),
            SizedBox(
                height: 170,
                child: _isBarberShopDataLoaded
                    ? _barberShopList!.isNotEmpty
                        ? _recommendedBarbershop()
                        : Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                AppLocalizations.of(context)!
                                    .txt_no_barbershop_are_available_at_your_location,
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .titleMedium,
                              ),
                            ),
                          )
                    : _shimmer3()),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 13, right: 13),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(AppLocalizations.of(context)!.lbl_popular_barbers,
                      style: Theme.of(context).primaryTextTheme.titleLarge),
                  InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      overlayColor: WidgetStateProperty.all(Colors.transparent),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => BarberListScreen(
                                    a: widget.analytics,
                                    o: widget.observer,
                                  )),
                        );
                      },
                      child: Text(AppLocalizations.of(context)!.lbl_see_more,
                          style: Theme.of(context)
                              .primaryTextTheme
                              .headlineSmall)),
                ],
              ),
            ),
            SizedBox(
                height: 120,
                child: _isBarbersDataLoaded
                    ? _popularBarbersList!.isNotEmpty
                        ? Align(
                            alignment: global.isRTL
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: _popularBarbers())
                        : Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                AppLocalizations.of(context)!
                                    .txt_no_barbers_are_available_at_your_location,
                                style: Theme.of(context)
                                    .primaryTextTheme
                                    .titleMedium,
                              ),
                            ),
                          )
                    : _shimmer4()),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 13, right: 13),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(AppLocalizations.of(context)!.lbl_products,
                      style: Theme.of(context).primaryTextTheme.titleLarge),
                  InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      overlayColor: WidgetStateProperty.all(Colors.transparent),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => ProductListScreen(
                                    a: widget.analytics,
                                    o: widget.observer,
                                  )),
                        );
                      },
                      child: Text(AppLocalizations.of(context)!.lbl_see_more,
                          style: Theme.of(context)
                              .primaryTextTheme
                              .headlineSmall)),
                ],
              ),
            ),
            SizedBox(
              height: 160,
              child: _isProductsLoaded
                  ? _productList!.isNotEmpty
                      ? _products()
                      : Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              AppLocalizations.of(context)!
                                  .txt_nothing_is_yet_to_see_here,
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .titleMedium,
                            ),
                          ),
                        )
                  : _shimmer3(),
            ),
          ],
        ),
      ),
    ));
  }

  @override
  void initState() {
    super.initState();

    _init();
  }

  Future<bool?> _addToFavorite(int? id) async {
    bool isFav = false;
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        showOnlyLoaderDialog();
        await apiHelper!.addToFavorite(global.user!.id, id).then((result) {
          if (result != null) {
            if (result.status == "1") {
              hideLoader();
              isFav = true;

              setState(() {});
            } else if (result.status == "0") {
              hideLoader();
              isFav = true;
            }
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
      return isFav;
    } catch (e) {
      debugPrint("Exception - home_screen.dart - _addToFavorite():$e");
      return null;
    }
  }

  _getNearByBanners() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        await apiHelper!
            .getNearByBanners(global.lat, global.lng)
            .then((result) {
          if (result != null) {
            if (result.status == "1") {
              _bannerList = result.recordList;
            } else {}
          }
          _isBannerDataLoaded = true;
          setState(() {});
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
    } catch (e) {
      debugPrint("Exception - home_screen.dart - _getNearByBanners():$e");
    }
  }

  _getNearByBarberShops() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        await apiHelper!
            .getNearByBarberShops(global.lat, global.lng, 1)
            .then((result) {
          if (result != null) {
            if (result.status == "1") {
              _barberShopList = result.recordList;
            } else {}
          }
          _isBarberShopDataLoaded = true;
          setState(() {});
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
    } catch (e) {
      debugPrint("Exception - home_screen.dart - _getNearByBarberShops():$e");
    }
  }

  _getPopularBarbers() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        await apiHelper!
            .getPopularBarbersList(global.lat, global.lng, 1, null)
            .then((result) {
          if (result != null) {
            if (result.status == "1") {
              _popularBarbersList = result.recordList;
            } else {}
          }
          _isBarbersDataLoaded = true;
          setState(() {});
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
    } catch (e) {
      debugPrint("Exception - home_screen.dart - _getServices():$e");
    }
  }

  _getProducts() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        await apiHelper!
            .getProducts(global.lat, global.lng, 1, '')
            .then((result) {
          if (result != null) {
            if (result.status == "1") {
              _productList = result.recordList;
            } else {}
          }
          _isProductsLoaded = true;
          setState(() {});
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
    } catch (e) {
      debugPrint("Exception - home_screen.dart - _getProducts():$e");
    }
  }

  _getServices() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        await apiHelper!.getServices(global.lat, global.lng, 1).then((result) {
          if (result != null) {
            if (result.status == "1") {
              _serviceList = result.recordList;
            } else {}
          }
          _isServicesDataLoaded = true;
          setState(() {});
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
    } catch (e) {
      debugPrint("Exception - home_screen.dart - _getServices():$e");
    }
  }

  _init() async {
    final List<dynamic> _ = await Future.wait([
      _getNearByBanners(),
      _getServices(),
      _getNearByBarberShops(),
      _getPopularBarbers(),
      _getProducts()
    ]);
    setState(() {});
  }

  List<Widget> _items() {
    List<Widget> list = [];
    try {
      for (int i = 0; i < _bannerList!.length; i++) {
        list.add(GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => BarberShopDescriptionScreen(
                        int.parse(_bannerList![i].vendorId!),
                        a: widget.analytics,
                        o: widget.observer,
                      )),
            );
          },
          child: _bannerList![i].bannerImage != "N/A" &&
                  _bannerList![i].bannerImage != null
              ? CachedNetworkImage(
                  imageUrl:
                      "${global.baseUrlForImage}${_bannerList![i].bannerImage!}",
                  imageBuilder: (context, imageProvider) => Container(
                    margin: const EdgeInsets.only(
                      top: 18,
                      bottom: 10,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                          image: imageProvider, fit: BoxFit.cover),
                    ),
                  ),
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Container(
                    margin: const EdgeInsets.only(
                        top: 18, bottom: 10, left: 15, right: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child:
                        Text(AppLocalizations.of(context)!.txt_no_image_availa),
                  ),
                )
              : Container(
                  margin: const EdgeInsets.only(
                      top: 18, bottom: 10, left: 15, right: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child:
                      Text(AppLocalizations.of(context)!.txt_no_image_availa),
                ),
        ));
      }

      return list;
    } catch (e) {
      debugPrint("Exception - home_screen.dart - _items(): ${e.toString()}}");
      list.add(const SizedBox());
      return list;
    }
  }

  Widget _popularBarbers() {
    return Padding(
      padding: const EdgeInsets.only(left: 7, right: 7),
      child: ListView.builder(
          itemCount: _popularBarbersList!.length,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              overlayColor: WidgetStateProperty.all(Colors.transparent),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => BarberDetailScreen(
                          _popularBarbersList![index].staffId,
                          a: widget.analytics,
                          o: widget.observer)),
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
                        imageUrl: global.baseUrlForImage +
                            _popularBarbersList![index].staffImage!,
                        imageBuilder: (context, imageProvider) => CircleAvatar(
                            radius: 35, backgroundImage: imageProvider),
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) =>
                            const CircleAvatar(
                          radius: 35,
                          child: Icon(Icons.person),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                        child: Text(
                          _popularBarbersList![index].staffName!,
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
    );
  }

  Widget _products() {
    return Padding(
      padding: const EdgeInsets.only(left: 7, right: 7),
      child: Align(
        alignment: global.isRTL ? Alignment.centerRight : Alignment.centerLeft,
        child: ListView.builder(
            itemCount: _productList!.length,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                overlayColor: WidgetStateProperty.all(Colors.transparent),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => ProductDetailScreen(
                            _productList![index].id,
                            a: widget.analytics,
                            o: widget.observer,
                            isShowGoCartBtn:
                                _productList![index].cartQty != null &&
                                        _productList![index].cartQty! > 0
                                    ? true
                                    : false)),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 7, right: 7, bottom: 3, top: 5),
                  child: SizedBox(
                    width: 110,
                    child: Card(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CachedNetworkImage(
                            imageUrl: global.baseUrlForImage +
                                _productList![index].productImage!,
                            imageBuilder: (context, imageProvider) => Container(
                                width: 110,
                                height: 110,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: imageProvider)),
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: IconButton(
                                      alignment: Alignment.topRight,
                                      padding: const EdgeInsets.all(4),
                                      onPressed: () async {
                                        if (global.user!.id == null) {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SignInScreen(
                                                      a: widget.analytics,
                                                      o: widget.observer,
                                                    )),
                                          );
                                        } else {
                                          bool? isFav;
                                          isFav = await _addToFavorite(
                                              _productList![index].id);
                                          if (isFav! &&
                                              _productList![index]
                                                      .isFavourite !=
                                                  null) {
                                            _productList![index].isFavourite =
                                                !_productList![index]
                                                    .isFavourite!;
                                          }
                                        }
                                        setState(() {});
                                      },
                                      icon: Icon(
                                        _productList![index].isFavourite !=
                                                    null &&
                                                _productList![index]
                                                    .isFavourite!
                                            ? Icons.favorite
                                            : Icons.favorite_outline,
                                        color:
                                            _productList![index].isFavourite !=
                                                        null &&
                                                    _productList![index]
                                                        .isFavourite!
                                                ? const Color(0xFFFA692C)
                                                : Colors.white,
                                        size: 20,
                                      )),
                                )),
                            placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) => Container(
                                width: 110,
                                height: 110,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Text(
                                  "No image",
                                  style: Theme.of(context)
                                      .primaryTextTheme
                                      .titleMedium,
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: Text(
                              '${_productList![index].productName}',
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style:
                                  Theme.of(context).primaryTextTheme.bodyLarge,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }

  Widget _recommendedBarbershop() {
    return Padding(
      padding: const EdgeInsets.only(left: 7, right: 7),
      child: Align(
        alignment: global.isRTL ? Alignment.centerRight : Alignment.centerLeft,
        child: ListView.builder(
            itemCount: _barberShopList!.length,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                overlayColor: WidgetStateProperty.all(Colors.transparent),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => BarberShopDescriptionScreen(
                            _barberShopList![index].vendorId,
                            a: widget.analytics,
                            o: widget.observer)),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 7, right: 7, bottom: 2, top: 5),
                  child: Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CachedNetworkImage(
                          imageUrl: global.baseUrlForImage +
                              _barberShopList![index].vendorLogo!,
                          imageBuilder: (context, imageProvider) => Container(
                            width: 180,
                            height: 80,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                    fit: BoxFit.cover, image: imageProvider)),
                          ),
                          placeholder: (context, url) => const SizedBox(
                              width: 180,
                              height: 80,
                              child:
                                  Center(child: CircularProgressIndicator())),
                          errorWidget: (context, url, error) => Container(
                            width: 180,
                            height: 80,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                                child: Text(AppLocalizations.of(context)!
                                    .txt_no_image_availa)),
                          ),
                        ),
                        SizedBox(
                          width: 180,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 7, right: 7, bottom: 5, top: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                    child: Padding(
                                  padding: const EdgeInsets.only(left: 3),
                                  child: Text(
                                      '${_barberShopList![index].vendorName}',
                                      style: Theme.of(context)
                                          .primaryTextTheme
                                          .bodyLarge,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1),
                                )),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 180,
                          child: Padding(
                            padding: global.isRTL
                                ? const EdgeInsets.only(right: 7)
                                : const EdgeInsets.only(left: 7),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.location_on_outlined,
                                  size: 15,
                                ),
                                SizedBox(
                                  width: 150,
                                  child: Text(
                                    '${_barberShopList![index].vendorLoc}',
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .bodyMedium,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        _barberShopList![index].rating != null
                            ? Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('${_barberShopList![index].rating}',
                                        style: Theme.of(context)
                                            .primaryTextTheme
                                            .bodyMedium),
                                    RatingBar.builder(
                                      initialRating:
                                          _barberShopList![index].rating!,
                                      minRating: 0,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      itemSize: 8,
                                      itemPadding: const EdgeInsets.symmetric(
                                          horizontal: 0),
                                      itemBuilder: (context, _) => const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      ignoreGestures: true,
                                      updateOnDrag: false,
                                      onRatingUpdate: (rating) {},
                                    )
                                  ],
                                ),
                              )
                            : const SizedBox()
                      ],
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }

  Widget _services() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 7,
        right: 7,
        top: 1,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: ListView.builder(
            itemCount: _serviceList!.length,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                overlayColor: WidgetStateProperty.all(Colors.transparent),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => ServiceDetailScreen(
                            serviceName: _serviceList![index].serviceName,
                            a: widget.analytics,
                            o: widget.observer,
                            serviceImage: _serviceList![index].serviceImage)),
                  );
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CachedNetworkImage(
                      imageUrl: global.baseUrlForImage +
                          _serviceList![index].serviceImage!,
                      imageBuilder: (context, imageProvider) => Card(
                        margin:
                            const EdgeInsets.only(left: 4, right: 4, bottom: 4),
                        child: Container(
                          width: 120,
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                  fit: BoxFit.cover, image: imageProvider)),
                        ),
                      ),
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => Container(
                        margin:
                            const EdgeInsets.only(left: 4, right: 4, bottom: 4),
                        width: 120,
                        height: 50,
                        child: Card(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Text(
                                AppLocalizations.of(context)!.lbl_no_image),
                          ),
                        ),
                      ),
                    ),
                    Opacity(
                      opacity: 0.5,
                      child: Container(
                        margin:
                            const EdgeInsets.only(left: 4, right: 4, bottom: 4),
                        width: 120,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    Center(
                        child: Text('${_serviceList![index].serviceName}',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.w400)))
                  ],
                ),
              );
            }),
      ),
    );
  }

  Widget _shimmer1() {
    return Padding(
        padding: const EdgeInsets.all(15),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Column(
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 26,
                    child: Card(),
                  ),
                  SizedBox(
                    height: 60,
                    width: MediaQuery.of(context).size.width - 90,
                    child: const Card(
                      margin: EdgeInsets.only(left: 5, bottom: 10),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 150,
                width: MediaQuery.of(context).size.width,
                child: const Card(),
              ),
            ],
          ),
        ));
  }

  Widget _shimmer2() {
    return Padding(
        padding: const EdgeInsets.all(15),
        child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (BuildContext context, int index) {
                  return const SizedBox(
                    width: 100,
                    height: 60,
                    child: Card(
                      margin: EdgeInsets.only(left: 5, right: 5),
                    ),
                  );
                })));
  }

  Widget _shimmer3() {
    return Padding(
        padding: const EdgeInsets.all(15),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (BuildContext context, int index) {
                return const SizedBox(
                  width: 170,
                  height: 150,
                  child: Card(
                    margin: EdgeInsets.only(left: 5, right: 5),
                  ),
                );
              }),
        ));
  }

  Widget _shimmer4() {
    return Padding(
        padding: const EdgeInsets.all(15),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (BuildContext context, int index) {
                return const Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      child: Card(),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                );
              }),
        ));
  }
}
