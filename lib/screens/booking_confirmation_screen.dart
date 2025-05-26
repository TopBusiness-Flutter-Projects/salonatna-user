import 'dart:io';

import 'package:app/models/businessLayer/base_route.dart';
import 'package:app/models/businessLayer/global.dart' as global;
import 'package:app/widgets/bottom_navigation_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BookingConfirmationScreen extends BaseRoute {
  final int? screenId;
  const BookingConfirmationScreen({super.key, super.a, super.o, this.screenId}) : super(r: 'BookingConfirmationScreen');
  @override
  BaseRouteState<BookingConfirmationScreen> createState() => _BookingConfirmationScreenState();
}

class _BookingConfirmationScreenState extends BaseRouteState<BookingConfirmationScreen> {

  _BookingConfirmationScreenState() : super();

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: true,
        onPopInvoked: (bool didPop) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        },
        child: sc(Scaffold(
            bottomNavigationBar: Container(
              decoration: const BoxDecoration(color: Color(0xFF171D2C), borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))),
              height: Platform.isIOS ? 68 : 60,
              padding: const EdgeInsets.only(
                left: 100,
                right: 100,
              ),
              child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(2)),
                  child: Padding(
                    padding: EdgeInsets.only(top: 8.0, bottom: Platform.isIOS ? 16.0 : 8.0),
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => BottomNavigationWidget(
                                    a: widget.analytics,
                                    o: widget.observer,
                                  )),
                        );
                      },
                      child: Text(AppLocalizations.of(context)!.lbl_finish),
                    ),
                  )),
            ),
            body: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 120),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(),
                      child: Container(
                        decoration: const BoxDecoration(image: DecorationImage(fit: BoxFit.fill, image: AssetImage('assets/greatekan3.png'))),
                        width: 200,
                        height: 200,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 25),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Great ${global.user!.name}',
                            style: Theme.of(context).primaryTextTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: widget.screenId == 1
                          ? Text('Your order has been placed successfully, please pick your items from store ASAP', textAlign: TextAlign.center, style: Theme.of(context).primaryTextTheme.titleMedium)
                          : Text('Your booking has been placed successfully, you will receive a notification/sms about your booking status', textAlign: TextAlign.center, style: Theme.of(context).primaryTextTheme.titleMedium),
                    ),
                  ],
                )))));
  }


}
