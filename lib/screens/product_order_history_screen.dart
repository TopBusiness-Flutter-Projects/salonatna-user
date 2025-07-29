import 'package:app/models/businessLayer/base_route.dart';
import 'package:app/models/businessLayer/global.dart' as global;
import 'package:app/models/product_order_history_model.dart';
import 'package:app/screens/product_order_history_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';

class ProductOrderHistoryScreen extends BaseRoute {
  const ProductOrderHistoryScreen({super.key, super.a, super.o})
      : super(r: 'ProductOrderHistoryScreen');

  @override
  BaseRouteState<ProductOrderHistoryScreen> createState() =>
      _ProductOrderHistoryScreenState();
}

class _ProductOrderHistoryScreenState
    extends BaseRouteState<ProductOrderHistoryScreen> {
  GlobalKey<ScaffoldState>? _scaffoldKey;
  List<ProductOrderHistory>? _productOrderHistoryList = [];
  bool _isDataLoaded = false;

  _ProductOrderHistoryScreenState() : super();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: Scaffold(
          appBar: AppBar(
            title: RichText(
              text: TextSpan(
                  text: AppLocalizations.of(context)!.lbl_my_orders,
                  style: Theme.of(context).appBarTheme.titleTextStyle,
                  children: [
                    TextSpan(
                        text: AppLocalizations.of(context)!
                            .txt_store_pick_up_only,
                        style: Theme.of(context).primaryTextTheme.titleMedium)
                  ]),
            ),
          ),
          body: _isDataLoaded
              ? _productOrderHistoryList != null &&
                      _productOrderHistoryList!.isNotEmpty
                  ? ListView.builder(
                      itemCount: _productOrderHistoryList!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ProductOrderHistoryDetailScreen(
                                        _productOrderHistoryList![index],
                                        a: widget.analytics,
                                        o: widget.observer,
                                      )),
                            );
                          },
                          child: Card(
                              margin: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                              child: ListTile(
                                title: Text(
                                    '${_productOrderHistoryList![index].cartId}',
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .titleSmall),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 6.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(
                                        child: Container(
                                          width: 40,
                                          decoration: BoxDecoration(
                                            borderRadius: global.isRTL
                                                ? const BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(5.0),
                                                    bottomRight:
                                                        Radius.circular(5.0),
                                                  )
                                                : const BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(5.0),
                                                    bottomLeft:
                                                        Radius.circular(5.0),
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
                                              AppLocalizations.of(context)!
                                                  .lbl_items,
                                              style: Theme.of(context)
                                                  .primaryTextTheme
                                                  .bodyMedium,
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
                                                  bottomLeft:
                                                      Radius.circular(5.0),
                                                )
                                              : const BorderRadius.only(
                                                  topRight:
                                                      Radius.circular(5.0),
                                                  bottomRight:
                                                      Radius.circular(5.0),
                                                ),
                                          border: Border.all(
                                            color: Colors.grey[200]!,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "${_productOrderHistoryList![index].count}",
                                            style: Theme.of(context)
                                                .primaryTextTheme
                                                .bodyMedium,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            height: 22,
                                            width: 90,
                                            decoration: BoxDecoration(
                                              color: _productOrderHistoryList![
                                                              index]
                                                          .status ==
                                                      4
                                                  ? Colors.grey
                                                  : _productOrderHistoryList![
                                                                  index]
                                                              .status ==
                                                          3
                                                      ? Colors.red
                                                      : _productOrderHistoryList![
                                                                      index]
                                                                  .status ==
                                                              1
                                                          ? Colors.amber
                                                          : Colors.green[600],
                                              borderRadius:
                                                  BorderRadius.circular(7.0),
                                            ),
                                            padding: const EdgeInsets.only(
                                                left: 5, right: 5),
                                            child: Center(
                                              child: Text(
                                                _productOrderHistoryList![index]
                                                            .status ==
                                                        4
                                                    ? AppLocalizations.of(
                                                            context)!
                                                        .lbl_cancelled
                                                    : _productOrderHistoryList![index]
                                                                .status ==
                                                            3
                                                        ? AppLocalizations.of(
                                                                context)!
                                                            .lbl_failed
                                                        : _productOrderHistoryList![
                                                                        index]
                                                                    .status ==
                                                                1
                                                            ? AppLocalizations
                                                                    .of(
                                                                        context)!
                                                                .lbl_pending
                                                            : AppLocalizations
                                                                    .of(context)!
                                                                .lbl_completed,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 4.0),
                                      child: SizedBox(
                                        width: 80,
                                        child: Column(
                                          crossAxisAlignment: global.isRTL
                                              ? CrossAxisAlignment.end
                                              : CrossAxisAlignment.end,
                                          children: [
                                            SizedBox(
                                              height: 15,
                                              child: Text(
                                                DateFormat('hh:mm a').format(
                                                    _productOrderHistoryList![
                                                            index]
                                                        .createdAt!),
                                                textAlign: TextAlign.right,
                                                style: Theme.of(context)
                                                    .primaryTextTheme
                                                    .bodyMedium,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 15,
                                              child: Text(
                                                DateFormat('dd/MM/yyyy').format(
                                                    _productOrderHistoryList![
                                                            index]
                                                        .createdAt!),
                                                textAlign: TextAlign.right,
                                                style: Theme.of(context)
                                                    .primaryTextTheme
                                                    .bodyMedium,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20,
                                              child: Text(
                                                '${global.currency.currencySign!} ${_productOrderHistoryList![index].totalPrice!}',
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        );
                      })
                  :
                  // Center(
                  //             child: Text(
                  //               AppLocalizations.of(context)!.txt_no_order_yet,
                  //               style: Theme.of(context).primaryTextTheme.titleSmall,
                  //             ),
                  //           )
                  Center(
                      child: Lottie.asset(
                        'assets/json/no task.json',
                        fit: BoxFit.contain,
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

  _getProductOrderHistory() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        await apiHelper!.getProductOrderHistory().then((result) {
          if (result != null) {
            if (result.status == "1") {
              _productOrderHistoryList = result.recordList;
              _isDataLoaded = true;
              setState(() {});
            } else if (result.status == "0") {
              _productOrderHistoryList = null;
              _isDataLoaded = true;
              setState(() {});
            }
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
    } catch (e) {
      debugPrint(
          "Exception - product_order_history_screen.dart - _getProductOrderHistory():$e");
    }
  }

  _init() async {
    await _getProductOrderHistory();
  }

  Widget _shimmer() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: 10,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                margin: const EdgeInsets.all(8),
                height: 65,
                width: MediaQuery.of(context).size.width,
                child: const Card(),
              );
            }),
      ),
    );
  }
}
