import 'dart:io';

import 'package:app/models/businessLayer/base_route.dart';
import 'package:app/models/businessLayer/global.dart' as global;
import 'package:app/models/product_detail_model.dart';
import 'package:app/screens/cart_screen.dart';
import 'package:app/screens/sign_in_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:shimmer/shimmer.dart';

class ProductDetailScreen extends BaseRoute {
  final bool? isShowGoCartBtn;
  final int? productId;

  const ProductDetailScreen(this.productId, {super.key, super.a, super.o, this.isShowGoCartBtn}) : super(r: 'ProductDetailScreen');

  @override
  BaseRouteState<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends BaseRouteState<ProductDetailScreen> {
  GlobalKey<ScaffoldState>? _scaffoldKey;

  ProductDetail? _productDetail;
  bool _isDataLoaded = false;

  _ProductDetailScreenState() : super();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: Scaffold(
          extendBodyBehindAppBar: true,
          key: _scaffoldKey,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading: const BackButton(
              color: Colors.white,
            ),
          ),
          body: _isDataLoaded
              ? SingleChildScrollView(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                    CachedNetworkImage(
                      imageUrl: global.baseUrlForImage + _productDetail!.productImage!,
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                        height: MediaQuery.of(context).size.height * 0.24,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(height: 60),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 6.0),
                                  child: IconButton(
                                      onPressed: () async {
                                        if (global.user!.id == null) {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) => SignInScreen(
                                                      a: widget.analytics,
                                                      o: widget.observer,
                                                    )),
                                          );
                                        } else {
                                          bool? isFav;
                                          isFav = await _addToFavorite(_productDetail!.id);
                                          if (isFav!) {
                                            _productDetail!.isFavourite = !_productDetail!.isFavourite;
                                          }
                                        }
                                        setState(() {});
                                      },
                                      icon: Icon(
                                        _productDetail!.isFavourite ? Icons.favorite : Icons.favorite_outline,
                                        color: _productDetail!.isFavourite ? const Color(0xFFFA692C) : Colors.white,
                                      )),
                                )
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 8, bottom: 4, top: 4),
                              color: Colors.black.withOpacity(0.5),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "${_productDetail?.productName}",
                                style: Theme.of(context).primaryTextTheme.displayLarge,
                              ),
                            ),
                          ],
                        ),
                      ),
                      placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => Container(
                        decoration: const BoxDecoration(),
                        height: MediaQuery.of(context).size.height * 0.24,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const BackButton(
                                  color: Colors.white,
                                ),
                                IconButton(
                                    onPressed: () async {
                                      if (global.user!.id == null) {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) => SignInScreen(
                                                    a: widget.analytics,
                                                    o: widget.observer,
                                                  )),
                                        );
                                      } else {
                                        bool? isFav;
                                        isFav = await _addToFavorite(_productDetail!.id);
                                        if (isFav!) {
                                          _productDetail!.isFavourite = !_productDetail!.isFavourite;
                                        }
                                      }
                                      setState(() {});
                                    },
                                    icon: Icon(
                                      _productDetail!.isFavourite ? Icons.favorite : Icons.favorite_outline,
                                      color: _productDetail!.isFavourite ? const Color(0xFFFA692C) : Colors.white,
                                    ))
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 8, bottom: 4, top: 4),
                              color: Colors.black.withOpacity(0.5),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "${_productDetail!.productName}",
                                style: Theme.of(context).primaryTextTheme.displayLarge,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                      child: Text(AppLocalizations.of(context)!.lbl_description, style: Theme.of(context).primaryTextTheme.titleLarge),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(left: 10, top: 5, right: 10),
                        child: Html(
                          data: _productDetail?.description ?? '',
                          style: {
                            'body': Style(textAlign: TextAlign.justify),
                          },
                        )),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                      child: Text(AppLocalizations.of(context)!.lbl_price, style: Theme.of(context).primaryTextTheme.titleLarge),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, top: 2, right: 10),
                      child: Text(
                        '${global.currency.currencySign}${_productDetail!.price}',
                        style: Theme.of(context).primaryTextTheme.titleMedium,
                      ),
                    ),
                  ]),
                )
              : _shimmer(),
          bottomNavigationBar: Padding(
            padding: EdgeInsets.only(top: 5, bottom: Platform.isIOS ? 20 : 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () async {
                      global.user!.id == null
                          ? Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => SignInScreen(
                                        a: widget.analytics,
                                        o: widget.observer,
                                      )),
                            )
                          : widget.isShowGoCartBtn!
                              ? Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => CartScreen(a: widget.analytics, o: widget.observer)),
                                )
                              : await _addToCart(1, _productDetail!.id);
                    },
                    child: Row(
                      children: [
                        const Icon(
                          Icons.shopping_cart_outlined,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Text(widget.isShowGoCartBtn! ? AppLocalizations.of(context)!.lbl_go_to_cart : AppLocalizations.of(context)!.lbl_add_to_cart,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    )),
              ],
            ),
          )),
    );
  }


  @override
  void initState() {
    super.initState();
    _init();
  }

  _addToCart(int quantity, int? id) async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        showOnlyLoaderDialog();
        await apiHelper!.addToCart(global.user!.id, id, quantity).then((result) {
          if (result != null) {
            if (result.status == "1") {
              hideLoader();
              if(!mounted) return;
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => CartScreen(a: widget.analytics, o: widget.observer)),
              );
              setState(() {});
            } else {}
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
    } catch (e) {
      debugPrint("Exception - ProductListScreen.dart - _addToCart():$e");
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
      debugPrint("Exception - ProductListScreen.dart - _addToFavorite():$e");
      return null;
    }
  }

  _getProductDetails() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        await apiHelper!.getProductDetails(widget.productId).then((result) {
          if (result != null) {
            if (result.status == "1") {
              _productDetail = result.recordList;
            } else {
              showSnackBar(key: _scaffoldKey, snackBarMessage: '${result.message}');
            }
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
    } catch (e) {
      debugPrint("Exception - product_detail_screen.dart - _getProductDetails():$e");
    }
  }

  _init() async {
    try {
      await _getProductDetails();
      _isDataLoaded = true;

      setState(() {});
    } catch (e) {
      debugPrint("Exception - product_detail_screen.dart - _init():$e");
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
}
