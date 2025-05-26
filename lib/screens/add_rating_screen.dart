import 'package:app/models/all_bookings_model.dart';
import 'package:app/models/businessLayer/base_route.dart';
import 'package:app/models/businessLayer/global.dart' as global;
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class AddRatingScreen extends BaseRoute {
  final AllBookings bookings;
  const AddRatingScreen(this.bookings, {super.key, super.a, super.o}) : super(r: 'AddRatingScreen');
  @override
  BaseRouteState<AddRatingScreen> createState() => _AddRatingScreenState();
}

class _AddRatingScreenState extends BaseRouteState<AddRatingScreen> {
  GlobalKey<ScaffoldState>? _scaffoldKey;
  final _cCommentShop = TextEditingController();
  final _fCommentShop = FocusNode();
  final _cCommentStaff = TextEditingController();
  final _fCommentStaff = FocusNode();
  double _shopRating = 0;
  double _staffRating = 0;

  _AddRatingScreenState() : super();

  @override
  Widget build(BuildContext context) {
    return sc(
      Scaffold(
        appBar: AppBar(
          title: const Text('Rate Your Experience'),
        ),
        body: SingleChildScrollView(
          child: Form(
            autovalidateMode: AutovalidateMode.always,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 5, left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Salon Name',
                        style: Theme.of(context).primaryTextTheme.titleMedium,
                      ),
                      Text(
                        '${widget.bookings.vendorName}',
                        style: Theme.of(context).primaryTextTheme.displaySmall,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5, left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Barber Name',
                        style: Theme.of(context).primaryTextTheme.titleMedium,
                      ),
                      Text(
                        '${widget.bookings.staffName}',
                        style: Theme.of(context).primaryTextTheme.displaySmall,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5, left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Cart Id',
                        style: Theme.of(context).primaryTextTheme.titleMedium,
                      ),
                      Text(
                        '${widget.bookings.cartId}',
                        style: Theme.of(context).primaryTextTheme.displaySmall,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5, left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total amount',
                        style: Theme.of(context).primaryTextTheme.titleMedium,
                      ),
                      Text(
                        '${global.currency.currencySign} ${widget.bookings.remPrice}',
                        style: Theme.of(context).primaryTextTheme.displaySmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Text("Rate Your Salon", style: Theme.of(context).primaryTextTheme.titleLarge),
                const SizedBox(
                  height: 10,
                ),
                RatingBar.builder(
                  initialRating: widget.bookings.vendorReview != null ? widget.bookings.vendorReview!.rating! : 0,
                  minRating: 0,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: 25,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  updateOnDrag: false,
                  onRatingUpdate: (rating) {
                    _shopRating = rating;
                    setState(() {});
                  },
                  tapOnlyMode: true,
                ),
                Container(
                  height: 80,
                  margin: const EdgeInsets.only(top: 15, left: 15, right: 15),
                  child: TextFormField(
                    validator: (text) {
                      if (text!.isEmpty || text == '') {
                        return 'Write review';
                      }
                      return null;
                    },
                    maxLines: 5,
                    controller: _cCommentShop,
                    focusNode: _fCommentShop,
                    style: Theme.of(context).primaryTextTheme.bodyLarge,
                    decoration: const InputDecoration(
                      hintText: 'Comment',
                      contentPadding: EdgeInsets.only(top: 10, left: 10, right: 10),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Text("Rate Your Barber", style: Theme.of(context).primaryTextTheme.titleLarge),
                const SizedBox(
                  height: 10,
                ),
                RatingBar.builder(
                  initialRating: widget.bookings.staffReview != null ? widget.bookings.staffReview!.rating! : 0,
                  minRating: 0,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: 25,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  updateOnDrag: false,
                  onRatingUpdate: (rating) {
                    _staffRating = rating;
                    setState(() {});
                  },
                  tapOnlyMode: true,
                ),
                Container(
                  height: 80,
                  margin: const EdgeInsets.only(top: 15, left: 15, right: 15),
                  child: TextFormField(
                    validator: (text) {
                      if (text!.isEmpty || text == '') {
                        return 'Write review';
                      }
                      return null;
                    },
                    maxLines: 5,
                    controller: _cCommentStaff,
                    focusNode: _fCommentStaff,
                    style: Theme.of(context).primaryTextTheme.bodyLarge,
                    decoration: const InputDecoration(
                      hintText: 'Comment',
                      contentPadding: EdgeInsets.only(top: 10, left: 10, right: 10),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(),
            widget.bookings.vendorReview != null && widget.bookings.staffReview != null
                ? const SizedBox()
                : TextButton(
                    onPressed: () async {
                      FocusScope.of(context).unfocus();
                      if (_cCommentShop.text.isEmpty) {
                        _cCommentShop.text = "";
                      }
                      if (_cCommentStaff.text.isEmpty) {
                        _cCommentStaff.text = "";
                      }

                      if (_cCommentShop.text.isNotEmpty && _cCommentStaff.text.isNotEmpty && widget.bookings.staffReview == null && widget.bookings.vendorReview == null) {
                        await _addSalonRating();
                        await _addStaffRating();
                        if(!context.mounted) return;
                        Navigator.of(context).pop();
                      } else if (widget.bookings.vendorReview == null && _cCommentShop.text.isNotEmpty) {
                        await _addSalonRating();
                        if(!context.mounted) return;
                        Navigator.of(context).pop();
                      } else if (widget.bookings.staffReview == null && _cCommentStaff.text.isNotEmpty) {
                        await _addStaffRating();
                        if(!context.mounted) return;
                        Navigator.of(context).pop();
                      } else if (_cCommentShop.text.isEmpty) {
                        showSnackBar(snackBarMessage: 'Please write your review for salon');
                      } else if (_cCommentStaff.text.isEmpty) {
                        showSnackBar(snackBarMessage: 'Please write your review for salon staff');
                      }
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Submit Rating'),
                    )),
            const SizedBox(),
          ],
        ),
      ),
    );
  }


  @override
  void initState() {
    super.initState();
    _init();
  }

  _addSalonRating() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        await apiHelper!.addSalonRating(global.user!.id, widget.bookings.vendorId, _shopRating, _cCommentShop.text).then((result) {
          if (result != null) {
            if (result.status == "1") {
              widget.bookings.vendorReview ??= ReviewRating();
              widget.bookings.vendorReview!.rating = _shopRating;
              widget.bookings.vendorReview!.description = _cCommentShop.text;
              setState(() {});
            } else if (result.status == "0") {
              setState(() {});
            }
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
    } catch (e) {
      debugPrint("Exception - add_rating_screen.dart - _addSalonRating():$e");
    }
  }

  _addStaffRating() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        await apiHelper!.addStaffRating(global.user!.id, widget.bookings.staffId, _staffRating, _cCommentStaff.text).then((result) {
          if (result != null) {
            if (result.status == "1") {
              widget.bookings.staffReview ??= ReviewRating();
              widget.bookings.staffReview!.rating = _staffRating;
              widget.bookings.staffReview!.description = _cCommentStaff.text;
              setState(() {});
            } else if (result.status == "0") {
              setState(() {});
            }
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
    } catch (e) {
      debugPrint("Exception - add_rating_screen.dart - _addStaffRating():$e");
    }
  }

  _init() {
    if (widget.bookings.vendorReview != null) {
      _cCommentShop.text = widget.bookings.vendorReview!.description!;
    } else {
      _cCommentShop.text = "";
    }
    if (widget.bookings.staffReview != null) {
      _cCommentStaff.text = widget.bookings.staffReview!.reviewDescription!;
    } else {
      _cCommentStaff.text = "";
    }
  }
}
