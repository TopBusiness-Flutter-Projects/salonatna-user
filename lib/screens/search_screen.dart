import 'package:app/models/barber_shop_model.dart';
import 'package:app/models/businessLayer/base_route.dart';
import 'package:app/models/businessLayer/global.dart' as global;
import 'package:app/models/popular_barbers_model.dart';
import 'package:app/models/product_model.dart';
import 'package:app/models/service_model.dart';
import 'package:app/screens/barber_detail_screen.dart';
import 'package:app/screens/barber_shop_description_screen.dart';
import 'package:app/screens/product_detail_screen.dart';
import 'package:app/screens/service_detail_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shimmer/shimmer.dart';

class SearchScreen extends BaseRoute {
  final int index;
  const SearchScreen(this.index, {super.key, super.a, super.o}) : super(r: 'SearchScreen');
  @override
  BaseRouteState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends BaseRouteState<SearchScreen> {
  GlobalKey<ScaffoldState>? _scaffoldKey;
  final List<Service> _serviceList = [];
  final List<BarberShop> _barberShopList = [];
  final List<PopularBarbers> _popularBarbersList = [];
  final List<Product> _productList = [];
  final TextEditingController _cSearch = TextEditingController();
  String searchString = '';
  final FocusNode _fSearch = FocusNode();
  TabController? _tabController;
  int _currentIndex = 0;
  int pageNumberBarberShop = 0;
  int pageNumberBarbers = 0;
  int pageNumberProducts = 0;
  int pageNumberServices = 0;

  final ScrollController _scrollControllerBarberShop = ScrollController();
  final ScrollController _scrollControllerBarbers = ScrollController();
  final ScrollController _scrollControllerProducts = ScrollController();
  final ScrollController _scrollControllerServices = ScrollController();
  bool _isBarberShopDataLoaded = false;
  bool _isBarbersDataLoaded = false;
  bool _isProductsDataLoaded = false;
  bool _isServicesDataLoaded = false;

  bool _isBarberShopRecordPending = true;
  bool _isBarbersRecordPending = true;
  bool _isProductsRecordPending = true;
  bool _isServicesRecordPending = true;

  bool _isBarberShopMoreDataLoaded = false;
  bool _isBarbersMoreDataLoaded = false;
  bool _isProductsMoreDataLoaded = false;
  bool _isServicesMoreDataLoaded = false;

  int pageNumber = 0;

  _SearchScreenState() : super();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: DefaultTabController(
        length: 4,
        initialIndex: _currentIndex,
        child: Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.lbl_search, style: AppBarTheme.of(context).titleTextStyle),
            ),
            body: Column(
              children: [
                Container(
                  height: 45,
                  margin: const EdgeInsets.only(top: 8, bottom: 8, left: 13, right: 13),
                  child: Card(
                    child: TextFormField(
                      textAlign: TextAlign.start,
                      autofocus: false,
                      cursorColor: const Color(0xFFFA692C),
                      enabled: true,
                      style: Theme.of(context).primaryTextTheme.titleLarge,
                      controller: _cSearch,
                      focusNode: _fSearch,
                      onFieldSubmitted: (text) async {
                        searchString = text;

                        await _searchData();
                        setState(() {});
                      },
                      onChanged: (text) async {
                        if (text == "" || text.isEmpty) {
                          searchString = "";

                          await _searchData();
                        }

                        setState(() {});
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.search,
                          color: Theme.of(context).floatingActionButtonTheme.backgroundColor,
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () async {
                            searchString = _cSearch.text;
                            await _searchData();
                            setState(() {});
                          },
                          child: Container(
                            width: 50,
                            decoration: BoxDecoration(color: const Color(0xFFFA692C), borderRadius: BorderRadius.circular(5)),
                            child: const Icon(
                              Icons.arrow_circle_down_outlined,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ),
                        hintText: AppLocalizations.of(context)!.hnt_search,
                      ),
                      onEditingComplete: () {
                        FocusScope.of(context).unfocus();
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 13, right: 13),
                  child: TabBar(
                    indicatorColor: const Color(0xFFFA692C),
                    controller: _tabController,
                    overlayColor: WidgetStateProperty.all(Colors.transparent),
                    tabs: [
                      Text(AppLocalizations.of(context)!.lbl_barbershops),
                      Text(AppLocalizations.of(context)!.lbl_barbers),
                      Text(AppLocalizations.of(context)!.lbl_products),
                      Text(AppLocalizations.of(context)!.lbl_services),
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
                    child: TabBarView(controller: _tabController, children: [_barberShopView(), _barbersList(), _productListWidget(), _servicesList()]),
                  ),
                )
              ],
            )),
      ),
    );
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
    _currentIndex = widget.index;
    _tabController = TabController(initialIndex: _currentIndex, length: 4, vsync: this);
    _tabController!.addListener(_tabControllerListener);
    _init();
  }

