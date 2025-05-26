import 'dart:async';
import 'dart:io';

import 'package:app/models/book_now_model.dart';
import 'package:app/models/businessLayer/base_route.dart';
import 'package:app/models/businessLayer/business_rule.dart';
import 'package:app/models/businessLayer/global.dart' as global;
import 'package:app/models/card_model.dart';
import 'package:app/models/cart_model.dart';
import 'package:app/models/payment_gateway_model.dart';
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

class PaymentGatewayScreen extends BaseRoute {
  final int? screenId;
  final Cart? cartList;
  final BookNow? bookNowDetails;
  const PaymentGatewayScreen({super.key, super.a, super.o, this.screenId, this.cartList, this.bookNowDetails}) : super(r: 'PaymentGatewayScreen');
  @override
  BaseRouteState<PaymentGatewayScreen> createState() => _PaymentGatewayScreenState();
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
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                title: Text(
                  AppLocalizations.of(context)!.lbl_payment_method,
                  style: Theme.of(context).appBarTheme.titleTextStyle,
                ),
              ),
              body: _isDataLoaded
                  ? Column(
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
                            tileColor: _isCOD ? Theme.of(context).primaryColorLight.withOpacity(0.3) : Colors.transparent,
                            leading: Icon(
                              MdiIcons.cash,
                              color: Colors.green[500],
                            ),
                            title: Text(AppLocalizations.of(context)!.lbl_cash),
                            subtitle: Text(AppLocalizations.of(context)!.txt_pay_through_cash_at_the_salon),
                          ),
                        ),
                        Divider(
                          color: Colors.grey[300],
                        ),
                        ListTile(
                          title: Text(AppLocalizations.of(context)!.lbl_other_methods, style: Theme.of(context).primaryTextTheme.headlineSmall),
                        ),
                        Divider(
                          color: Colors.grey[300],
                        ),
                        _paymentGatewayList!.razorpay!.razorpayStatus == 'Yes'
                            ? GestureDetector(
                                onTap: () {
                                  showOnlyLoaderDialog();
                                  openCheckout();
                                },
                                child: ListTile(
                                  leading: Icon(MdiIcons.creditCard),
                                  title: Text(AppLocalizations.of(context)!.lbl_rezorpay),
                                ),
                              )
                            : const SizedBox(),
                        _paymentGatewayList!.stripe!.stripeStatus == 'Yes'
                            ? GestureDetector(
                                onTap: () {
                                  _cardDialog();
                                },
                                child: ListTile(
                                  leading: const Icon(FontAwesomeIcons.stripe),
                                  title: Text(AppLocalizations.of(context)!.lbl_stripe),
                                ),
                              )
                            : const SizedBox(),
                        _paymentGatewayList!.paystack!.payStackStatus == 'Yes'
                            ? GestureDetector(
                                onTap: () {
                                  _cardDialog(paymentCallId: 1);
                                },
                                child: ListTile(
                                  leading: Icon(MdiIcons.creditCard),
                                  title: Text(AppLocalizations.of(context)!.lbl_paystack),
                                ),
                              )
                            : const SizedBox()
                      ],
                    )
                  : _shimmer(),
              bottomNavigationBar: BottomAppBar(
                  color: const Color(0xFF171D2C),
                  child: SizedBox(
                      height: 60,
                      width: double.infinity,
                      child: ListTile(
                        title: RichText(
                            text: TextSpan(style: Theme.of(context).primaryTextTheme.titleMedium, children: [
                          TextSpan(text: AppLocalizations.of(context)!.lbl_total_amount),
                          TextSpan(text: widget.screenId == 1 ? '${global.currency.currencySign} ${widget.bookNowDetails?.remPrice ?? '0.00'}' : '${global.currency.currencySign} ${widget.cartList?.totalPrice ?? '0.00'}', style: Theme.of(context).primaryTextTheme.headlineSmall)
                        ])),
                        trailing: _isCOD
                            ? ElevatedButton(
                                onPressed: () {
                                  widget.screenId == 1 ? _checkOut() : _productCartCheckout();
                                },
                                child: Text(AppLocalizations.of(context)!.lbl_checkout,style: TextStyle(color: Colors.white)),
                              )
                            : const SizedBox(),
                      )))),
        );
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  void openCheckout() async {
    Map<String, Object?> options;

    options = {
      'key': _paymentGatewayList!.razorpay!.razorpayKey,
      'amount': widget.screenId == 1 ? widget.bookNowDetails!.remPrice : widget.cartList!.totalPrice,
      'name': widget.screenId == 1 ? widget.bookNowDetails!.cartId : widget.cartList!.cartItems[0].orderCartId,
      'prefill': {'contact': global.user!.userPhone, 'email': global.user!.email},
      'currency': 'INR'
    };

    try {
      hideLoader();
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

  void payStatck(String? key) async {
    try {
      payPlugin.initialize(publicKey: _paymentGatewayList!.paystack!.payStackPublicKey!).then((value) {
        _startAfreshCharge((int.parse('${widget.cartList!.totalPrice}') * 100));
      }).catchError((e) {
        setState(() {
          isLoading = false;
        });
      });
    } catch (e) {
      debugPrint("Exception - payment_gateways_screen.dart - payStatck(): $e");
    }
  }

  Future<StripeTransactionResponse> payWithNewCard({
    String? amount,
    required CardModel card,
    String? currency,
  }) async {
    Map<String, dynamic>? customers;
    try {
      showOnlyLoaderDialog();
      customers = await StripeService.createCustomer(email: global.user!.email);

      var paymentMethodsObject = await (StripeService.createPaymentMethod(card) as FutureOr<Map<String, dynamic>>);

      var paymentIntent = await (StripeService.createPaymentIntent(amount, currency, customerId: customers?["id"]) as FutureOr<Map<String, dynamic>>);
      var response = await (StripeService.confirmPaymentIntent(paymentIntent["id"], paymentMethodsObject["id"]) as FutureOr<Map<String, dynamic>>);
      if (response["status"] == 'succeeded') {
        bool isConnected = await br.checkConnectivity();
        if (isConnected) {
          if (widget.screenId == 1) {
            BookNow bookNow = BookNow();
            bookNow.paymentStatus = "success";
            bookNow.paymentMethod = "Stripe";
            bookNow.cartId = widget.bookNowDetails!.cartId;
            bookNow.paymentId = paymentIntent["id"];
            bookNow.paymentGateway = "Stripe";
            await apiHelper!.checkOut(bookNow).then((result) async {
              if (result != null) {
                if (result.status == "1") {
                  if(!mounted) return;
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => BookingConfirmationScreen(a: widget.analytics, o: widget.observer)),
                  );
                }
              }
            });
          } else {
            await apiHelper!.productCartCheckout(global.user!.id, "success", "stripe", paymentId: paymentIntent["id"]).then((result) {
              if (result != null) {
                if (result.status == "1") {
                  if(!mounted) return;
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => BookingConfirmationScreen(a: widget.analytics, o: widget.observer)),
                  );
                }
              }
            });
          }
          hideLoader();
        } else {
          showNetworkErrorSnackBar(_scaffoldKey);
        }
        if(!mounted) return StripeTransactionResponse(success: false);
        return StripeTransactionResponse(message: AppLocalizations.of(context)!.lbl_transaction_successful, success: true);
      } else {
        bool isConnected = await br.checkConnectivity();
        if (isConnected) {
          showOnlyLoaderDialog();
          if (widget.screenId == 1) {
            BookNow bookNow = BookNow();
            bookNow.paymentStatus = "failed";
            bookNow.paymentMethod = "Stripe";
            bookNow.cartId = widget.bookNowDetails!.cartId;
            bookNow.paymentGateway = "Stripe";

            await apiHelper!.checkOut(bookNow).then((result) async {
              if (result != null) {
                if (result.status == "0") {
                  showSnackBar(key: _scaffoldKey, snackBarMessage: result.message.toString());
                  setState(() {});
                } else {}
              }
            });
          } else {
            await apiHelper!.productCartCheckout(global.user!.id, "failed", "stripe").then((result) {
              if (result != null) {
                if (result.status == "2") {
                  if(!mounted) return;
                  Navigator.of(context).pop();
                  showSnackBar(key: _scaffoldKey, snackBarMessage: result.message.toString());
                }
              }
            });
          }
          hideLoader();
          _tryAgainDialog();
          setState(() {});
        } else {
          showNetworkErrorSnackBar(_scaffoldKey);
        }
        if(!mounted) return StripeTransactionResponse(success: false);
        return StripeTransactionResponse(message: AppLocalizations.of(context)!.lbl_transaction_failed, success: false);
      }
    } on PlatformException catch (err) {
      debugPrint('Platfrom Exception: payment_gateways_screen.dart -  payWithNewCard() : ${err.toString()}');
      return StripeService.getPlatformExceptionErrorResult(err);
    } catch (err) {
      debugPrint('Exception: payment_gateways_screen.dart -  payWithNewCard() : ${err.toString()}');
      return StripeTransactionResponse(message: 'Transaction failed: ${err.toString()}', success: false);
    }
  }

  _cardDialog({int? paymentCallId}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) => Theme(
                  data: ThemeData(dialogBackgroundColor: Colors.white),
                  child: AlertDialog(
                    contentPadding: const EdgeInsets.all(0),
                    elevation: 0.5,
                    scrollable: true,
                    title: Text(
                      AppLocalizations.of(context)!.lbl_card_Details,
                      style: Theme.of(context).primaryTextTheme.displaySmall,
                    ),
                    actions: [
                      Row(
                        children: [
                          TextButton(
                            style: Theme.of(context).textButtonTheme.style,
                            child: Text(AppLocalizations.of(context)!.lbl_cancel),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: TextButton(
                              style: Theme.of(context).textButtonTheme.style,
                              child: Text(AppLocalizations.of(context)!.lbl_pay),
                              onPressed: () {
                                _save(paymentCallId);
                              },
                            ),
                          )
                        ],
                      )
                    ],
                    content: Form(
                      key: _formKey,
                      autovalidateMode: _autovalidate ? AutovalidateMode.always : AutovalidateMode.disabled,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _cCardNumber,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(16),
                                CardNumberInputFormatter(),
                              ],
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                hintText: AppLocalizations.of(context)!.lbl_card_number,
                                hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
                                prefixIcon: const Icon(Icons.credit_card),
                              ),
                              textCapitalization: TextCapitalization.none,
                              keyboardType: TextInputType.number,
                              onSaved: (String? value) {
                                number = BusinessRule.getCleanedNumber(value!);
                              },
                              // ignore: missing_return
                              validator: (input) {
                                if (input!.isEmpty) {
                                  return AppLocalizations.of(context)!.txt_enter_card_number;
                                }

                                input = BusinessRule.getCleanedNumber(input);

                                if (input.length < 8) {
                                  return AppLocalizations.of(context)!.txt_enter_valid_card_number;
                                }

                                int sum = 0;
                                int length = input.length;
                                for (var i = 0; i < length; i++) {
                                  // get digits in reverse order
                                  int digit = int.parse(input[length - i - 1]);

                                  // every 2nd number multiply with 2
                                  if (i % 2 == 1) {
                                    digit *= 2;
                                  }
                                  sum += digit > 9 ? (digit - 9) : digit;
                                }

                                if (sum % 10 == 0) {
                                  return null;
                                }

                                return AppLocalizations.of(context)!.txt_enter_valid_card_number;
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    inputFormatters: [
                                      // ignore: deprecated_member_use
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(4),
                                      CardMonthInputFormatter(),
                                    ],
                                    controller: _cExpiry,
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                        prefixIcon: const Icon(
                                          Icons.date_range,
                                        ),
                                        hintText: 'MM/YY',
                                        hintStyle: Theme.of(context).inputDecorationTheme.hintStyle),
                                    textCapitalization: TextCapitalization.sentences,
                                    keyboardType: TextInputType.number,
                                    onFieldSubmitted: (value) {
                                      List<int> expiryDate = BusinessRule.getExpiryDate(value);
                                      _month = expiryDate[0];
                                      _year = expiryDate[1];
                                    },
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return AppLocalizations.of(context)!.txt_enter_expiry_date;
                                      }

                                      int year;
                                      int month;
                                      // The value contains a forward slash if the month and year has been
                                      // entered.
                                      if (value.contains(RegExp(r'(/)'))) {
                                        var split = value.split(RegExp(r'(/)'));
                                        // The value before the slash is the month while the value to right of
                                        // it is the year.
                                        month = int.parse(split[0]);
                                        year = int.parse(split[1]);
                                      } else {
                                        // Only the month was entered
                                        month = int.parse(value.substring(0, (value.length)));
                                        year = -1; // Lets use an invalid year intentionally
                                      }

                                      if ((month < 1) || (month > 12)) {
                                        // A valid month is between 1 (January) and 12 (December)
                                        return AppLocalizations.of(context)!.txt_expiry_month_is_invalid;
                                      }

                                      var fourDigitsYear = BusinessRule.convertYearTo4Digits(year);
                                      if ((fourDigitsYear < 1) || (fourDigitsYear > 2099)) {
                                        // We are assuming a valid should be between 1 and 2099.
                                        // Note that, it's valid doesn't mean that it has not expired.
                                        return AppLocalizations.of(context)!.txt_expiry_year_is_invalid;
                                      }

                                      if (!BusinessRule.hasDateExpired(month, year)) {
                                        return AppLocalizations.of(context)!.txt_card_has_expired;
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: TextFormField(
                                    inputFormatters: [
                                      // ignore: deprecated_member_use
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(3),
                                    ],
                                    controller: _cCvv,
                                    obscureText: true,
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          MdiIcons.creditCard,
                                        ),
                                        hintText: AppLocalizations.of(context)!.lbl_cvv,
                                        hintStyle: Theme.of(context).inputDecorationTheme.hintStyle),
                                    textCapitalization: TextCapitalization.sentences,
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return AppLocalizations.of(context)!.txt_enter_cvv;
                                      } else if (value.length < 3 || value.length > 4) {
                                        return AppLocalizations.of(context)!.txt_cvv_is_invalid;
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: _cName,
                              textInputAction: TextInputAction.next,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp('[a-zA-Z ]')),
                              ],
                              decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    Icons.person,
                                  ),
                                  hintText: AppLocalizations.of(context)!.txt_card_holder_name,
                                  hintStyle: Theme.of(context).inputDecorationTheme.hintStyle),
                              textCapitalization: TextCapitalization.words,
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return null;
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  )));
        });
  }

  _chargeCard(Charge charge) async {
    try {
      payPlugin.chargeCard(context, charge: charge).then((value) {
        if (value.status && value.message == "Success") {}
      }).catchError((e) {
        setState(() {
          isLoading = false;
        });
      });
    } catch (e) {
      debugPrint("Exception - payment_gateways_screen.dart - _chargeCard(): $e");
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
              if(!mounted) return;
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
              showSnackBar(key: _scaffoldKey, snackBarMessage: result.message.toString());
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

  PaymentCard _getCardFromUI() {
    return PaymentCard(
      number: _cCardNumber.text,
      cvc: _cCvv.text,
      expiryMonth: 11,
      expiryYear: 25,
    );
  }

  _getPaymentGateways() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        await apiHelper!.getPaymentGateways().then((result) {
          if (result != null) {
            if (result.status == "1") {
              _paymentGatewayList = result.recordList;
              _isDataLoaded = true;
              setState(() {});
            } else {
              showSnackBar(key: _scaffoldKey, snackBarMessage: result.message.toString());
            }
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
    } catch (e) {
      debugPrint("Exception - payment_gateways_screen.dart.dart - _getPaymentGateways():$e");
    }
  }

  String _getReference() {
    String platform;
    if (Platform.isIOS) {
      platform = 'iOS';
    } else {
      platform = 'Android';
    }

    return 'ChargedFrom${platform}_${DateTime.now().millisecondsSinceEpoch}';
  }

  void _handlePaymentError(PaymentFailureResponse response) async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        showOnlyLoaderDialog();

        if (widget.screenId == 1) {
          BookNow bookNow = BookNow();
          bookNow.paymentStatus = "failed";
          bookNow.paymentMethod = "Razorpay";
          bookNow.cartId = widget.bookNowDetails!.cartId;
          bookNow.paymentGateway = "Razorpay";

          await apiHelper!.checkOut(bookNow).then((result) async {
            if (result != null) {
              if (result.status == "0") {
                showSnackBar(key: _scaffoldKey, snackBarMessage: result.message.toString());
                setState(() {});
              } else {}
            }
          });
        } else {
          await apiHelper!.productCartCheckout(global.user!.id, "failed", " razorpay").then((result) {
            if (result != null) {
              if (result.status == "2") {
                if(!mounted) return;
                Navigator.of(context).pop();
                showSnackBar(key: _scaffoldKey, snackBarMessage: result.message.toString());
              }
            }
          });
        }
        hideLoader();
        _tryAgainDialog();
        setState(() {});
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
      if(!mounted) return;
      showSnackBar(key: _scaffoldKey, snackBarMessage: AppLocalizations.of(context)!.lbl_transaction_failed);
    } catch (e) {
      debugPrint("Exception - payment_gateways_screen.dart -  _handlePaymentError$e");
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    try {
      showOnlyLoaderDialog();

      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        showOnlyLoaderDialog();
        if (widget.screenId == 1) {
          BookNow bookNow = BookNow();
          bookNow.paymentStatus = "success";
          bookNow.paymentMethod = "Razorpay";
          bookNow.cartId = widget.bookNowDetails!.cartId;
          bookNow.paymentId = response.paymentId;
          bookNow.paymentGateway = "Razorpay";
          await apiHelper!.checkOut(bookNow).then((result) async {
            if (result != null) {
              if (result.status == "1") {
                if(!mounted) return;
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => BookingConfirmationScreen(a: widget.analytics, o: widget.observer)),
                );
              }
            }
          });
        } else {
          await apiHelper!.productCartCheckout(global.user!.id, "success", "razorpay", paymentId: response.paymentId).then((result) {
            if (result != null) {
              if (result.status == "1") {
                if(!mounted) return;
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => BookingConfirmationScreen(a: widget.analytics, o: widget.observer)),
                );
              }
            }
          });
        }
        hideLoader();
        setState(() {});
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
      if(!mounted) return;
      showSnackBar(key: _scaffoldKey, snackBarMessage: AppLocalizations.of(context)!.lbl_transaction_successful);
    } catch (e) {
      debugPrint("Exception - payment_gateways_screen.dart - _handlePaymentSuccess$e");
    }
  }

  _init() async {
    try {
      await _getPaymentGateways();
      _razorpay = Razorpay();
      _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
      _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    } catch (e) {
      debugPrint("Exception - payment_gateways_screen.dart.dart - _init():$e");
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
              if(!mounted) return;
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => BookingConfirmationScreen(
                          a: widget.analytics,
                          o: widget.observer,
                          screenId: 1,
                        )),
              );
            }

            setState(() {});
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
    } catch (e) {
      debugPrint("Exception - payment_gateways_screen.dart.dart - _productCartCheckout():$e");
    }
  }

  Future _save(int? callId) async {
    try {
      showOnlyLoaderDialog();
      if (_cCardNumber.text.trim().isEmpty) {
        hideLoader();
        showSnackBar(key: _scaffoldKey, snackBarMessage: AppLocalizations.of(context)!.txt_enter_your_card_number);
      } else if (_cExpiry.text.trim().isEmpty) {
        hideLoader();
        showSnackBar(key: _scaffoldKey, snackBarMessage: AppLocalizations.of(context)!.txt_enter_your_expiry_date);
      } else if (_cName.text.trim().isEmpty) {
        hideLoader();
        showSnackBar(key: _scaffoldKey, snackBarMessage: AppLocalizations.of(context)!.txt_enter_your_card_name);
      } else {
        if (_formKey.currentState!.validate()) {
          bool isConnected = await br.checkConnectivity();
          if (isConnected) {
            CardModel stripeCard = CardModel(
              number: _cCardNumber.text,
              expiryMonth: _month,
              expiryYear: _year,
              cvv: _cCvv.text,
            );
            if(!mounted) return;
            Navigator.of(context).pop();
            if (widget.screenId == 1) {
              callId == 1 ? payStatck(_paymentGatewayList!.paystack!.payStackSecretKey) : await payWithNewCard(card: stripeCard, amount: widget.bookNowDetails!.remPrice, currency: global.currency.currency);
            } else {
              callId == 1 ? payStatck(_paymentGatewayList!.paystack!.payStackSecretKey) : await payWithNewCard(card: stripeCard, amount: widget.cartList!.totalPrice.toString(), currency: global.currency.currency);
            }

            hideLoader();
          }
        }
      }
    } catch (e) {
      debugPrint("Exception - payment_gateways_screen.dart - _save(): $e");
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
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 220,
                            height: 40,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 120,
                            height: 40,
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

  _startAfreshCharge(int price) async {
    try {
      Charge charge = Charge()
        ..amount = price
        ..email = '${global.user!.email}'
        ..currency = 'INR'
        ..card = _getCardFromUI()
        ..reference = _getReference();

      _chargeCard(charge);
    } catch (e) {
      debugPrint("Exception - payment_gateways_screen.dart - _startAfreshCharge(): $e");
    }
  }

  _tryAgainDialog() {
    try {
      showCupertinoDialog(
          context: context,
          builder: (BuildContext context) {
            return Theme(
              data: ThemeData(dialogBackgroundColor: Colors.white),
              child: CupertinoAlertDialog(
                title: Text(
                  AppLocalizations.of(context)!.lbl_transaction_failed,
                ),
                content: Text(
                  AppLocalizations.of(context)!.txt_please_try_again,
                ),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text(
                      AppLocalizations.of(context)!.lbl_cancel,
                      style: const TextStyle(color: Colors.red),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      setState(() {});
                    },
                  ),
                  CupertinoDialogAction(
                    child: Text(AppLocalizations.of(context)!.lbl_try_again),
                    onPressed: () async {
                      Navigator.of(context).pop();
                      setState(() {});
                    },
                  ),
                ],
              ),
            );
          });
    } catch (e) {
      debugPrint('Exception - payment_gateways_screen.dart - exitAppDialog(): $e');
    }
  }
}
