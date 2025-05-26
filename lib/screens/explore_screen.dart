import 'package:app/models/businessLayer/base_route.dart';
import 'package:app/widgets/bottom_navigation_widget.dart';
import 'package:flutter/material.dart';

class ExploreScreen extends BaseRoute {
  const ExploreScreen({super.key, super.a, super.o}) : super(r: 'ExploreScreen');
  @override
  BaseRouteState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends BaseRouteState<ExploreScreen> {
  _ExploreScreenState() : super();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        exitAppDialog();
      },
      child: sc(Scaffold(
          body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/exploreImg.png',
              height: 300,
              width: double.infinity,
            ),
            Text(
              'You are ready to go!',
              style: Theme.of(context).primaryTextTheme.bodySmall,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Text('Thanks for taking your time to create an account with us. Now this is the fun part, let\'s experience this app.', textAlign: TextAlign.center, style: Theme.of(context).primaryTextTheme.displaySmall),
            ),
            Container(
                height: 50,
                width: 250,
                margin: const EdgeInsets.only(top: 40),
                child: TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => BottomNavigationWidget(a: widget.analytics, o: widget.observer)),
                      );
                    },
                    child: const Text('Let\'s explore'))),
          ],
        ),
      ))),
    );
  }


}
