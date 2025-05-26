import 'package:app/models/businessLayer/base_route.dart';
import 'package:app/screens/barber_shop_list_screen.dart';
import 'package:app/screens/favorites_screen.dart';
import 'package:app/screens/home_screen.dart';
import 'package:app/screens/location_screen.dart';
import 'package:app/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:app/models/businessLayer/global.dart' as global;
import 'package:flutter/services.dart';

class BottomNavigationWidget extends BaseRoute {
  final int? screenId;

  const BottomNavigationWidget({super.key, super.a, super.o, this.screenId}) : super(r: 'BottomNavigationWidget');

  @override
  BaseRouteState<BottomNavigationWidget> createState() => _BottomNavigationWidgetState();
}

class _BottomNavigationWidgetState extends BaseRouteState<BottomNavigationWidget> {
  int? _currentIndex = 0;
  int? locationIndex = 0;
  _BottomNavigationWidgetState() : super();


  @override
  void initState() {
    super.initState();
    _currentIndex = widget.screenId ?? 0;
    if (widget.screenId != null && widget.screenId == 1) {
      locationIndex = widget.screenId;
      // widget.screenId = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: BottomAppBar(
            notchMargin: 2,
            shape: const CircularNotchedRectangle(),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
              child: SizedBox(
                height: 60,
                child: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  currentIndex: _currentIndex!,
                  unselectedFontSize: 0,
                  selectedFontSize: 0,
                  onTap: (index) {
                    _currentIndex = index;
                    locationIndex = 0;
                    setState(() {});
                  },
                  items: [
                    const BottomNavigationBarItem(
                      label: '',
                      icon: Icon(Icons.home_outlined),
                      tooltip: 'Home',
                    ),
                    BottomNavigationBarItem(
                        label: '',
                        tooltip: 'Location',
                        icon: Padding(
                          padding: global.isRTL ? const EdgeInsets.only(left: 15) : const EdgeInsets.only(right: 15),
                          child: const Icon(Icons.location_on_outlined),
                        )),
                    BottomNavigationBarItem(
                        label: '',
                        tooltip: 'Favorite',
                        icon: Padding(
                          padding: global.isRTL ? const EdgeInsets.only(right: 15) : const EdgeInsets.only(left: 15),
                          child: const Icon(Icons.favorite_outline_outlined),
                        )),
                    const BottomNavigationBarItem(label: '', icon: Icon(Icons.person_outline), tooltip: 'Profile')
                  ],
                ),
              ),
            )),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: CircleAvatar(
          radius: 23,
          backgroundColor: Colors.white,
          child: FloatingActionButton(
            elevation: 0,
            mini: true,
            backgroundColor: const Color(0xFFFA692C),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => BarberShopListScreen(a: widget.analytics, o: widget.observer)),
              );
            },
            child: const Icon(Icons.calendar_today_rounded),
          ),
        ),
        body: screens().elementAt(_currentIndex!),
      ),
    );
  }

  List<Widget> screens() => [
        HomeScreen(a: widget.analytics, o: widget.observer),
        LocationScreen(
          a: widget.analytics,
          o: widget.observer,
          screenId: locationIndex,
        ),
        FavouritesScreen(a: widget.analytics, o: widget.observer),
        ProfileScreen(a: widget.analytics, o: widget.observer)
      ];
}
