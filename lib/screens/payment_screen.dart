import 'dart:developer';

import 'package:app/models/businessLayer/base_route.dart';
import 'package:app/models/call_back_model.dart';
import 'package:app/widgets/bottom_navigation_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'booking_confirmation_screen.dart';


class PaymentWebViewScreen extends BaseRoute {
    final String? url;
  final int orderId;
  const PaymentWebViewScreen(
      {super.key,
      super.a,
      super.o,
      this.url, required this.orderId, })
      : super(r: 'PaymentWebViewScreen');
  @override
  BaseRouteState<PaymentWebViewScreen> createState() =>
      _PaymentGatewayScreenState();
}

class _PaymentGatewayScreenState extends BaseRouteState<PaymentWebViewScreen> {
 
  GlobalKey<ScaffoldState>? _scaffoldKey;


  bool isLoading = false;

  _PaymentGatewayScreenState() : super();


  late final WebViewController _controller;
  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {
            // Navigator.pop(context);
          },
          onWebResourceError: (WebResourceError error) {},
          onUrlChange: (v) {
            log(" url ${v.url}");
            if (v.url.toString().toLowerCase() ==
                'https://accept.paymob.com/unifiedcheckout/payment-status') {

                   _checkOutCallBack();

              // context
              //     .read<OrdersCubit>()
              //     .checkPaymentStatus(context, orderId: widget.reservationid);

              // if (v.url
              //     .toString()
              //     .toLowerCase()
              //     .contains('api/payment-success')) {
              // if (v.url.toString().toLowerCase().contains('api/payment/callback')) {
              // Navigator.pop(context);
              // Navigator.pop(context);
              // context.read<PaymentCubit>().checkPayment(v.url!);




                 

              // print(v);
              // Navigator.pop(context);
              // Navigator.pop(context);

              // print("000000");

              // Uri uri = Uri.parse(v.url!);

              // String successValue = uri.queryParameters['success'] ?? '';
              // if (successValue.toString() == 'false') {
              //   print('false ..');
              //   print('فشلت عملية الدفع');

              //   print('false ..');
              // } else {
              //   // Navigator.pushAndRemoveUntil(
              //   //     context,
              //   //     MaterialPageRoute(
              //   //         builder: (context) => OrderConfirmedScreen(
              //   //               orederId: widget.orderId!,
              //   //               transitionId: uri.queryParameters['id'] ?? '',
              //   //             )),
              //   //     (route) => false);
              //   print('تمت عملية الدفع');
              //   // successGetBar('تمت عملية الدفع');
              //   print('true ..');
              // }
            }
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url ?? 'https://flutter.dev'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
                key: _scaffoldKey,

   appBar: AppBar(
            title: Text(
              AppLocalizations.of(context)!.lbl_paymob,
              style: Theme.of(context).appBarTheme.titleTextStyle,
            ),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
              onPressed: () {
               _showDialog();
              },
            )
          ),

     
        body: WillPopScope(
          onWillPop: () async {
            _showDialog();
            
                      // Navigator.pop(context);
            return false;
          },
          child: SafeArea(
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: WebViewWidget(controller: _controller))),
        ));
  }
    _checkOutCallBack() async {
       showOnlyLoaderDialog(); 
    try {
          
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        await apiHelper!.checkOutCallBack(widget.orderId).then((result) async {  
          CallBackModel callBackModel =result.recordList;  
  log( "ssss ${callBackModel.status}");  

          if (result != null) {
                          
// 
            // if (callBackModel.status.toString() == "1") {
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

            
            } else {
               hideLoader();
               


              showSnackBar(
                  key: _scaffoldKey,
                  snackBarMessage: "error");
            }
          }
          else{
            log("SSSSssss");
          }
        }).catchError((error) {
          hideLoader();
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
    } catch (e) {
      debugPrint("Exception - payment_gateways_screen.dart - _checkOut():$e");
    }
  }

   _showDialog() async {
    try {
      showCupertinoDialog(
          context: context,
          builder: (BuildContext context) {
            return Theme(
              data: ThemeData(dialogBackgroundColor: Colors.white),
              child: CupertinoAlertDialog(                
                content: Text(
                   AppLocalizations.of(context)!.are_you_sure_exit_pay,
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
                     
                      Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => BottomNavigationWidget(
                                a: widget.analytics,
                                o: widget.observer,
                              )),
                    );
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

}
