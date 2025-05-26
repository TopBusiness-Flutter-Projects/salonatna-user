import 'package:app/models/businessLayer/base.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BaseRoute extends Base {
  const BaseRoute({super.key, a, o, r}) : super(routeName: r, analytics: a, observer: o);

  @override
  BaseRouteState createState() => BaseRouteState();
}

class BaseRouteState<T extends BaseRoute> extends BaseState<T> with RouteAware {
  BaseRouteState() : super();

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.observer!.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    _setCurrentScreen();
    _sendAnalyticsEvent();
  }

  @override
  void didPush() {
    _setCurrentScreen();
    _sendAnalyticsEvent();
  }

  @override
  void dispose() {
    widget.observer!.unsubscribe(this);
    super.dispose();
  }

  @override
  void hideLoader() {
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    _setCurrentScreen();
    _sendAnalyticsEvent();
  }

  Future<void> _sendAnalyticsEvent() async {
    await widget.observer!.analytics.logEvent(
      name: widget.routeName!,
    );
  }

  Future<void> _setCurrentScreen() async {
    await widget.observer!.analytics.logScreenView(
      screenName: widget.routeName,
      screenClass: widget.routeName!,
    );
  }
}
