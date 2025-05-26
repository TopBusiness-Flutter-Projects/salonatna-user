import 'package:app/models/businessLayer/base_route.dart';
import 'package:app/models/businessLayer/global.dart' as global;
import 'package:app/models/cart_model.dart';
import 'package:app/screens/payment_gateways_screen.dart';
import 'package:app/screens/product_list_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shimmer/shimmer.dart';

class CartScreen extends BaseRoute {
  final int? screenId;
  const CartScreen({super.key, super.a, super.o, this.screenId}) : super(r: 'CartScreen');
  @override
  BaseRouteState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends BaseRouteState<CartScreen> {
  GlobalKey<ScaffoldState>? _scaffoldKey;
  Cart? _cartList;
  Cart? _cartItems;
  bool _isDataLoaded = false;
  _CartScreenState() : super();

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: true,
        child: Scaffold(
            appBar: AppBar(
              title: RichText(
                text: TextSpan(text: AppLocalizations.of(context)!.lbl_my_cart, style: Theme.of(context).appBarTheme.titleTextStyle, children: [TextSpan(text: AppLocalizations.of(context)!.txt_store_pick_up_only, style: Theme.of(context).primaryTextTheme.titleMedium)]),
              ),
              actions: [
                _isDataLoaded
                    ? _cartList != null && _cartList!.cartItems.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              _delConfirmationDialog();
                            },
                            icon: const Icon(Icons.delete_outline))
                        : const SizedBox()
                    : const SizedBox()
              ],
            ),
            body: _isDataLoaded
                ? _cartList != null && _cartList!.cartItems.isNotEmpty
                    ? SafeArea(
                      child: ListView.builder(
                          itemCount: _cartList!.cartItems.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8, bottom: 8, left: 13, right: 13),
                              child: Card(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _cartList!.cartItems[index].productImage != null
                                        ? CachedNetworkImage(
                                            imageUrl: global.baseUrlForImage + _cartList!.cartItems[index].productImage!,
                                            imageBuilder: (context, imageProvider) => Card(
                                              child: Container(
                                                height: 85,
                                                width: 100,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(10),
                                                    image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.cover,
                                                    )),
                                              ),
                                            ),
                                            placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                            errorWidget: (context, url, error) => const Icon(Icons.error),
                                          )
                                        : Card(
                                            child: Container(
                                              height: 85,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  AppLocalizations.of(context)!.lbl_no_image,
                                                  style: Theme.of(context).primaryTextTheme.titleMedium,
                                                ),
                                              ),
                                            ),
                                          ),
                                    Expanded(
                                      child: Padding(
                                        padding: global.isRTL ? const EdgeInsets.only(right: 18, top: 10) : const EdgeInsets.only(left: 18, top: 10),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              '${_cartList!.cartItems[index].productName}',
                                              style: Theme.of(context).primaryTextTheme.bodyLarge,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              '${global.currency.currencySign}${_cartList!.cartItems[index].price}  ',
                                              style: Theme.of(context).primaryTextTheme.titleLarge,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: global.isRTL ? const EdgeInsets.only(left: 8) : const EdgeInsets.only(right: 8),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(
                                              height: 25,
                                              width: 25,
                                              child: TextButton(
                                                onPressed: () async {
                                                  if (_cartList!.cartItems[index].qty == 1) {
                                                    _delConfirmationDialog(index: index, callId: 1);
                                                  } else {
                                                    showOnlyLoaderDialog();
                                                    int qty = _cartList!.cartItems[index].qty! - 1;
                                                    bool isSuccess = await _addToCart(qty, _cartList!.cartItems[index].productId);
                                                    if (isSuccess && _cartList?.cartItems[index].qty != null) {
                                                      _cartList!.cartItems[index].qty = _cartList!.cartItems[index].qty! - 1;
                                                    }
                                                    hideLoader();
                                                  }
                                                  setState(() {});
                                                },
                                                child: _cartList!.cartItems[index].qty == 1
                                                    ? const Icon(
                                                        Icons.delete,
                                                        color: Colors.white,
                                                        size: 15,
                                                      )
                                                    : const Icon(
                                                        FontAwesomeIcons.minus, color: Colors.white,
                                                        size: 13,
                                                      ),
                                              )),
                                          const SizedBox(
                                            width: 2,
                                          ),
                                          Container(
                                            width: 25,
                                            height: 25,
                                            decoration: BoxDecoration(
                                              border: Border.all(width: 1.0, color: const Color(0xFFFA692C)),
                                              borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                                            ),
                                            child: Center(
                                              child: Text(
                                                "${_cartList!.cartItems[index].qty}",
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(color: Color(0xFFFA692C), fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 2,
                                          ),
                                          SizedBox(
                                              height: 25,
                                              width: 25,
                                              child: TextButton(
                                                onPressed: () async {
                                                  showOnlyLoaderDialog();
                                                  int qty = _cartList!.cartItems[index].qty! + 1;
                                                  bool isSuccess = await _addToCart(qty, _cartList!.cartItems[index].productId);
                                                  if (isSuccess && _cartList?.cartItems[index].qty != null) {
                                                    _cartList!.cartItems[index].qty = _cartList!.cartItems[index].qty! + 1;
                                                  }
                                                  hideLoader();
                                                  setState(() {});
                                                },
                                                child: const Icon(
                                                  FontAwesomeIcons.plus,
                                                   color: Colors.white,
                                                  size: 15,
                                                ),
                                              ))
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                    )
                    : Center(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.shopping_cart_outlined,
                                color: Theme.of(context).floatingActionButtonTheme.backgroundColor,
                                size: 150,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 25),
                                child: Text(
                                  AppLocalizations.of(context)!.txt_your_cart_is_empty,
                                  style: Theme.of(context).appBarTheme.titleTextStyle,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(
                                  AppLocalizations.of(context)!.txt_shop_for_some_product_in_order_to_purchase_them,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).primaryTextTheme.titleMedium,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                : _shimmer(),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: BottomAppBar(
                  color: const Color(0xFF171D2C),
                  child: SizedBox(
                    height: 60,
                    width: double.infinity,
                    child: _isDataLoaded
                        ? _cartList != null && _cartList!.cartItems.isNotEmpty
                            ? ListTile(
                                tileColor: Colors.transparent,
                                title: RichText(
                                    text: TextSpan(style: Theme.of(context).primaryTextTheme.titleMedium,
                                        children: [
                                          const TextSpan(text: 'Total Amount  '),
                                          TextSpan(text: '${global.currency.currencySign}${_cartList!.totalPrice}', style: Theme.of(context).primaryTextTheme.headlineSmall)
                                        ]
                                    )
                                ),
                                trailing: ElevatedButton(
                                  onPressed: () async {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) => PaymentGatewayScreen(cartList: _cartList, a: widget.analytics, o: widget.observer)),
                                    );
                                  },
                                  child: Text(AppLocalizations.of(context)!.lbl_checkout,
                                      style: Theme.of(context).textTheme.labelMedium),
                                ),
                              )
                            : Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) => ProductListScreen(a: widget.analytics, o: widget.observer)),
                                      );
                                    },
                                    child: Text(AppLocalizations.of(context)!.lbl_shop_now,
                                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              )
                        : const SizedBox(),
                  )),
            )));
  }


  @override
  void initState() {
    super.initState();
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
              _cartItems = result.recordList;
              _cartList!.totalPrice = _cartItems!.totalPrice;
              setState(() {});
            } else {}
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
      return isSucessfullyAdded;
    } catch (e) {
      debugPrint("Exception - cart_screen.dart - _addToCart():$e");
      return isSucessfullyAdded;
    }
  }

  Future<bool> _clearCart() async {
    bool isCartCleared = false;
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        await apiHelper!.clearCart(global.user!.id).then((result) {
          if (result != null) {
            if (result.status == "1") {
              isCartCleared = true;
              showSnackBar(key: _scaffoldKey, snackBarMessage: '${result.message}');

              setState(() {});
            } else {
              showSnackBar(key: _scaffoldKey, snackBarMessage: '${result.message}');
            }
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
      return isCartCleared;
    } catch (e) {
      debugPrint("Exception - cart_screen.dart - _clearCart():$e");
      return isCartCleared;
    }
  }

  _delConfirmationDialog({int? index, int? callId}) async {
    try {
      showCupertinoDialog(
          context: context,
          builder: (BuildContext context) {
            return Theme(
              data: ThemeData(dialogBackgroundColor: Colors.white),
              child: CupertinoAlertDialog(
                title: Text(
                  callId == 1 ? AppLocalizations.of(context)!.txt_remove_product_from_cart : AppLocalizations.of(context)!.lbl_clear_cart,
                ),
                content: Text(
                  callId == 1 ? AppLocalizations.of(context)!.txt_are_you_sure_you_want_to_remove_this_product : AppLocalizations.of(context)!.txt_are_you_sure_you_want_to_clear_this_product_from_cart,
                ),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text(
                      AppLocalizations.of(context)!.lbl_no,
                      style: const TextStyle(color: Colors.red),
                    ),
                    onPressed: () {
                      // Dismiss the dialog but don't
                      // dismiss the swiped item
                      return Navigator.of(context).pop(false);
                    },
                  ),
                  CupertinoDialogAction(
                    child: Text(AppLocalizations.of(context)!.lbl_yes),
                    onPressed: () async {
                      showOnlyLoaderDialog();
                      if (callId == 1) {
                        bool isSuccess = await _delFromCart(_cartList!.cartItems[index!].productId);

                        if (isSuccess && global.user?.cartCount != null) {
                          _cartList!.cartItems[index].qty = 0;
                          _cartList!.cartItems.removeAt(index);
                          global.user?.cartCount = global.user!.cartCount! - 1;
                        }
                      } else {
                        bool isSuccess = await _clearCart();
                        if (isSuccess) {
                          _cartList!.cartItems.clear();
                        }
                      }

                      hideLoader();
                      if(!context.mounted) return;
                      Navigator.of(context).pop();
                      setState(() {});
                    },
                  ),
                ],
              ),
            );
          });
    } catch (e) {
      debugPrint('Exception - cart_screen.dart - _delConfirmationDialog(): $e');
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
              setState(() {});
            } else {}
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
      return isDeletedSuccessfully;
    } catch (e) {
      debugPrint("Exception - cart_screen.dart - _delFromCart():$e");
      return isDeletedSuccessfully;
    }
  }

  _getCartItems() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        await apiHelper!.getCartItems(global.user!.id).then((result) {
          if (result != null) {
            if (result.status == "1") {
              _cartList = result.recordList;
            } else if (result.status == "0") {
              _cartList = null;
            }
            _isDataLoaded = true;
            setState(() {});
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
    } catch (e) {
      debugPrint("Exception - cart_screen.dart - _getCartItems():$e");
    }
  }

  _init() async {
    await _getCartItems();
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
}
