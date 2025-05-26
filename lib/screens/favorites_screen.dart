import 'dart:async';

import 'package:app/models/businessLayer/base_route.dart';
import 'package:app/models/businessLayer/global.dart' as global;
import 'package:app/models/favorite_model.dart';
import 'package:app/screens/cart_screen.dart';
import 'package:app/screens/product_detail_screen.dart';
import 'package:app/screens/search_screen.dart';
import 'package:app/screens/sign_in_screen.dart';
import 'package:badges/badges.dart' as badges;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shimmer/shimmer.dart';

class FavouritesScreen extends BaseRoute {
  const FavouritesScreen({super.key, super.a, super.o}) : super(r: 'FavouritesScreen');
  @override
  BaseRouteState<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends BaseRouteState<FavouritesScreen> {
  GlobalKey<ScaffoldState>? _scaffoldKey;
  Favorites? _favoritesList;
  bool _isDataLoaded = false;

  _FavouritesScreenState() : super();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return PopScope(
      canPop: false,
      child: sc(Scaffold(
          appBar: AppBar(
            title: Text(
              AppLocalizations.of(context)!.lbl_favourites,
              style: Theme.of(context).appBarTheme.titleTextStyle,
            ),
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => SearchScreen(
                                0,
                                a: widget.analytics,
                                o: widget.observer,
                              )),
                    );
                  },
                  icon: const Icon(Icons.search)),
              _isDataLoaded
                  ? Container(
                      margin: const EdgeInsets.only(top: 3),
                      padding: global.isRTL
                          ? const EdgeInsets.only(
                              left: 20,
                            )
                          : const EdgeInsets.only(
                              right: 20,
                            ),
                      child: badges.Badge(
                        badgeStyle: badges.BadgeStyle(
                          padding: const EdgeInsets.all(5),
                          badgeColor: Theme.of(context).primaryColor,
                        ),
                        showBadge: true,
                        badgeContent: Text(
                          '${global.user!.cartCount}',
                          style: const TextStyle(color: Colors.white, fontSize: 15),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => CartScreen(
                                      a: widget.analytics,
                                      o: widget.observer,
                                      screenId: 1,
                                    )));
                          },
                          child: const Icon(
                            Icons.shopping_cart_outlined,
                            size: 25,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
          resizeToAvoidBottomInset: true,
          body: _isDataLoaded
              ? _favoritesList != null && _favoritesList!.favItems.isNotEmpty
                  ? _productListWidget()
                  : Center(
                      child: Text(
                        AppLocalizations.of(context)!.txt_nothing_is_yet_to_see_here,
                        style: Theme.of(context).primaryTextTheme.titleSmall,
                      ),
                    )
              : _shimmer())),
    );
  }


  @override
  void initState() {
    super.initState();
    if (global.user!.id == null) {
      Future.delayed(Duration.zero, () {
        if(!mounted) return;
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => SignInScreen(
                    a: widget.analytics,
                    o: widget.observer,
                  )),
        );
      });
    }
    _init();
  }

  Future<bool> _addToCart(int quantity, int? id) async {
    bool isSucessfullyAdded = false;
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        await apiHelper!.addToCart(global.user!.id, id, quantity).then((result) {
          if (result != null) {
            if (result.status == "1") {
              isSucessfullyAdded = true;
              setState(() {});
            } else {}
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
      return isSucessfullyAdded;
    } catch (e) {
      debugPrint("Exception - favoritesScreen.dart - _addToCart():$e");
      return isSucessfullyAdded;
    }
  }

  Future<bool> _delFromCart(int? id) async {
    bool isDeletedSuccessfully = false;
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        await apiHelper!.delFromCart(global.user!.id, id).then((result) {
          if (result != null) {
            if (result.status == "1" && global.user?.cartCount != null) {
              isDeletedSuccessfully = true;
              global.user!.cartCount = global.user!.cartCount! - 1;
              setState(() {});
            } else {}
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
      return isDeletedSuccessfully;
    } catch (e) {
      debugPrint("Exception - favorites_screen.dart - _delFromCart():$e");
      return isDeletedSuccessfully;
    }
  }

  _getFavoriteList() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        await apiHelper!.getFavoriteList(global.user!.id).then((result) {
          if (result != null) {
            if (result.status == "1") {
              _favoritesList = result.recordList;
              _isDataLoaded = true;
            } else if (result.status == "0") {
              _favoritesList = null;
              _isDataLoaded = true;
            }
            setState(() {});
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
    } catch (e) {
      debugPrint("Exception - favoritesScreen.dart - _getFavoriteList():$e");
    }
  }

  _init() async {
    await _getFavoriteList();
  }

  List<Widget> _productList() {
    List<Widget> productList = [];
    for (int index = 0; index < _favoritesList!.favItems.length; index++) {
      productList.add(InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => ProductDetailScreen(
                      _favoritesList!.favItems[index].id,
                      a: widget.analytics,
                      o: widget.observer,
                      isShowGoCartBtn: _favoritesList!.favItems[index].cartQty != null && _favoritesList!.favItems[index].cartQty! > 0 ? true : false,
                    )),
          );
        },
        child: SizedBox(
          height: (MediaQuery.of(context).size.width / 1.93),
          width: (MediaQuery.of(context).size.width / 2) - 17,
          child: Card(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              _favoritesList!.favItems[index].productImage != null
                  ? CachedNetworkImage(
                      imageUrl: global.baseUrlForImage + _favoritesList!.favItems[index].productImage!,
                      imageBuilder: (context, imageProvider) => Container(
                        height: (((MediaQuery.of(context).size.width / 2) - 15) * 1.4) * 0.55,
                        margin: const EdgeInsets.only(bottom: 5),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), image: DecorationImage(fit: BoxFit.cover, image: imageProvider)),
                        alignment: Alignment.topRight,
                        child: IconButton(
                            onPressed: () async {
                              bool isFav = await (_removeFromFavorites(_favoritesList!.favItems[index].id) as FutureOr<bool>);
                              if (isFav) {
                                _favoritesList!.favItems.removeAt(index);
                              }
                              setState(() {});
                            },
                            icon: const Icon(
                              Icons.favorite,
                              color: Color(0xFFFA692C),
                            )),
                      ),
                      placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    )
                  : Container(
                      height: (((MediaQuery.of(context).size.width / 2) - 15) * 1.4) * 0.72,
                      margin: const EdgeInsets.only(bottom: 5),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        AppLocalizations.of(context)!.lbl_no_image,
                        style: Theme.of(context).primaryTextTheme.titleMedium,
                      )),
              SizedBox(
                height: 20,
                child: Padding(
                  padding: const EdgeInsets.only(left: 6, right: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 100,
                        child: Text(
                          '${_favoritesList!.favItems[index].productName}',
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).primaryTextTheme.displaySmall,
                        ),
                      ),
                      Text('${global.currency.currencySign}${_favoritesList!.favItems[index].price}', style: Theme.of(context).primaryTextTheme.titleMedium)
                    ],
                  ),
                ),
              ),
              _favoritesList!.favItems[index].cartQty == null || (_favoritesList!.favItems[index].cartQty != null && _favoritesList!.favItems[index].cartQty == 0)
                  ? GestureDetector(
                      onTap: () async {
                        showOnlyLoaderDialog();

                        int qty = 1;
                        bool isSuccess = await _addToCart(qty, _favoritesList!.favItems[index].id);
                        if (isSuccess && global.user?.cartCount != null) {
                          _favoritesList!.favItems[index].cartQty = 1;
                          global.user!.cartCount = global.user!.cartCount! + 1;
                        }
                        hideLoader();
                        setState(() {});
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.shopping_cart_outlined,
                              color: Theme.of(context).floatingActionButtonTheme.backgroundColor,
                              size: 16,
                            ),
                            Text(AppLocalizations.of(context)!.lbl_add_to_cart, style: Theme.of(context).primaryTextTheme.titleMedium)
                          ],
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                              height: 20,
                              width: 20,
                              child: TextButton(
                                onPressed: () async {
                                  showOnlyLoaderDialog();
                                  if (_favoritesList!.favItems[index].cartQty == 1) {
                                    bool isSuccess = await _delFromCart(_favoritesList!.favItems[index].id);
                                    if (isSuccess) {
                                      _favoritesList!.favItems[index].cartQty = 0;
                                    }
                                    _favoritesList!.favItems[index].cartQty = 0;
                                  } else {
                                    int qty = _favoritesList!.favItems[index].cartQty! - 1;

                                    bool isSuccess = await _addToCart(qty, _favoritesList!.favItems[index].id);
                                    if (isSuccess && _favoritesList?.favItems[index].cartQty != null) {
                                      _favoritesList!.favItems[index].cartQty = _favoritesList!.favItems[index].cartQty! - 1;
                                    }
                                  }
                                  hideLoader();
                                  setState(() {});
                                },
                                child: _favoritesList!.favItems[index].cartQty == 1
                                    ? const Icon(
                                        Icons.delete, color: Colors.white,
                                        size: 11,
                                      )
                                    : const Icon(
                                        FontAwesomeIcons.minus, color: Colors.white,
                                        size: 11,
                                      ),
                              )),
                          const SizedBox(
                            width: 5,
                          ),
                          Container(
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                              border: Border.all(width: 1.0, color: Theme.of(context).primaryColor),
                              borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                            ),
                            child: Center(
                              child: Text(
                                "${_favoritesList!.favItems[index].cartQty}",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Theme.of(context).primaryColor),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          SizedBox(
                              height: 20,
                              width: 20,
                              child: TextButton(
                                onPressed: () async {
                                  showOnlyLoaderDialog();
                                  int qty = _favoritesList!.favItems[index].cartQty! + 1;

                                  bool isSuccess = await _addToCart(qty, _favoritesList!.favItems[index].id);
                                  if (isSuccess && _favoritesList?.favItems[index].cartQty != null) {
                                    _favoritesList!.favItems[index].cartQty = _favoritesList!.favItems[index].cartQty! + 1;
                                  }
                                  hideLoader();

                                  setState(() {});
                                },
                                child: const Icon(
                                  FontAwesomeIcons.plus,
                                   color: Colors.white,
                                  size: 10,
                                ),
                              ))
                        ],
                      ),
                    )
            ]),
          ),
        ),
      ));
    }
    return productList;
  }

  _productListWidget() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(bottom: 10, left: _favoritesList!.favItems.length == 1 ? 15 : 5, right: 5, top: 15),
        child: Align(
          alignment: _favoritesList!.favItems.length == 1
              ? global.isRTL
                  ? Alignment.centerRight
                  : Alignment.centerLeft
              : Alignment.center,
          child: Wrap(crossAxisAlignment: WrapCrossAlignment.center, alignment: WrapAlignment.start, runAlignment: WrapAlignment.center, spacing: 10, runSpacing: 12, children: _productList()),
        ),
      ),
    );
  }

  Future<bool?> _removeFromFavorites(int? id) async {
    bool isFav = false;
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        await apiHelper!.addToFavorite(global.user!.id, id).then((result) {
          if (result != null) {
            if (result.status == "0") {
              isFav = true;

              setState(() {});
            }
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
      return isFav;
    } catch (e) {
      debugPrint("Exception - favoritesScreen.dart - _removeFromFavorites():$e");
      return null;
    }
  }

  Widget _shimmer() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: GridView.count(
            crossAxisSpacing: 8,
            crossAxisCount: 2,
            children: List.generate(
                8,
                (index) => const SizedBox(
                      child: Card(margin: EdgeInsets.only(top: 5, bottom: 5, left: 5)),
                    )),
          )),
    );
  }
}
