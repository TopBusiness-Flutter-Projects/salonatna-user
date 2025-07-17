import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:app/models/book_now_model.dart';
import 'package:app/models/businessLayer/base_route.dart';
import 'package:app/models/businessLayer/business_rule.dart';
import 'package:app/models/businessLayer/global.dart' as global;
import 'package:app/models/card_model.dart';
import 'package:app/models/cart_model.dart';
import 'package:app/models/payment_gateway_model.dart';
import 'package:app/models/product_cart_checkout_model.dart';
import 'package:app/screens/booking_confirmation_screen.dart';
import 'package:app/screens/stripe_payment_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shimmer/shimmer.dart';

import 'payment_screen.dart';

class PaymentGatewayScreen extends BaseRoute {
  final int? screenId;
  final Cart? cartList;
  final BookNow? bookNowDetails;
  const PaymentGatewayScreen(
      {super.key,
      super.a,
      super.o,
      this.screenId,
      this.cartList,
      this.bookNowDetails})
      : super(r: 'PaymentGatewayScreen');
  @override
  BaseRouteState<PaymentGatewayScreen> createState() =>
      _PaymentGatewayScreenState();
}

class _PaymentGatewayScreenState extends BaseRouteState<PaymentGatewayScreen> {
  GlobalKey<ScaffoldState>? _scaffoldKey;
  PaymentGateway? _paymentGatewayList;
  late Razorpay _razorpay;
  bool _isDataLoaded = false;
  bool _isCOD = false;
  var payPlugin = PaystackPlugin();
  final TextEditingController _cCardNumber = TextEditingController();
  final TextEditingController _cExpiry = TextEditingController();
  final TextEditingController _cCvv = TextEditingController();
  final TextEditingController _cName = TextEditingController();

  int? _month;
  int? _year;
  String? number;
  CardType? cardType;
  final _formKey = GlobalKey<FormState>();
  final bool _autovalidate = false;

  bool isLoading = false;

