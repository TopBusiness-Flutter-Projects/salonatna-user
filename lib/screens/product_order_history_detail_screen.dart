import 'package:app/models/businessLayer/base_route.dart';
import 'package:app/models/businessLayer/global.dart' as global;
import 'package:app/models/product_order_history_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductOrderHistoryDetailScreen extends BaseRoute {
  final ProductOrderHistory productOrderHistory;
  const ProductOrderHistoryDetailScreen(this.productOrderHistory, {super.key, super.a, super.o}) : super(r: 'ProductOrderHistoryDetailScreen');
  @override
  BaseRouteState<ProductOrderHistoryDetailScreen> createState() => _ProductOrderHistoryDetailScreenState();
}

class _ProductOrderHistoryDetailScreenState extends BaseRouteState<ProductOrderHistoryDetailScreen> {
  final TextEditingController _cCancelReason = TextEditingController();
  final FocusNode _fCancelReason = FocusNode();


  GlobalKey<ScaffoldState>? _scaffoldKey;
  bool _isExpanded = false;

  _ProductOrderHistoryDetailScreenState() : super();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: sc(Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.lbl_order_detail),
          actions: const [],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, bottom: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Card(
                        child: ListTile(
                          title: Text(AppLocalizations.of(context)!.lbl_cart_id, style: Theme.of(context).primaryTextTheme.titleSmall),
                          subtitle: Text("${widget.productOrderHistory.cartId}", style: Theme.of(context).primaryTextTheme.bodyMedium),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Card(
                        child: ListTile(
                          title: Text(AppLocalizations.of(context)!.lbl_order_on, style: Theme.of(context).primaryTextTheme.titleSmall),
                          subtitle: Text("${DateFormat('dd/MM/yyyy').format(widget.productOrderHistory.createdAt!)}  ${DateFormat('hh:mm a').format(widget.productOrderHistory.createdAt!)}", style: Theme.of(context).primaryTextTheme.bodyMedium),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8, left: 15, right: 15),
                child: Card(
                  child: ListTile(
                    title: Text(AppLocalizations.of(context)!.lbl_order_total, style: Theme.of(context).primaryTextTheme.titleSmall),
                    trailing: Text("${global.currency.currencySign} ${widget.productOrderHistory.totalPrice}", style: Theme.of(context).primaryTextTheme.titleMedium),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8, left: 15, right: 15),
                child: Card(
                  child: ListTile(
                    leading: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: CircleAvatar(
                        backgroundColor: widget.productOrderHistory.status == 4
                            ? Colors.grey
                            : widget.productOrderHistory.status == 3
                                ? Colors.red
                                : widget.productOrderHistory.status == 1
                                    ? Colors.amber
                                    : Colors.green[600],
                        radius: 15,
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    title: Text(
                        widget.productOrderHistory.status == 4
                            ? AppLocalizations.of(context)!.lbl_cancelled
                            : widget.productOrderHistory.status == 3
                                ? AppLocalizations.of(context)!.lbl_failed
                                : widget.productOrderHistory.status == 1
                                    ? AppLocalizations.of(context)!.lbl_pending
                                    : AppLocalizations.of(context)!.lbl_completed,
                        style: Theme.of(context).primaryTextTheme.titleSmall),
                    subtitle: Text(
                      "${DateFormat('dd/MM/yyyy').format(widget.productOrderHistory.createdAt!)}  ${DateFormat('hh:mm a').format(widget.productOrderHistory.createdAt!)}",
                      style: Theme.of(context).primaryTextTheme.bodyMedium,
                    ),
                  ),
                ),
              ),
              ListView.builder(
                  itemCount: widget.productOrderHistory.vendor.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8, left: 15, right: 15),
                      child: Card(
                        child: ExpansionTile(
                            title: Text(
                              '${widget.productOrderHistory.vendor[index].vendorName}',
                              style: Theme.of(context).primaryTextTheme.titleSmall,
                            ),
                            onExpansionChanged: (val) {
                              _isExpanded = val;
                              setState(() {});
                            },
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.location_on,
                                      size: 15,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: Text(
                                        "${widget.productOrderHistory.vendor[index].vendorLoc}",
                                        style: Theme.of(context).primaryTextTheme.titleMedium,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.phone,
                                      size: 15,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "${widget.productOrderHistory.vendor[index].vendorPhone}",
                                      style: Theme.of(context).primaryTextTheme.titleMedium,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            trailing: Column(
                              children: [
                                Icon(
                                  _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(
                                      child: Container(
                                        width: 40,
                                        decoration: BoxDecoration(
                                          borderRadius: global.isRTL
                                              ? const BorderRadius.only(
                                                  topRight: Radius.circular(5.0),
                                                  bottomRight: Radius.circular(5.0),
                                                )
                                              : const BorderRadius.only(
                                                  topLeft: Radius.circular(5.0),
                                                  bottomLeft: Radius.circular(5.0),
                                                ),
                                          color: Colors.grey[200],
                                          border: Border.all(
                                            color: Colors.grey[200]!,
                                          ),
                                        ),
                                        padding: const EdgeInsets.all(4),
                                        height: 25,
                                        child: Center(
                                          child: Text(
                                            AppLocalizations.of(context)!.lbl_items,
                                            style: Theme.of(context).primaryTextTheme.bodyMedium,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 25,
                                      width: 40,
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        borderRadius: global.isRTL
                                            ? const BorderRadius.only(
                                                topLeft: Radius.circular(5.0),
                                                bottomLeft: Radius.circular(5.0),
                                              )
                                            : const BorderRadius.only(
                                                topLeft: Radius.circular(5.0),
                                                bottomLeft: Radius.circular(5.0),
                                              ),
                                        border: Border.all(
                                          color: Colors.grey[200]!,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "${widget.productOrderHistory.count}",
                                          style: Theme.of(context).primaryTextTheme.bodyMedium,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            children: [
                              ListTile(
                                tileColor: Colors.grey[200],
                                title: Text(AppLocalizations.of(context)!.lbl_total_price),
                                trailing: Text('${global.currency.currencySign}' '${widget.productOrderHistory.totalPrice}'),
                              ),
                              widget.productOrderHistory.status == 1
                                  ? ListTile(
                                      tileColor: Colors.grey[200],
                                      title: const Text('Go to location'),
                                      trailing: widget.productOrderHistory.status == 1
                                          ? IconButton(
                                              onPressed: () async {
                                                await _openMap(widget.productOrderHistory.vendor[0].lat, widget.productOrderHistory.vendor[0].lng);
                                              },
                                              icon: const Icon(Icons.map))
                                          : const SizedBox())
                                  : const SizedBox(),
                              Padding(
                                padding: const EdgeInsets.only(top: 5, bottom: 4),
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: widget.productOrderHistory.vendor[index].products.length,
                                    itemBuilder: (BuildContext context, int i) {
                                      return Column(
                                        children: [
                                          ListTile(
                                            tileColor: Colors.transparent,
                                            title: Row(
                                              children: [
                                                CachedNetworkImage(
                                                  imageUrl: global.baseUrlForImage + widget.productOrderHistory.vendor[index].products[i].productImage!,
                                                  imageBuilder: (context, imageProvider) => Container(
                                                    height: 50,
                                                    width: 50,
                                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), image: DecorationImage(fit: BoxFit.cover, image: imageProvider)),
                                                  ),
                                                  placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                                  errorWidget: (context, url, error) => const Icon(Icons.error),
                                                ),
                                                Padding(
                                                  padding: global.isRTL ? const EdgeInsets.only(right: 10) : const EdgeInsets.only(left: 10),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text('${widget.productOrderHistory.vendor[index].products[i].productName}', textAlign: TextAlign.justify, style: Theme.of(context).primaryTextTheme.titleSmall),
                                                      Row(
                                                        mainAxisSize: MainAxisSize.min,
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: <Widget>[
                                                          SizedBox(
                                                            child: Container(
                                                              width: 40,
                                                              decoration: BoxDecoration(
                                                                borderRadius: global.isRTL
                                                                    ? const BorderRadius.only(
                                                                        topRight: Radius.circular(5.0),
                                                                        bottomRight: Radius.circular(5.0),
                                                                      )
                                                                    : const BorderRadius.only(
                                                                        topLeft: Radius.circular(5.0),
                                                                        bottomLeft: Radius.circular(5.0),
                                                                      ),
                                                                color: Colors.grey[200],
                                                                border: Border.all(
                                                                  color: Colors.grey[200]!,
                                                                ),
                                                              ),
                                                              padding: const EdgeInsets.all(4),
                                                              height: 25,
                                                              child: Center(
                                                                child: Text(
                                                                  AppLocalizations.of(context)!.lbl_qty,
                                                                  style: Theme.of(context).primaryTextTheme.bodyMedium,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            height: 25,
                                                            width: 40,
                                                            padding: const EdgeInsets.all(4),
                                                            decoration: BoxDecoration(
                                                              borderRadius: global.isRTL
                                                                  ? const BorderRadius.only(
                                                                      topLeft: Radius.circular(5.0),
                                                                      bottomLeft: Radius.circular(5.0),
                                                                    )
                                                                  : const BorderRadius.only(
                                                                      topLeft: Radius.circular(5.0),
                                                                      bottomLeft: Radius.circular(5.0),
                                                                    ),
                                                              border: Border.all(
                                                                color: Colors.grey[200]!,
                                                              ),
                                                            ),
                                                            child: Center(
                                                              child: Text(
                                                                "${widget.productOrderHistory.vendor[index].products[i].qty}",
                                                                style: Theme.of(context).primaryTextTheme.bodyMedium,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            trailing: Text(
                                              ' ${global.currency.currencySign} ${widget.productOrderHistory.vendor[index].products[i].price}',
                                              style: Theme.of(context).primaryTextTheme.headlineSmall,
                                            ),
                                          ),
                                          i == widget.productOrderHistory.vendor[index].products.length - 1
                                              ? const SizedBox()
                                              : Divider(
                                                  endIndent: 10,
                                                  indent: 10,
                                                  color: Colors.grey[300],
                                                )
                                        ],
                                      );
                                    }),
                              )
                            ]),
                      ),
                    );
                  }),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(),
              widget.productOrderHistory.status == 1
                  ? SizedBox(
                      width: 150,
                      height: 43,
                      child: TextButton(
                          onPressed: () async {
                            _cancelReasonDialog();
                            setState(() {});
                          },
                          child: Text(AppLocalizations.of(context)!.lbl_cancel_order)),
                    )
                  : const SizedBox(),
              const SizedBox(),
            ],
          ),
        ),
      )),
    );
  }



  _cancelOrder(String? cartId, String reason) async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        showOnlyLoaderDialog();
        await apiHelper!.cancelOrder(cartId, reason).then((result) {
          if (result != null) {
            if (result.status == "1") {
              hideLoader();
              widget.productOrderHistory.status = 4;
              if(!mounted) return;
              Navigator.of(context).pop();
              showSnackBar(key: _scaffoldKey, snackBarMessage: result.message.toString());
              setState(() {});
            } else if (result.status == "0") {
              hideLoader();
              if(!mounted) return;
              Navigator.of(context).pop();
              showSnackBar(key: _scaffoldKey, snackBarMessage: result.message.toString());
              setState(() {});
            }

            setState(() {});
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
    } catch (e) {
      debugPrint("Exception - product_order_history_screen.dart - _cancelOrder():$e");
    }
  }

  _cancelReasonDialog() async {
    try {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Theme(
              data: ThemeData(dialogBackgroundColor: Colors.white),
              child: AlertDialog(
                title: Text(
                  AppLocalizations.of(context)!.lbl_cancellation_reason,
                ),
                content: Container(
                    margin: const EdgeInsets.only(top: 5, left: 10, right: 10),
                    height: 70,
                    child: Form(
                      autovalidateMode: AutovalidateMode.always,
                      child: TextFormField(
                        textAlign: TextAlign.start,
                        autofocus: false,
                        cursorColor: const Color(0xFFFA692C),
                        enabled: true,
                        style: Theme.of(context).inputDecorationTheme.hintStyle,
                        controller: _cCancelReason,
                        focusNode: _fCancelReason,
                        validator: (text) {
                          if (_cCancelReason.text.isEmpty && _cCancelReason.text == "") {
                            return AppLocalizations.of(context)!.txt_provide_cancel_reason;
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
                            enabledBorder: Theme.of(context).inputDecorationTheme.enabledBorder,
                            focusedBorder: Theme.of(context).inputDecorationTheme.focusedBorder,
                            border: Theme.of(context).inputDecorationTheme.border,
                            prefixIcon: Icon(
                              Icons.remove_circle_outline,
                              size: 20,
                              color: Theme.of(context).primaryIconTheme.color,
                            ),
                            hintText: AppLocalizations.of(context)!.lbl_cancel_reason),
                        onFieldSubmitted: (text) async {
                          _cCancelReason.text = text;

                          FocusScope.of(context).unfocus();
                          setState(() {});
                        },
                      ),
                    )),
                actions: <Widget>[
                  TextButton(
                    child: Text(
                      AppLocalizations.of(context)!.lbl_cancel,
                      style: const TextStyle(fontSize: 15, color: Color(0xFF171D2C), fontWeight: FontWeight.w400),
                    ),
                    onPressed: () {
                      return Navigator.of(context).pop(false);
                    },
                  ),
                  TextButton(
                    child: Text(AppLocalizations.of(context)!.lbl_confirm, style: const TextStyle(fontSize: 15, color: Color(0xFFFA692C), fontWeight: FontWeight.w400)),
                    onPressed: () async {
                      if (_cCancelReason.text.isNotEmpty && _cCancelReason.text != "") {
                        await _cancelOrder(widget.productOrderHistory.cartId, _cCancelReason.text);
                        _cCancelReason.clear();
                        if(!context.mounted) return;
                        FocusScope.of(context).unfocus();
                      }
                    },
                  ),
                ],
              ),
            );
          });
    } catch (e) {
      debugPrint('Exception - product_order_history_screen.dart - _cancelReasonDialog(): $e');
    }
  }

  _openMap(String? latitude, String? longitude) async {
    try {
      Uri googleUrl = Uri.parse('https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');
      if (await canLaunchUrl(googleUrl)) {
        await launchUrl(googleUrl);
      } else {
        throw 'Could not open the map.';
      }
    } catch (e) {
      debugPrint("Exception - product_order_history_detail_screen.dart - _openMap(): $e");
    }
  }
}
