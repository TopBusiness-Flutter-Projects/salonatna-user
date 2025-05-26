import 'package:app/models/businessLayer/base_route.dart';
import 'package:app/models/businessLayer/global.dart' as global;
import 'package:app/models/product_model.dart';
import 'package:app/screens/cart_screen.dart';
import 'package:app/screens/product_detail_screen.dart';
import 'package:app/screens/search_screen.dart';
import 'package:app/screens/sign_in_screen.dart';
import 'package:badges/badges.dart' as badges;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shimmer/shimmer.dart';

class ProductListScreen extends BaseRoute {
  const ProductListScreen({super.key, super.a, super.o}) : super(r: 'ProductListScreen');

  @override
  BaseRouteState<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends BaseRouteState<ProductListScreen> {
  final List<Product> _productList = [];
  bool _isDataLoaded = false;
  GlobalKey<ScaffoldState>? _scaffoldKey;
  bool? _isFav;
  int? selectedProductId;
  bool _isRecordPending = true;
  bool _isMoreDataLoaded = false;
  final ScrollController _scrollController = ScrollController();
  int pageNumber = 0;

  _ProductListScreenState() : super();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              AppLocalizations.of(context)!.lbl_products,
              style: Theme.of(context).appBarTheme.titleTextStyle,
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => SearchScreen(
                                2,
                                a: widget.analytics,
                                o: widget.observer,
                              )),
                    );
                  },
                  icon: const Icon(Icons.search)),
              global.user?.id == null
                  ? const SizedBox()
                  : _isDataLoaded
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
                              padding: const EdgeInsets.all(7),
                              badgeColor: Theme.of(context).primaryColor,
                            ),
                            showBadge: true,
                            badgeContent: Text(
                              '${global.user?.cartCount}',
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
              ? _productList.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: _productListWidget(),
                    )
                  : Center(
                      child: Text(
                        AppLocalizations.of(context)!.txt_product_will_shown_here,
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

  List<Widget> _addProductList() {
    List<Widget> productList = [];
    for (int index = 0; index < _productList.length; index++) {
      productList.add(InkWell(
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
                      isShowGoCartBtn: _productList[index].cartQty != null && (_productList[index].cartQty ?? 0) > 0 ? true : false,
                    )),
          );
        },
        child: SizedBox(
          height: (MediaQuery.of(context).size.width / 1.77),
          width: (MediaQuery.of(context).size.width / 2) - 17,
          child: Card(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              _productList[index].productImage != null
                  ? CachedNetworkImage(
                      imageUrl: global.baseUrlForImage + _productList[index].productImage!,
                      imageBuilder: (context, imageProvider) => Container(
                        height: (((MediaQuery.of(context).size.width / 2) - 15) * 1.4) * 0.55,
                        margin: const EdgeInsets.only(bottom: 5),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), image: DecorationImage(fit: BoxFit.cover, image: imageProvider)),
                        alignment: Alignment.topRight,
                        child: IconButton(
                            onPressed: () async {
                              if (global.user?.id == null) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => SignInScreen(
                                            a: widget.analytics,
                                            o: widget.observer,
                                          )),
                                );
                              } else {
                                _isFav = await _addToFavorite(_productList[index].id);
                                if (_isFav ?? false) {
                                  _productList[index].isFavourite = !_productList[index].isFavourite!;
                                }
                              }
                              setState(() {});
                            },
                            icon: Icon(
                              _productList[index].isFavourite! ? Icons.favorite : Icons.favorite_outline,
                              color: _productList[index].isFavourite! ? const Color(0xFFFA692C) : Colors.white,
                            )),
                      ),
                      placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    )
                  : Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        AppLocalizations.of(context)!.lbl_no_image,
                        style: Theme.of(context).primaryTextTheme.titleMedium,
                      )),
              SizedBox(
                height: 20,
                child: Padding(
                  padding: const EdgeInsets.only(left: 6, right: 6),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${_productList[index].productName}',
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).primaryTextTheme.displaySmall,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
                child: Padding(
                  padding: const EdgeInsets.only(left: 6, right: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${_productList[index].quantity}',
                        style: Theme.of(context).primaryTextTheme.titleMedium,
                      ),
                      Text('${global.currency.currencySign} ${_productList[index].price}', style: Theme.of(context).primaryTextTheme.titleMedium)
                    ],
                  ),
                ),
              ),
              _productList[index].cartQty == null || (_productList[index].cartQty != null && _productList[index].cartQty == 0)
                  ? GestureDetector(
                      onTap: () async {
                        if (global.user!.id == null) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => SignInScreen(
                                      a: widget.analytics,
                                      o: widget.observer,
                                    )),
                          );
                        } else {
                          showOnlyLoaderDialog();

                          int qty = 1;

                          bool isSuccess = await _addToCart(qty, _productList[index].id);
                          if (isSuccess) {
                            _productList[index].cartQty = 1;
                            if (global.user != null && global.user?.cartCount != null) {
                              global.user?.cartCount = global.user!.cartCount! + 1;
                            }
                          }
                          hideLoader();
                          setState(() {});
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
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
                                  if (_productList[index].cartQty == 1) {
                                    bool isSuccess = await _delFromCart(_productList[index].id);
                                    if (isSuccess) {
                                      _productList[index].cartQty = 0;
                                    }
                                    _productList[index].cartQty = 0;
                                  } else {
                                    int qty = _productList[index].cartQty! - 1;

                                    bool isSuccess = await _addToCart(qty, _productList[index].id);
                                    if (isSuccess && _productList[index].cartQty != null) {
                                      _productList[index].cartQty = _productList[index].cartQty! - 1;
                                    }
                                  }
                                  hideLoader();
                                  setState(() {});
                                },
                                child: _productList[index].cartQty == 1
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
                              border: Border.all(width: 1.0, color: const Color(0xFFFA692C)),
                              borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                            ),
                            child: Center(
                              child: Text(
                                "${_productList[index].cartQty}",
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Color(0xFFFA692C)),
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
                                  if (_productList[index].cartQty != null) {
                                    int qty = _productList[index].cartQty! +
                                        1;

                                    bool isSuccess = await _addToCart(
                                        qty, _productList[index].id);
                                    if (isSuccess) {
                                      _productList[index].cartQty = _productList[index].cartQty! + 1;
                                    }
                                    hideLoader();

                                    setState(() {});
                                  }
                                },
                                child: const Icon(
                                  FontAwesomeIcons.plus, color: Colors.white,
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
      debugPrint("Exception - product_list_screen.dart - _addToCart():$e");
      return isSucessfullyAdded;
    }
  }

  Future<bool?> _addToFavorite(int? id) async {
    bool isFav = false;
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        await apiHelper!.addToFavorite(global.user!.id, id).then((result) {
          if (result != null) {
            if (result.status == "1") {
              isFav = true;

              setState(() {});
            } else if (result.status == "0") {
              isFav = true;
            }
            setState(() {});
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
      return isFav;
    } catch (e) {
      debugPrint("Exception - product_list_screen.dart - _addToFavorite():$e");
      return null;
    }
  }

  Future<bool> _delFromCart(int? id) async {
    bool isDeletedSuccessfully = false;
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        await apiHelper!.delFromCart(global.user!.id, id).then((result) {
          if (result != null) {
            if (result.status == "1") {
              isDeletedSuccessfully = true;
              if (global.user?.cartCount != null) {
                global.user?.cartCount = global.user!.cartCount! - 1;
                setState(() {});
              }
            } else {}
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
      return isDeletedSuccessfully;
    } catch (e) {
      debugPrint("Exception - product_list_screen.dart - _delFromCart():$e");
      return isDeletedSuccessfully;
    }
  }

  _getProducts() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        if (_isRecordPending) {
          setState(() {
            _isMoreDataLoaded = true;
          });

          if (_productList.isEmpty) {
            pageNumber = 1;
          } else {
            pageNumber++;
          }
          await apiHelper!.getProducts(global.lat, global.lng, pageNumber, '').then((result) {
            if (result != null) {
              if (result.status == "1") {
                List<Product> tList = result.recordList;

                if (tList.isEmpty) {
                  _isRecordPending = false;
                }

                _productList.addAll(tList);
                setState(() {
                  _isMoreDataLoaded = false;
                });
              }
            }
          });
        }
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
    } catch (e) {
      debugPrint("Exception - product_list_screen.dart - _getProducts():$e");
    }
  }

  _init() async {
    try {
      await _getProducts();
      _scrollController.addListener(() async {
        if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !_isMoreDataLoaded) {
          setState(() {
            _isMoreDataLoaded = true;
          });
          await _getProducts();
          setState(() {
            _isMoreDataLoaded = false;
          });
        }
      });
      _isDataLoaded = true;
      setState(() {});
    } catch (e) {
      debugPrint("Exception - product_list_screen.dart - _init():$e");
    }
  }

  _productListWidget() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10, left: 5, right: 5),
        child: Wrap(spacing: 12, runSpacing: 12, children: _addProductList()),
      ),
    );
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
