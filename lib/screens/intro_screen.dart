import 'package:app/models/businessLayer/base_route.dart';
import 'package:app/screens/sign_in_screen.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class IntroScreen extends BaseRoute {
  const IntroScreen({super.key, super.a, super.o}) : super(r: 'IntroScreen');

  @override
  BaseRouteState<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends BaseRouteState<IntroScreen> {
  PageController? _pageController;
  int _currentIndex = 0;
  final List<String> _imageUrl = [
    'assets/intro_1.png',
    'assets/intro_2.png',
    'assets/intro_3.png',
  ];

  _IntroScreenState() : super();

  @override
  Widget build(BuildContext context) {
    List<IntroSH> titles = [
      IntroSH(heading: 'Discover & book local beauty professionals',title: 'A convenient way to browse professionals & book appointments at a time that works for you straight from your calendar.'),
      IntroSH(heading: 'Professional barber specialists',title: 'Ready for Your Next Haircut? When you get your hair cut with one of these barbers, it’s more than a cut, it’s an experience.'),
      IntroSH(heading: 'Find saloons Nearby',title: 'professionals can do anything! From fades to designs, this is the place you want to get your haircut!')
    ];

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        exitAppDialog();
      },
      child:
        Scaffold(
            body: PageView.builder(
                itemCount: _imageUrl.length,
                controller: _pageController,
                onPageChanged: (index) {
                  _currentIndex = index;
                  setState(() {});
                },
                itemBuilder: (BuildContext context, int index) {
                  return Stack(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: double.infinity,
                        child: Image.asset(
                          _imageUrl[index],
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                          filterQuality: FilterQuality.high,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).size.height * 0.31),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: DotsIndicator(
                            dotsCount: titles.length,
                            position: _currentIndex,
                            onTap: (i) {
                              index = i.toInt();
                              _pageController!.animateToPage(index,
                                  duration: const Duration(microseconds: 1),
                                  curve: Curves.easeInOut);
                            },
                            decorator: DotsDecorator(
                              activeSize: const Size(30, 10),
                              size: const Size(17, 10),
                              activeShape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50.0))),
                              activeColor: Theme.of(context).primaryColor,
                              color: Theme.of(context).primaryColorLight,
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: BottomSheet(
                            enableDrag: false,
                            onClosing: () {},
                            builder: (BuildContext context) {
                              return Container(
                                margin: const EdgeInsets.all(0),
                                decoration: const BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(30),
                                        topRight: Radius.circular(30))),
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 16, top: 10),
                                      child: Text(
                                        titles[index].heading!,
                                        style: Theme.of(context)
                                            .primaryTextTheme
                                            .titleSmall,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10, left: 10, right: 10),
                                      child: Text(
                                        titles[index].title!,
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .primaryTextTheme
                                            .titleMedium,
                                      ),
                                    ),
                                    index == 0 || index == 1
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              ElevatedButton(
                                                  style: ButtonStyle(
                                                      elevation:
                                                          WidgetStateProperty
                                                              .all(0),
                                                      backgroundColor:
                                                          WidgetStateProperty
                                                              .all(Colors
                                                                  .transparent)),
                                                  onPressed: () {},
                                                  child: const Text('')),
                                              ElevatedButton(
                                                onPressed: () {
                                                  _pageController!
                                                      .animateToPage(
                                                          _currentIndex + 1,
                                                          duration: const Duration(
                                                              microseconds:
                                                                  1),
                                                          curve: Curves
                                                              .easeInOut);
                                                },
                                                child: Text(
                                                  'Next',
                                                  style: Theme.of(context).textTheme.titleSmall,
                                                ),
                                              ),
                                              ElevatedButton(
                                                  style: ButtonStyle(
                                                      elevation:
                                                          WidgetStateProperty
                                                              .all(0),
                                                      backgroundColor:
                                                          WidgetStateProperty
                                                              .all(Colors
                                                                  .transparent)),
                                                  onPressed: () {
                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              SignInScreen(
                                                                a: widget
                                                                    .analytics,
                                                                o: widget
                                                                    .observer,
                                                              )),
                                                    );
                                                  },
                                                  child: Text(
                                                    AppLocalizations.of(context)!
                                                        .lbl_skip,
                                                    style: Theme.of(context)
                                                        .primaryTextTheme
                                                        .titleSmall,
                                                  ))
                                            ],
                                          )
                                        : ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        SignInScreen(
                                                          a: widget.analytics,
                                                          o: widget.observer,
                                                        )),
                                              );
                                            },
                                            child: Text(
                                              'Get Started',
                                              style: Theme.of(context).textTheme.titleSmall,
                                            ),
                                          ),
                                  ],
                                ),
                              );
                            }),
                      )
                    ],
                  );
                })
        ),
    );
  }


  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }
}

class IntroSH {
  String? heading;
  String? title;

  IntroSH({this.heading, this.title});
}