  _PaymentGatewayScreenState() : super();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: Scaffold(
          key: _scaffoldKey,
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text(
              AppLocalizations.of(context)!.lbl_payment_method,
              style: Theme.of(context).appBarTheme.titleTextStyle,
            ),
          ),
          body:
              //  _isDataLoaded
              //     ?
              Column(
            children: [
              ListTile(
                title: Text(
                  AppLocalizations.of(context)!.txt_pay_on_delivery,
                  style: Theme.of(context).primaryTextTheme.headlineSmall,
                ),
              ),
              Divider(
                color: Colors.grey[300],
              ),
              GestureDetector(
                onTap: () {
                  _isCOD = true;
                  setState(() {});
                },
                child: ListTile(
                  tileColor: _isCOD
                      ? Theme.of(context).primaryColorLight.withOpacity(0.3)
                      : Colors.transparent,
                  leading: Icon(
                    MdiIcons.cash,
                    color: Colors.green[500],
                  ),
                  title: Text(AppLocalizations.of(context)!.lbl_cash),
                  subtitle: Text(AppLocalizations.of(context)!
                      .txt_pay_through_cash_at_the_salon),
                ),
              ),
              Divider(
                color: Colors.grey[300],
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.lbl_other_methods,
                    style: Theme.of(context).primaryTextTheme.headlineSmall),
              ),
              Divider(
                color: Colors.grey[300],
              ),

              GestureDetector(
                onTap: () {
                  payWithNewCard();
                },
                child: ListTile(
                  leading: const Icon(FontAwesomeIcons.creditCard),
                  title: Text(AppLocalizations.of(context)!.lbl_paymob),
                ),
              ),

              // _paymentGatewayList!.razorpay!.razorpayStatus == 'Yes'
              //     ? GestureDetector(
              //         onTap: () {
              //           showOnlyLoaderDialog();
              //           openCheckout();
              //         },
              //         child: ListTile(
              //           leading: Icon(MdiIcons.creditCard),
              //           title: Text(
              //               AppLocalizations.of(context)!.lbl_rezorpay),
              //         ),
              //       )
              //     : const SizedBox(),
              // _paymentGatewayList!.stripe!.stripeStatus == 'Yes'
              //     ? GestureDetector(
              //         onTap: () {
              //           _cardDialog();
              //         },
              //         child: ListTile(
              //           leading: const Icon(FontAwesomeIcons.stripe),
              //           title: Text(
              //               AppLocalizations.of(context)!.lbl_stripe),
              //         ),
              //       )
              //     : const SizedBox(),
              // _paymentGatewayList!.paystack!.payStackStatus == 'Yes'
              //     ? GestureDetector(
              //         onTap: () {
              //           _cardDialog(paymentCallId: 1);
              //         },
              //         child: ListTile(
              //           leading: Icon(MdiIcons.creditCard),
              //           title: Text(
              //               AppLocalizations.of(context)!.lbl_paystack),
              //         ),
              //       )
              //     : const SizedBox()
            ],
          )
          // : _shimmer()
          ,
          bottomNavigationBar: BottomAppBar(
              color: const Color(0xFF171D2C),
              child: SizedBox(
                  height: 60,
                  width: double.infinity,
                  child: ListTile(
                    title: RichText(
                        text: TextSpan(
                            style:
                                Theme.of(context).primaryTextTheme.titleMedium,
                            children: [
                          TextSpan(
                              text: AppLocalizations.of(context)!
                                  .lbl_total_amount),
                          TextSpan(
                              text: widget.screenId == 1
                                  ? '${global.currency.currencySign} ${widget.bookNowDetails?.remPrice ?? '0.00'}'
                                  : '${global.currency.currencySign} ${widget.cartList?.totalPrice ?? '0.00'}',
                              style: Theme.of(context)
                                  .primaryTextTheme
                                  .headlineSmall)
                        ])),
                    trailing: _isCOD
                        ? ElevatedButton(
                            onPressed: () {
                              widget.screenId == 1
                                  ? _checkOut()
                                  : _productCartCheckout();
                            },
                            child: Text(
                                AppLocalizations.of(context)!.lbl_checkout,
                                style: TextStyle(color: Colors.white)),
                          )
                        : const SizedBox(),
                  )))),
    );
  }

  Future<StripeTransactionResponse> payWithNewCard() async {
    try {
      showOnlyLoaderDialog();

      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        if (widget.screenId == 1) {
          BookNow bookNow = BookNow();
          bookNow.paymentStatus = "success";
          bookNow.paymentMethod = "paymob"; // COD , paymob
          bookNow.cartId = widget.bookNowDetails!.cartId;
          // bookNow.paymentId = paymentIntent["id"];
          bookNow.paymentGateway = "paymob"; // online , offline
          await apiHelper!.checkOut(bookNow).then((result) async {
            // hideLoader();
            if (result != null) {
              if (result.status == "1") {
                BookNow r = result.recordList;
                // if (!mounted) return;
                if (r.paymentUrl != null && r.orderId != null) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PaymentWebViewScreen(
                                a: widget.analytics,
                                o: widget.observer,
                                orderId: r.orderId ?? 0,
                                url: r.paymentUrl,
                              )));
                }
              } else {
                hideLoader();
                showSnackBar(
                    key: _scaffoldKey,
                    snackBarMessage: result.message.toString());
              }
            }
          }).catchError((e) {
            hideLoader();
            log("Exception - payment_gateways_screen.dart - payWithNewCard(): $e");
          });
        } else {
          await apiHelper!
              .productCartCheckout(
            global.user!.id,
            "success",
            "paymob",
          )
              .then((result) {
            if (result != null) {
              if (result.status == "1") {
                if (!mounted) return;
                ProductCartCheckout r = result.recordList;
                // if (!mounted) return;
                if (r.paymentUrl != null && r.orderId != null) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PaymentWebViewScreen(
                                a: widget.analytics,
                                o: widget.observer,
                                orderId: r.orderId ?? 0,
                                url: r.paymentUrl,
                              )));
                }
              }
            }
          });
        }
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
      if (!mounted) return StripeTransactionResponse(success: false);
      return StripeTransactionResponse(
          message: AppLocalizations.of(context)!.lbl_transaction_successful,
          success: true);
    } catch (e) {
      debugPrint(
          "Exception - payment_gateways_screen.dart - payWithNewCard(): $e");
      hideLoader();
      return StripeTransactionResponse(success: false);
    }
  }

  _checkOut() async {
    try {
      BookNow bookNow = BookNow();
      bookNow.paymentMethod = "COD";
      bookNow.cartId = widget.bookNowDetails!.cartId;
      bookNow.paymentGateway = "COD";

      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        await apiHelper!.checkOut(bookNow).then((result) async {
          if (result != null) {
            if (result.status == "1") {
              if (!mounted) return;
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => BookingConfirmationScreen(
                          a: widget.analytics,
                          o: widget.observer,
                          screenId: 2,
                        )),
              );

              setState(() {});
            } else {
              showSnackBar(
                  key: _scaffoldKey,
                  snackBarMessage: result.message.toString());
            }
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
    } catch (e) {
      debugPrint("Exception - payment_gateways_screen.dart - _checkOut():$e");
    }
  }

  _productCartCheckout() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        showOnlyLoaderDialog();
        await apiHelper!
            .productCartCheckout(
          global.user!.id,
          "COD",
          "COD",
        )
            .then((result) {
          if (result != null) {
            if (result.status == "1") {
              hideLoader();
              if (!mounted) return;
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => BookingConfirmationScreen(
                          a: widget.analytics,
                          o: widget.observer,
                          screenId: 1,
                        )),
              );
            } else {
              hideLoader();
              showSnackBar(
                  key: _scaffoldKey,
                  snackBarMessage: result.message.toString());
            }

            setState(() {});
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
    } catch (e) {
      debugPrint(
          "Exception - payment_gateways_screen.dart.dart - _productCartCheckout():$e");
    }
  }
}