  Widget _barberShopView() {
    return _isBarberShopDataLoaded
        ? _barberShopList.isNotEmpty
            ? ListView.builder(
                controller: _scrollControllerBarberShop,
                itemCount: _barberShopList.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    overlayColor: WidgetStateProperty.all(Colors.transparent),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => BarberShopDescriptionScreen(_barberShopList[index].vendorId, a: widget.analytics, o: widget.observer)),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 8, left: 13, right: 13),
                      child: Card(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CachedNetworkImage(
                                  imageUrl: global.baseUrlForImage + _barberShopList[index].vendorLogo!,
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
                                    padding: global.isRTL ? const EdgeInsets.only(right: 8) : const EdgeInsets.only(left: 8),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          '${_barberShopList[index].vendorName}',
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context).primaryTextTheme.bodyLarge,
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          '${_barberShopList[index].vendorLoc}',
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context).primaryTextTheme.bodyMedium,
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
                    ),
                  );
                },
              )
            : Center(
                child: Text(
                  AppLocalizations.of(context)!.txt_nothing_is_yet_to_see_here,
                  style: Theme.of(context).primaryTextTheme.titleMedium,
                ),
              )
        : _shimmer();
  }

  Widget _barbersList() {
    return _isBarbersDataLoaded
        ? _popularBarbersList.isNotEmpty
            ? ListView.builder(
                controller: _scrollControllerBarbers,
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
              )
        : _shimmerBarberList();
  }

  _getNearByBarberShops() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        if (_isBarberShopRecordPending) {
          setState(() {
            _isBarberShopMoreDataLoaded = true;
          });

          if (_barberShopList.isEmpty) {
            pageNumberBarberShop = 1;
          } else {
            pageNumberBarberShop++;
          }
          await apiHelper!.getNearByBarberShops(global.lat, global.lng, pageNumberBarberShop, searchstring: searchString).then((result) {
            if (result != null) {
              if (result.status == "1") {
                List<BarberShop> tList = result.recordList;
                if (tList.isEmpty) {
                  _isBarberShopRecordPending = false;
                }

                _barberShopList.addAll(tList);
                setState(() {
                  _isBarberShopMoreDataLoaded = false;
                });
              } else {}
            }
          });
        }
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
    } catch (e) {
      debugPrint("Exception - search_screen.dart - _getNearByBarberShops():$e");
    }
  }

  _getPopularBarbers() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        if (_isBarbersRecordPending) {
          setState(() {
            _isBarbersMoreDataLoaded = true;
          });

          if (_popularBarbersList.isEmpty) {
            pageNumberBarbers = 1;
          } else {
            pageNumberBarbers++;
          }
          await apiHelper!.getPopularBarbersList(global.lat, global.lng, pageNumberBarbers, searchString).then((result) {
            if (result != null) {
              if (result.status == "1") {
                List<PopularBarbers> tList = result.recordList;
                if (tList.isEmpty) {
                  _isBarbersRecordPending = false;
                }

                _popularBarbersList.addAll(tList);
                setState(() {
                  _isBarbersMoreDataLoaded = false;
                });
              } else {}
            }
          });
        }
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
    } catch (e) {
      debugPrint("Exception - search_screen.dart - _getPopularBarbers():$e");
    }
  }

  _getProducts() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        if (_isProductsRecordPending) {
          setState(() {
            _isProductsMoreDataLoaded = true;
          });

          if (_productList.isEmpty) {
            pageNumberProducts = 1;
          } else {
            pageNumberProducts++;
          }
          await apiHelper!.getProducts(global.lat, global.lng, pageNumberProducts, searchString).then((result) {
            if (result != null) {
              if (result.status == "1") {
                List<Product> tList = result.recordList;
                if (tList.isEmpty) {
                  _isProductsRecordPending = false;
                }

                _productList.addAll(tList);
                setState(() {
                  _isProductsMoreDataLoaded = false;
                });
              } else {}
            }
          });
        }
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
    } catch (e) {
      debugPrint("Exception - search_screen.dart - _getProducts():$e");
    }
  }

  _getServices() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        if (_isServicesRecordPending) {
          setState(() {
            _isServicesMoreDataLoaded = true;
          });

          if (_serviceList.isEmpty) {
            pageNumberServices = 1;
          } else {
            pageNumberServices++;
          }
          await apiHelper!.getServices(global.lat, global.lng, pageNumberServices, searchstring: searchString).then((result) {
            if (result != null) {
              if (result.status == "1") {
                List<Service> tList = result.recordList;
                if (tList.isEmpty) {
                  _isServicesRecordPending = false;
                }

                _serviceList.addAll(tList);
                setState(() {
                  _isServicesMoreDataLoaded = false;
                });
              } else {}
            }
          });
        }
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
    } catch (e) {
      debugPrint("Exception - search_screen.dart - _getServices():$e");
    }
  }

  _init() async {
    try {
      await _searchData();

      _scrollControllerBarberShop.addListener(() async {
        if (_scrollControllerBarberShop.position.pixels == _scrollControllerBarberShop.position.maxScrollExtent && !_isBarberShopMoreDataLoaded) {
          setState(() {
            _isBarberShopMoreDataLoaded = true;
          });
          await _getNearByBarberShops();
          setState(() {
            _isBarberShopMoreDataLoaded = false;
          });
        }
      });
      _isBarberShopDataLoaded = true;
      setState(() {});

      _scrollControllerBarbers.addListener(() async {
        if (_scrollControllerBarbers.position.pixels == _scrollControllerBarbers.position.maxScrollExtent && !_isBarbersMoreDataLoaded) {
          setState(() {
            _isBarbersMoreDataLoaded = true;
          });
          await _getPopularBarbers();
          setState(() {
            _isBarbersMoreDataLoaded = false;
          });
        }
      });
      _isBarbersDataLoaded = true;
      setState(() {});

      _scrollControllerProducts.addListener(() async {
        if (_scrollControllerProducts.position.pixels == _scrollControllerProducts.position.maxScrollExtent && !_isProductsMoreDataLoaded) {
          setState(() {
            _isProductsMoreDataLoaded = true;
          });
          await _getProducts();
          setState(() {
            _isProductsMoreDataLoaded = false;
          });
        }
      });
      _isProductsDataLoaded = true;
      setState(() {});

      _scrollControllerServices.addListener(() async {
        if (_scrollControllerServices.position.pixels == _scrollControllerServices.position.maxScrollExtent && !_isServicesMoreDataLoaded) {
          setState(() {
            _isServicesMoreDataLoaded = true;
          });
          await _getServices();
          setState(() {
            _isServicesMoreDataLoaded = false;
          });
        }
      });
      _isServicesDataLoaded = true;
      setState(() {});
    } catch (e) {
      debugPrint("Exception - search_screen.dart - _init():$e");
    }
  }

  Widget _productListWidget() {
    return _isProductsDataLoaded
        ? _productList.isNotEmpty
            ? ListView.builder(
                itemCount: _productList.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    overlayColor: WidgetStateProperty.all(Colors.transparent),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => ProductDetailScreen(
                                  _productList[index].id,
                                  a: widget.analytics,
                                  o: widget.observer,
                                  isShowGoCartBtn: _productList[index].cartQty != null && _productList[index].cartQty! > 0 ? true : false,
                                )),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 8, left: 13, right: 13),
                      child: Card(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CachedNetworkImage(
                                  imageUrl: global.baseUrlForImage + _productList[index].productImage!,
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
                                          '${_productList[index].productName}',
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context).primaryTextTheme.bodyLarge,
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          '${_productList[index].description}',
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context).primaryTextTheme.bodyMedium,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const Icon(Icons.keyboard_arrow_right),
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
              )
        : _shimmer();
  }

  _searchData() async {
    try {
      _isBarberShopDataLoaded = false;
      _isServicesDataLoaded = false;
      _isBarbersDataLoaded = false;
      _isProductsDataLoaded = false;
      setState(() {});
      _barberShopList.clear();
      _popularBarbersList.clear();
      _productList.clear();
      _serviceList.clear();

      pageNumberBarberShop = 1;
      pageNumberBarbers = 1;
      pageNumberProducts = 1;
      pageNumberServices = 1;

      _isBarberShopRecordPending = true;
      _isBarbersRecordPending = true;
      _isProductsRecordPending = true;
      _isServicesRecordPending = true;
      await _getNearByBarberShops();
      _isBarberShopDataLoaded = true;
      await _getPopularBarbers();
      _isBarbersDataLoaded = true;
      await _getProducts();
      _isProductsDataLoaded = true;
      await _getServices();
      _isServicesDataLoaded = true;
      setState(() {});
    } catch (e) {
      debugPrint("Exception - search_screen.dart - _searchData():$e");
    }
  }

  Widget _servicesList() {
    return _isServicesDataLoaded
        ? _serviceList.isNotEmpty
            ? ListView.builder(
                controller: _scrollControllerServices,
                itemCount: _serviceList.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    overlayColor: WidgetStateProperty.all(Colors.transparent),
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => ServiceDetailScreen(serviceName: _serviceList[index].serviceName, a: widget.analytics, o: widget.observer, serviceImage: _serviceList[index].serviceImage)),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 8, left: 13, right: 13),
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
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context).primaryTextTheme.bodyLarge,
                                        ),
                                        const SizedBox(
                                          height: 5,
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
                    ),
                  );
                },
              )
            : Center(
                child: Text(
                  AppLocalizations.of(context)!.txt_nothing_is_yet_to_see_here,
                  style: Theme.of(context).primaryTextTheme.titleMedium,
                ),
              )
        : _shimmer();
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

  Widget _shimmerBarberList() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: 5,
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

  void _tabControllerListener() {
    try {
      setState(() {
        _currentIndex = _tabController!.index;
      });
    } catch (e) {
      debugPrint("Exception - search_screen.dart - _tabControllerListener():$e");
    }
  }
}
