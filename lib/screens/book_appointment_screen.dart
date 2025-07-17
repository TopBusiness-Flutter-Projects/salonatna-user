import 'dart:developer';

import 'package:app/models/book_appointment_model.dart';
import 'package:app/models/book_now_model.dart';
import 'package:app/models/businessLayer/base_route.dart';
import 'package:app/models/businessLayer/global.dart' as global;
import 'package:app/models/coupons_model.dart';
import 'package:app/models/service_type_model.dart';
import 'package:app/screens/payment_gateways_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:fdottedline_nullsafety/fdottedline__nullsafety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shimmer/shimmer.dart';

class BookAppointmentScreen extends BaseRoute {
  final int? vendorId;
  final int inSalon;
  const BookAppointmentScreen(this.vendorId,
      {super.key, super.a, super.o, required this.inSalon})
      : super(r: 'BookAppointmentScreen');
  @override
  BaseRouteState<BookAppointmentScreen> createState() =>
      _BookAppointmentScreenState();
}

class _BookAppointmentScreenState
    extends BaseRouteState<BookAppointmentScreen> {
  GlobalKey<ScaffoldState>? _scaffoldKey;
  List<Coupons>? _couponsList = [];
  bool _isCouponDataLoaded = false;
  BookNow? _bookNowDetails;
  BookNow? _applyRewardsOrCoupons;
  String? selectedCouponCode;
  String? selectedTimeSlot = '';
  String? barberName;
  int selectedStaffId = 0;
  final List<ServiceType> _selectedServiceType = [];
  BookAppointment? _bookingAppointment;
  bool _isDataLoaded = false;
  int _currentIndex = 0;
  int? selectedCoupon;
  PageController? _pageController;
  ScrollController? _scrollController;
  TabController? _tabController;
  DateTime? selectedDate;
  final int _initialIndex = 0;
  bool step1Done = false;
  bool step2Done = false;
  bool step3Done = false;
  bool step4Done = false;
  TextEditingController textController1 = TextEditingController();
  TextEditingController textController2 = TextEditingController();
  final DatePickerController _datePickerController = DatePickerController();

  final int _changeval = 7;
  _BookAppointmentScreenState() : super();

  @override
  Widget build(BuildContext context) {
    List<String> appointmentList = [
      AppLocalizations.of(context)!.lbl_choose_service,
      AppLocalizations.of(context)!.lbl_appointment,
      AppLocalizations.of(context)!.lbl_summary,
      AppLocalizations.of(context)!.lbl_payment
    ];

    return PopScope(
      canPop: true,
      child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text(
              AppLocalizations.of(context)!.txt_book_an_appointment,
              style: Theme.of(context).appBarTheme.titleTextStyle,
            ),
            leading: _currentIndex == 0
                ? null
                : IconButton(
                    onPressed: () {
                      _pageController!.animateToPage(_currentIndex - 1,
                          duration: const Duration(seconds: 1),
                          curve: Curves.fastOutSlowIn);
                      if (_currentIndex == 0) {
                        step1Done = false;
                      }
                      if (_currentIndex == 1) {
                        step2Done = false;
                      }
                      if (_currentIndex == 2) {
                        step3Done = false;
                      }

                      setState(() {});
                    },
                    icon: const Icon(Icons.arrow_back)),
            automaticallyImplyLeading: _currentIndex == 0 ? true : false,
          ),
          bottomNavigationBar: _isDataLoaded
              ? BottomAppBar(
                  color: const Color(0xFF171D2C),
                  child: SizedBox(
                    height: _currentIndex == 3 ? 55 : 60,
                    width: double.infinity,
                    child: _currentIndex == 3
                        ? Card(
                            color: const Color(0xFF3E424D),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0)),
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 15),
                                  child: Align(
                                    alignment: global.isRTL
                                        ? Alignment.centerLeft
                                        : Alignment.centerRight,
                                    child: Text(
                                      AppLocalizations.of(context)!
                                          .txt_swipe_to_confirm_your_booking,
                                      style: Theme.of(context)
                                          .primaryTextTheme
                                          .titleMedium,
                                    ),
                                  ),
                                ),
                                Dismissible(
                                  background: Card(
                                    elevation: 0,
                                    color: const Color(0xFFFA692C),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(0)),
                                  ),
                                  key: Key(_currentIndex.toString()),
                                  onDismissed: (_) {},
                                  confirmDismiss: (_) async {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PaymentGatewayScreen(
                                                a: widget.analytics,
                                                o: widget.observer,
                                                bookNowDetails: _bookNowDetails,
                                                screenId: 1,
                                              )),
                                    );
                                       return false; // Don't dismiss the item;
                                  },
                                  child: Row(
                                    children: [
                                      Container(
                                          decoration: const BoxDecoration(
                                              color: Color(0xFFFA692C),
                                              borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(10),
                                                  bottomRight:
                                                      Radius.circular(10))),
                                          width: 60,
                                          height: 55,
                                          child: Icon(
                                            MdiIcons.scissorsCutting,
                                            color: Colors.white,
                                            size: 20.0,
                                          )),
                                      const SizedBox()
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListTile(
                            tileColor: Colors.transparent,
                            title: RichText(
                                text: TextSpan(
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .titleMedium,
                                    children: [
                                  TextSpan(
                                      text: AppLocalizations.of(context)!
                                          .lbl_total_cost),
                                  TextSpan(
                                      text:
                                          '${global.currency.currencySign}${_getTotalCost()}')
                                ])),
                            trailing: SizedBox(
                              width: 120,
                              height: 35,
                              child: TextButton(
                                onPressed: () async {
                                  if (_currentIndex == 3) {
                                    return;
                                  } else {
                                    if (_currentIndex == 0) {
                                      if (_selectedServiceType.isEmpty) {
                                        showSnackBar(
                                            key: _scaffoldKey,
                                            snackBarMessage: AppLocalizations
                                                    .of(context)!
                                                .txt_please_select_atleast_one_service_to_procceed);
                                      } else {
                                        _pageController!.animateToPage(
                                            _currentIndex + 1,
                                            duration:
                                                const Duration(seconds: 1),
                                            curve: Curves.fastOutSlowIn);
                                      }

                                      step1Done = true;
                                    }
                                    if (_currentIndex == 1) {
                                      if (selectedTimeSlot == '') {
                                        showSnackBar(
                                            key: _scaffoldKey,
                                            snackBarMessage: AppLocalizations
                                                    .of(context)!
                                                .txt_please_select_timeslot_to_procceed);
                                      } else {
                                        _pageController!.animateToPage(
                                            _currentIndex + 1,
                                            duration:
                                                const Duration(seconds: 1),
                                            curve: Curves.fastOutSlowIn);

                                        for (int i = 0;
                                            i <
                                                _bookingAppointment!
                                                    .barber.length;
                                            i++) {
                                          if (_bookingAppointment!
                                                  .barber[i].staffId ==
                                              _bookingAppointment!.staffId) {
                                            barberName = _bookingAppointment!
                                                .barber[i].staffName;
                                          }
                                        }
                                        step2Done = true;
                                      }
                                    }
                                    if (_currentIndex == 2) {
                                      _pageController!.animateToPage(
                                          _currentIndex + 1,
                                          duration: const Duration(seconds: 1),
                                          curve: Curves.fastOutSlowIn);
                                      step3Done = true;
                                      await _bookNow();
                                    }
                                    setState(() {});
                                  }
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                        AppLocalizations.of(context)!.lbl_next),
                                  ],
                                ),
                              ),
                            ),
                          ),
                  ),
                )
              : null,
          body: _isDataLoaded
              ? (_bookingAppointment?.services.length ?? 0) > 0
                  ? Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.75,
                          height: 20,
                          margin: const EdgeInsets.only(
                              left: 10, right: 10, bottom: 0, top: 10),
                          child: Center(
                            child: ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                controller: _scrollController,
                                itemCount: appointmentList.length,
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (BuildContext context, int i) {
                                  return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.circle,
                                          size: 15,
                                          color: (i == _currentIndex) ||
                                                  (i == 0 && step1Done) ||
                                                  (i == 1 && step2Done) ||
                                                  (i == 2 && step3Done)
                                              ? Colors.red
                                              : Colors.grey,
                                        ),
                                        i == 3
                                            ? const SizedBox()
                                            : Container(
                                                height: 2,
                                                color:
                                                    (i == _currentIndex - 1) ||
                                                            (i == 1 - 1 &&
                                                                step2Done) ||
                                                            ((i == 2 - 1 &&
                                                                step3Done))
                                                        ? Colors.red
                                                        : Colors.black,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.75 /
                                                    4,
                                                margin: const EdgeInsets.all(0),
                                              ),
                                      ]);
                                }),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 30,
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(0),
                          child: Center(
                            child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: 4,
                              itemBuilder: (BuildContext context, int j) {
                                return Container(
                                  alignment: Alignment.center,
                                  width:
                                      (MediaQuery.of(context).size.width) / 4.3,
                                  child: Text(appointmentList[j],
                                      style: TextStyle(
                                          fontSize:
                                              j == _currentIndex ? 10.5 : 9.5,
                                          color: j == _currentIndex
                                              ? const Color(0xFF171D2C)
                                              : const Color(0xFF898A8D),
                                          fontWeight: j == _currentIndex
                                              ? FontWeight.w600
                                              : FontWeight.w400)),
                                );
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: PageView(
                            physics: const NeverScrollableScrollPhysics(),
                            controller: _pageController,
                            onPageChanged: (index) {
                              _currentIndex = index;
                              double currentIndex = _currentIndex.toDouble();
                              _scrollController!.animateTo(currentIndex,
                                  duration: const Duration(seconds: 1),
                                  curve: Curves.fastOutSlowIn);
                              setState(() {});
                            },
                            children: [
                              _chooseService(),
                              _appointment(),
                              _summary(),
                              _payment(),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Center(
                      child: Text(
                        AppLocalizations.of(context)!
                            .txt_nothing_is_yet_to_see_here,
                        style: Theme.of(context).primaryTextTheme.titleMedium,
                      ),
                    )
              : _shimmer()),
    );
  }

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
    _scrollController =
        ScrollController(initialScrollOffset: _currentIndex.toDouble());
    _pageController = PageController(initialPage: _currentIndex);
    _pageController!.addListener(() {});
    _init();
  }

  _applyRewardsAndCoupons(String type) async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        type == "coupon"
            ? await apiHelper!
                .applyRewardsAndCoupons(_bookNowDetails!.cartId, "coupon",
                    couponCode: selectedCouponCode)
                .then((result) {
                if (result != null) {
                  if (result.status == "1") {
                    _applyRewardsOrCoupons = result.recordList;
                    _bookNowDetails!.rewardDiscount = '${0}';
                    _bookNowDetails!.rewardDiscount =
                        _applyRewardsOrCoupons!.rewardDiscount;
                    _bookNowDetails!.couponDiscount =
                        _applyRewardsOrCoupons!.couponDiscount;
                    _bookNowDetails!.totalPrice =
                        _applyRewardsOrCoupons!.totalPrice;
                    _bookNowDetails!.remPrice =
                        _applyRewardsOrCoupons!.remPrice;

                    setState(() {});
                  } else {
                    showSnackBar(
                        key: _scaffoldKey,
                        snackBarMessage: result.message.toString());
                  }
                }
              })
            : await apiHelper!
                .applyRewardsAndCoupons(_bookNowDetails!.cartId, "rewards")
                .then((result) {
                if (result != null) {
                  if (result.status == "1") {
                    _applyRewardsOrCoupons = result.recordList;
                    _applyRewardsOrCoupons!.couponDiscount = '${0}';
                    _bookNowDetails!.couponDiscount =
                        _applyRewardsOrCoupons!.couponDiscount;
                    _bookNowDetails!.totalPrice =
                        _applyRewardsOrCoupons!.totalPrice;
                    _bookNowDetails!.remPrice =
                        _applyRewardsOrCoupons!.remPrice;
                    _bookNowDetails!.rewardDiscount =
                        _applyRewardsOrCoupons!.rewardDiscount;

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
      debugPrint(
          "Exception - book_appointment_screen.dart - _applyRewardsAndCoupons():$e");
    }
  }

  Widget _appointment() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 40,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _changeval < 1
                    ? const SizedBox(
                        width: 48,
                      )
                    : const IconButton(
                        onPressed: null,
                        icon: Icon(
                          Icons.keyboard_arrow_left,
                        ),
                      ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 80,
                    child: Center(
                      child: Text(
                        DateFormat('MMMM').format(DateTime.now()),
                        style: TextStyle(
                            color: Theme.of(context)
                                .primaryTextTheme
                                .headlineMedium!
                                .color),
                      ),
                    ),
                  ),
                ),
                const IconButton(
                  onPressed: null,
                  icon: Icon(
                    Icons.keyboard_arrow_right,
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: SizedBox(
              height: 100,
              child: DatePicker(
                DateTime.now(),
                controller: _datePickerController,
                dateTextStyle: Theme.of(context).primaryTextTheme.titleSmall!,
                dayTextStyle: Theme.of(context).primaryTextTheme.titleMedium!,
                monthTextStyle: Theme.of(context).primaryTextTheme.bodyLarge!,
                initialSelectedDate:
                    DateTime.parse(_bookingAppointment!.selectedDate!),
                selectionColor: const Color(0xFFFA692C),
                selectedTextColor: Colors.white,
                daysCount: 10,
                onDateChange: (date) {
                  setState(() {
                    _bookingAppointment!.selectedDate =
                        DateFormat('yyyy-MM-dd').format(date);
                    selectedDate = date;
                    _getTimeSlot();
                  });
                },
              ),
            ),
          ),
          GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            padding:
                const EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 20),
            shrinkWrap: true,
            crossAxisCount: 4,
            childAspectRatio: 5 / 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 8,
            children: List.generate(
                _bookingAppointment!.timeSlot!.length,
                (index) => GestureDetector(
                      onTap:
                          _bookingAppointment!.timeSlot![index].availibility ==
                                  true
                              ? () {
                                  selectedTimeSlot = _bookingAppointment!
                                      .timeSlot![index].timeslot;

                                  setState(() {});
                                }
                              : null,
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        color: selectedTimeSlot != '' &&
                                selectedTimeSlot ==
                                    _bookingAppointment!
                                        .timeSlot![index].timeslot
                            ? const Color(0xFFFA692C)
                            : _bookingAppointment!
                                        .timeSlot![index].availibility ==
                                    true
                                ? const Color(0xFFDADADA)
                                : Colors.white,
                        child: Center(
                            child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Text(
                            _bookingAppointment!.timeSlot![index].timeslot!,
                            style: selectedTimeSlot != '' &&
                                    selectedTimeSlot ==
                                        _bookingAppointment!
                                            .timeSlot![index].timeslot
                                ? const TextStyle(
                                    fontSize: 13,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400)
                                : _bookingAppointment!
                                            .timeSlot![index].availibility ==
                                        true
                                    ? Theme.of(context)
                                        .primaryTextTheme
                                        .bodyMedium
                                    : TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey.withOpacity(0.5),
                                        fontWeight: FontWeight.w400),
                          ),
                        )),
                      ),
                    )),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                    height: 15,
                    width: 15,
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      color: const Color(0xFFDADADA),
                    )),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    AppLocalizations.of(context)!.lbl_available_slot,
                    style: Theme.of(context).primaryTextTheme.titleSmall,
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
            child: RichText(
                text: TextSpan(children: [
              TextSpan(
                text: AppLocalizations.of(context)!.lbl_choose_hair_specialist,
                style: Theme.of(context).primaryTextTheme.titleSmall,
              ),
              TextSpan(
                text: AppLocalizations.of(context)!.lbl_optional,
                style: Theme.of(context).primaryTextTheme.titleMedium,
              ),
            ])),
          ),
          SizedBox(
            height: 80,
            child: ListView.builder(
                padding: const EdgeInsets.only(
                    left: 10, right: 10, top: 10, bottom: 10),
                scrollDirection: Axis.horizontal,
                itemCount: _bookingAppointment!.barber.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () async {
                      _bookingAppointment!.staffId =
                          _bookingAppointment!.barber[index].staffId;
                      await _getTimeSlot();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 7, right: 7),
                      child: SizedBox(
                        width: 200,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: global.isRTL
                                ? const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(30),
                                    bottomRight: Radius.circular(30),
                                    bottomLeft: Radius.circular(10),
                                  )
                                : const BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    topRight: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(30),
                                  ),
                          ),
                          color: _bookingAppointment!.staffId ==
                                  _bookingAppointment!.barber[index].staffId
                              ? const Color(0xFFFA692C)
                              : Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CachedNetworkImage(
                                imageUrl: global.baseUrlForImage +
                                    _bookingAppointment!
                                        .barber[index].staffImage!,
                                imageBuilder: (context, imageProvider) =>
                                    CircleAvatar(
                                  radius: 30,
                                  backgroundImage: imageProvider,
                                ),
                                placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  '${_bookingAppointment!.barber[index].staffName}',
                                  style: _bookingAppointment!.staffId ==
                                          _bookingAppointment!
                                              .barber[index].staffId
                                      ? Theme.of(context)
                                          .primaryTextTheme
                                          .labelSmall
                                      : Theme.of(context)
                                          .primaryTextTheme
                                          .titleSmall,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }

  _bookAppointment() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        await apiHelper!
            .bookAppointment(widget.vendorId, inSalon: widget.inSalon)
            .then((result) {
          if (result != null) {
            if (result.status == "1") {
              _bookingAppointment = result.recordList;
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
      debugPrint(
          "Exception - book_appointment_screen.dart - _bookAppointment():$e");
    }
  }

  _bookNow() async {
    try {
      BookNow bookNow = BookNow();
      bookNow.timeSlot = selectedTimeSlot;
      bookNow.deliveryDate = _bookingAppointment!.selectedDate;
      bookNow.staffId = _bookingAppointment!.staffId;
      bookNow.userId = global.user!.id;
      bookNow.vendorId = _bookingAppointment!.vendorId;
      bookNow.serviceTypeVariantIdList = _selectedServiceType;
      bookNow.inSalon = widget.inSalon;
 log("BookNow Details: ${bookNow.toJson()}");
log ("serviceTypeVariantId: ${bookNow.serviceTypeVariantIdList[0].variantId}");
log ("serviceTypeServiceId: ${bookNow.serviceTypeVariantIdList[0].serviceId}");
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        await apiHelper!.bookNow(bookNow).then((result) async {
          if (result != null) {
            if (result.status == "1") {
              _bookNowDetails = result.recordList;
              await _getCouponsList(_bookNowDetails!.cartId);

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
      debugPrint("Exception - book_appointment_screen.dart - _bookNow():$e");
    }
  }

  Widget _chooseService() {
    return ListView.builder(
        itemCount: _bookingAppointment!.services.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding:
                const EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 0),
            child: Card(
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.grey[400]!, width: 0.5),
                  borderRadius: BorderRadius.circular(3)),
              color: const Color(0xFFEEEEEE),
              child: ExpansionTile(
                initiallyExpanded: true,
                backgroundColor: Colors.transparent,
                collapsedBackgroundColor: Colors.transparent,
                tilePadding: const EdgeInsets.only(left: 16, right: 27),
                textColor: const Color(0xffedaa3a),
                collapsedTextColor: const Color(0xff543520),
                iconColor: const Color(0xFF565656),
                collapsedIconColor: const Color(0xFF565656),
                title: Text(
                    "${_bookingAppointment!.services[index].serviceName}",
                    style: Theme.of(context).primaryTextTheme.titleSmall),
                children: [
                  ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _bookingAppointment!
                          .services[index].serviceType.length,
                      itemBuilder: (BuildContext context, int i) {
                        int? hr;

                        hr = _bookingAppointment!
                            .services[index].serviceType[i].time;

                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 0, bottom: 0),
                              child: SizedBox(
                                height: 65,
                                child: ListTile(
                                  tileColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: Colors.grey[100]!, width: 0.5),
                                  ),
                                  title: Padding(
                                    padding: const EdgeInsets.only(left: 0),
                                    child: Text(
                                      '${_bookingAppointment!.services[index].serviceType[i].variant}',
                                      textAlign: TextAlign.justify,
                                      style: Theme.of(context)
                                          .primaryTextTheme
                                          .titleMedium,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                    ),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                          alignment: Alignment.centerRight,
                                          width: 65,
                                          child: Text('$hr m',
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Color(0xFF898A8D),
                                                  fontWeight:
                                                      FontWeight.w400))),
                                      const VerticalDivider(
                                        color: Color(0xFF898A8D),
                                        indent: 13,
                                        endIndent: 13,
                                        thickness: 1,
                                      ),
                                      SizedBox(
                                          width: 50,
                                          child: Text(
                                            widget.inSalon == 1
                                                ? '${global.currency.currencySign}${_bookingAppointment!.services[index].serviceType[i].price}'
                                                : '${global.currency.currencySign}${_bookingAppointment!.services[index].serviceType[i].priceOut}',
                                            
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontWeight:
                                                      FontWeight.w400))),
                                      IconButton(
                                          iconSize: 20,
                                          padding: const EdgeInsets.all(0),
                                          onPressed: () {
                                            if (_selectedServiceType.contains(
                                                _bookingAppointment!
                                                    .services[index]
                                                    .serviceType[i])) {
                                              _selectedServiceType.remove(
                                                  _bookingAppointment!
                                                      .services[index]
                                                      .serviceType[i]);
                                            } else {
                                              _selectedServiceType.add(
                                                  _bookingAppointment!
                                                      .services[index]
                                                      .serviceType[i]);
                                            }
                                            setState(() {});
                                          },
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          icon: _selectedServiceType.contains(
                                                  _bookingAppointment!
                                                      .services[index]
                                                      .serviceType[i])
                                              ? const Icon(Icons.circle)
                                              : const Icon(
                                                  Icons.circle_outlined)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      })
                ],
              ),
            ),
          );
        });
  }

  _getCouponsList(String? cartId) async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        await apiHelper!.getCouponsList(cartId).then((result) {
          if (result != null) {
            if (result.status == "1") {
              _couponsList = result.recordList;
              _isCouponDataLoaded = true;
              setState(() {});
            } else {
              _couponsList = [];
              _isCouponDataLoaded = true;
            }
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
    } catch (e) {
      debugPrint(
          "Exception - book_appointment_screen.dart - _getCouponsList():$e");
    }
  }

  _getTimeSlot() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        await apiHelper!
            .getTimeSLot(_bookingAppointment!.selectedDate,
                _bookingAppointment!.staffId, _bookingAppointment!.vendorId)
            .then((result) {
          if (result != null) {
            if (result.status == "1") {
              _bookingAppointment!.timeSlot = result.recordList;
              selectedTimeSlot = '';
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
      debugPrint(
          "Exception - book_appointment_screen.dart - _getTimeSlot():$e");
    }
  }

  String _getTotalCost() {
    int cost = 0;
    for (int i = 0; i < _selectedServiceType.length; i++) {
      widget.inSalon == 1 ? cost += _selectedServiceType[i].price! : cost += _selectedServiceType[i].priceOut!;
  
    }
    return cost.toString();
  }

  _init() async {
    try {
      await _bookAppointment();
      _isDataLoaded = true;
      setState(() {});
    } catch (e) {
      debugPrint("Exception - book_appointment_screen.dart - _init():$e");
    }
  }

  Widget _payment() {
    return _isCouponDataLoaded
        ? SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
                  child: SizedBox(
                    height: 40,
                    child: TabBar(
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicatorWeight: 0.1,
                        indicatorColor: Colors.transparent,
                        labelPadding: const EdgeInsets.only(
                            left: 0.5, right: 0.5, top: 0, bottom: 0),
                        onTap: (index) {
                          _tabController!.animateTo(index);
                          _tabController!.addListener(() {});
                          setState(() {});
                        },
                        controller: _tabController,
                        tabs: [
                          SizedBox(
                              height: double.infinity,
                              width: double.infinity,
                              child: Card(
                                  color: _tabController!.index == 0
                                      ? Colors.white
                                      : const Color(0xFFDADADA),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(2)),
                                  child: Center(
                                      child: Text(
                                          AppLocalizations.of(context)!
                                              .lbl_rewards,
                                          style:
                                              _tabController!.index == 0
                                                  ? Theme.of(context)
                                                      .primaryTextTheme
                                                      .headlineSmall
                                                  : Theme.of(context)
                                                      .primaryTextTheme
                                                      .titleSmall)))),
                          SizedBox(
                              height: double.infinity,
                              width: double.infinity,
                              child: Card(
                                  color: _tabController!.index == 1
                                      ? Colors.white
                                      : const Color(0xFFDADADA),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(2)),
                                  child: Center(
                                      child: Text(
                                          AppLocalizations.of(context)!
                                              .lbl_coupons,
                                          style:
                                              _tabController!.index == 1
                                                  ? Theme.of(context)
                                                      .primaryTextTheme
                                                      .headlineSmall
                                                  : Theme.of(context)
                                                      .primaryTextTheme
                                                      .titleSmall)))),
                        ]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
                  child: SizedBox(
                    height: 200,
                    child: DefaultTabController(
                      initialIndex: _initialIndex,
                      length: 2,
                      child: TabBarView(
                          physics: const NeverScrollableScrollPhysics(),
                          controller: _tabController,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '${global.user!.rewards}',
                                  style: Theme.of(context)
                                      .primaryTextTheme
                                      .headlineMedium,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      MdiIcons.wallet,
                                      size: 18,
                                    ),
                                    Text(
                                      AppLocalizations.of(context)!
                                          .txt_available_reward_points,
                                      style: Theme.of(context)
                                          .primaryTextTheme
                                          .titleSmall,
                                    ),
                                  ],
                                ),
                                global.user!.rewards != null &&
                                        global.user!.rewards != 0
                                    ? TextButton(
                                        child: Text(
                                            AppLocalizations.of(context)!
                                                .lbl_apply),
                                        onPressed: () async {
                                          await _applyRewardsAndCoupons(
                                              AppLocalizations.of(context)!
                                                  .lbl_rewards);
                                        },
                                      )
                                    : const SizedBox()
                              ],
                            ),
                            Center(
                                child: _couponsList!.isNotEmpty
                                    ? ListView.separated(
                                        itemCount: _couponsList!.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return ListTile(
                                            title: Text(
                                                '${_couponsList![index].couponName}'),
                                            subtitle: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${_couponsList![index].couponDescription}',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                Text(
                                                    '${AppLocalizations.of(context)!.lbl_validity} : ${DateFormat('dd MMM yy').format(_couponsList![index].startDate!)} - ${DateFormat('dd MMM yy').format(_couponsList![index].endDate!)}')
                                              ],
                                            ),
                                            trailing: GestureDetector(
                                              onTap: () async {
                                                if (selectedCouponCode ==
                                                    _couponsList![index]
                                                        .couponCode) {
                                                  selectedCouponCode = null;
                                                } else {
                                                  selectedCouponCode =
                                                      _couponsList![index]
                                                          .couponCode;
                                                  await _applyRewardsAndCoupons(
                                                      "coupon");
                                                }
                                                setState(() {});
                                              },
                                              child: selectedCouponCode ==
                                                      _couponsList![index]
                                                          .couponCode
                                                  ? SizedBox(
                                                      height: 33,
                                                      child: Card(
                                                        shape:
                                                            RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5)),
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5),
                                                          child: Text(
                                                              '${_couponsList![index].couponCode}'),
                                                        ),
                                                      ),
                                                    )
                                                  : SizedBox(
                                                      height: 40,
                                                      child: FDottedLine(
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        dottedLength: 4,
                                                        space: 2,
                                                        corner:
                                                            FDottedLineCorner
                                                                .all(5),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5),
                                                          child: Text(
                                                              '${_couponsList![index].couponCode}'),
                                                        ),
                                                      ),
                                                    ),
                                            ),
                                          );
                                        },
                                        separatorBuilder:
                                            (BuildContext context, int index) {
                                          return Divider(
                                            indent: 15,
                                            endIndent: 15,
                                            color:
                                                Theme.of(context).primaryColor,
                                          );
                                        },
                                      )
                                    : Text(
                                        AppLocalizations.of(context)!
                                            .txt_no_coupons_available,
                                        style: Theme.of(context)
                                            .primaryTextTheme
                                            .titleSmall,
                                      )),
                          ]),
                    ),
                  ),
                ),
                Divider(
                  indent: 15,
                  endIndent: 15,
                  color: Theme.of(context).primaryColor,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15, right: 15, top: 15, bottom: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(AppLocalizations.of(context)!.lbl_price_details,
                          style: Theme.of(context).primaryTextTheme.titleLarge),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(AppLocalizations.of(context)!.lbl_total_cost,
                          style:
                              Theme.of(context).primaryTextTheme.titleMedium),
                      Text('${global.currency.currencySign}${_getTotalCost()}')
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${AppLocalizations.of(context)!.lbl_rewards} ",
                          style:
                              Theme.of(context).primaryTextTheme.titleMedium),
                      Text(
                          _bookNowDetails!.rewardDiscount != null
                              ? '${global.currency.currencySign}${_bookNowDetails!.rewardDiscount}'
                              : '${global.currency.currencySign}0',
                          style: Theme.of(context).primaryTextTheme.titleSmall)
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 15, right: 15, bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${AppLocalizations.of(context)!.lbl_coupons} ",
                          style:
                              Theme.of(context).primaryTextTheme.titleMedium),
                      Text(
                          _bookNowDetails!.couponDiscount != null
                              ? "${global.currency.currencySign}${_applyRewardsOrCoupons!.couponDiscount}"
                              : "${global.currency.currencySign}0",
                          style: Theme.of(context).primaryTextTheme.titleSmall)
                    ],
                  ),
                ),
                Divider(
                  indent: 15,
                  endIndent: 15,
                  color: Theme.of(context).primaryColor,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15, right: 15, bottom: 5, top: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(AppLocalizations.of(context)!.lbl_total_amount,
                          style: Theme.of(context).primaryTextTheme.titleLarge),
                      Text(
                          '${global.currency.currencySign}${_bookNowDetails!.remPrice}',
                          style: Theme.of(context).primaryTextTheme.titleLarge)
                    ],
                  ),
                ),
              ],
            ),
          )
        : _shimmer1();
  }

  Widget _shimmer() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: 3,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 120,
                    height: 40,
                    child: const Card(
                        margin: EdgeInsets.only(top: 5, bottom: 5, left: 5)),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 220,
                    height: 40,
                    child: const Card(
                        margin: EdgeInsets.only(top: 5, bottom: 5, left: 5)),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 220,
                    height: 40,
                    child: const Card(
                        margin: EdgeInsets.only(top: 5, bottom: 5, left: 5)),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 200,
                    height: 40,
                    child: const Card(
                        margin: EdgeInsets.only(top: 5, bottom: 5, left: 5)),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              );
            }),
      ),
    );
  }

  Widget _shimmer1() {
    return Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 40,
                  child: const Card(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 200,
                  child: const Card(),
                ),
              ),
              Divider(
                indent: 15,
                endIndent: 15,
                color: Theme.of(context).primaryColor,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15, right: 15, top: 15, bottom: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: 40,
                      child: const Card(),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: 40,
                      child: const Card(),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: 40,
                      child: const Card(),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: 40,
                      child: const Card(),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: 40,
                      child: const Card(),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: 40,
                      child: const Card(),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: 40,
                      child: const Card(),
                    ),
                  ],
                ),
              ),
              Divider(
                indent: 15,
                endIndent: 15,
                color: Theme.of(context).primaryColor,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15, right: 15, bottom: 5, top: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: 40,
                      child: const Card(),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: 40,
                      child: const Card(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget _summary() {
    List<String?> list = [];
    for (int i = 0; i < _selectedServiceType.length; i++) {
      list.add(_selectedServiceType[i].serviceName);
      list = list.toSet().toList();
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          ListTile(
              horizontalTitleGap: 0,
              minLeadingWidth: 20,
              contentPadding: const EdgeInsets.only(
                left: 10,
                right: 10,
              ),
              leading: const Padding(
                padding: EdgeInsets.only(top: 4, bottom: 4, left: 0, right: 4),
                child: Icon(Icons.alarm, size: 15),
              ),
              title: Padding(
                padding:
                    const EdgeInsets.only(top: 4, bottom: 5, left: 4, right: 4),
                child: Text(
                    '${AppLocalizations.of(context)!.lbl_picking_time} : ${DateFormat('dd MMM yy').format(
                      DateTime.parse(_bookingAppointment!.selectedDate!),
                    )} $selectedTimeSlot',
                    style: Theme.of(context).primaryTextTheme.labelLarge),
              ),
              trailing: Padding(
                padding:
                    const EdgeInsets.only(top: 4, bottom: 4, left: 4, right: 0),
                child: Text('',
                    style: Theme.of(context).primaryTextTheme.bodyMedium),
              )),
          ListTile(
            horizontalTitleGap: 0,
            minLeadingWidth: 20,
            contentPadding: const EdgeInsets.only(
              left: 10,
              right: 10,
            ),
            leading: Padding(
              padding:
                  const EdgeInsets.only(top: 4, bottom: 4, left: 0, right: 4),
              child: Icon(MdiIcons.scissorsCutting, size: 15),
            ),
            title: Padding(
              padding:
                  const EdgeInsets.only(top: 4, bottom: 5, left: 4, right: 4),
              child: Text(
                  '${AppLocalizations.of(context)!.lbl_barbershop} : ${_bookingAppointment!.salonName}',
                  style: Theme.of(context).primaryTextTheme.labelLarge),
            ),
          ),
          ListTile(
              horizontalTitleGap: 0,
              minLeadingWidth: 20,
              contentPadding: const EdgeInsets.only(
                left: 10,
                right: 10,
              ),
              leading: const Padding(
                padding: EdgeInsets.only(top: 4, bottom: 4, left: 0, right: 4),
                child: Icon(Icons.phone_enabled, size: 15),
              ),
              title: Padding(
                padding:
                    const EdgeInsets.only(top: 4, bottom: 5, left: 4, right: 4),
                child: Text(
                    '${AppLocalizations.of(context)!.lbl_services} : ${list.join(",")} ',
                    style: Theme.of(context).primaryTextTheme.labelLarge),
              ),
              trailing: Padding(
                padding:
                    const EdgeInsets.only(top: 4, bottom: 4, left: 4, right: 0),
                child: Text('',
                    style: Theme.of(context).primaryTextTheme.bodyMedium),
              )),
          ListTile(
            horizontalTitleGap: 0,
            minLeadingWidth: 20,
            contentPadding: const EdgeInsets.only(
              left: 10,
              right: 10,
            ),
            leading: const Padding(
              padding: EdgeInsets.only(top: 4, bottom: 4, left: 0, right: 4),
              child: Icon(Icons.location_on_outlined, size: 15),
            ),
            title: Padding(
              padding:
                  const EdgeInsets.only(top: 4, bottom: 5, left: 4, right: 4),
              child: Text(
                  '${AppLocalizations.of(context)!.lbl_location}: ${_bookingAppointment!.vendorLoc}',
                  style: Theme.of(context).primaryTextTheme.labelLarge),
            ),
          ),
          ListTile(
              horizontalTitleGap: 0,
              minLeadingWidth: 20,
              contentPadding: const EdgeInsets.only(
                left: 10,
                right: 10,
              ),
              leading: const Padding(
                padding: EdgeInsets.only(top: 4, bottom: 4, left: 0, right: 4),
                child: Icon(Icons.male, size: 15),
              ),
              title: Padding(
                padding:
                    const EdgeInsets.only(top: 4, bottom: 5, left: 4, right: 4),
                child: Text(
                    '${AppLocalizations.of(context)!.lbl_barber}: $barberName ',
                    style: Theme.of(context).primaryTextTheme.labelLarge),
              ),
              trailing: Padding(
                padding:
                    const EdgeInsets.only(top: 4, bottom: 4, left: 4, right: 0),
                child: Text('',
                    style: Theme.of(context).primaryTextTheme.bodyMedium),
              )),
        ],
      ),
    );
  }
}
