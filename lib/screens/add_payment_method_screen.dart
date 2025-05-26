import 'package:app/models/businessLayer/base_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AddPaymentMethodScreen extends BaseRoute {
  const AddPaymentMethodScreen({super.key, super.a, super.o}) : super(r: 'AddPaymentMethodScreen');
  @override
  BaseRouteState<AddPaymentMethodScreen> createState() => _AddPaymentMethodScreenState();
}

class _AddPaymentMethodScreenState extends BaseRouteState<AddPaymentMethodScreen> {
  final TextEditingController _cCardNumber = TextEditingController();
  final TextEditingController _cCardHolderName = TextEditingController();
  final TextEditingController _cExpiryDate = TextEditingController();
  final TextEditingController _cCVV = TextEditingController();
  final FocusNode _fCardNumber = FocusNode();
  final FocusNode _fCardHolderName = FocusNode();
  final FocusNode _fExpiryDate = FocusNode();
  final FocusNode _fCVV = FocusNode();
  _AddPaymentMethodScreenState() : super();

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: true,
        child: sc(Scaffold(
            appBar: AppBar(
              title: const Text('Add Payment Method'),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 180,
                    width: 300,
                    margin: const EdgeInsets.all(20),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), image: const DecorationImage(fit: BoxFit.cover, image: AssetImage('assets/c2.jpg'))),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Card Number',
                            style: Theme.of(context).primaryTextTheme.titleMedium,
                          ))),
                  Padding(
                    padding: const EdgeInsets.only(top: 3, left: 10, right: 10),
                    child: SizedBox(
                        height: 50,
                        child: TextFormField(
                          textAlign: TextAlign.start,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(16),
                          ],
                          keyboardType: TextInputType.number,
                          autofocus: false,
                          cursorColor: const Color(0xFFFA692C),
                          enabled: true,
                          style: Theme.of(context).primaryTextTheme.titleLarge,
                          controller: _cCardNumber,
                          focusNode: _fCardNumber,
                          onEditingComplete: () {
                            _fCardHolderName.requestFocus();
                          },
                          decoration: InputDecoration(
                              suffixIcon: Icon(
                                Icons.credit_card_outlined,
                                color: Theme.of(context).iconTheme.color!.withOpacity(0.5),
                                size: 18,
                              ),
                              hintText: "Card Number"),
                        )),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Card Holder Name',
                            style: Theme.of(context).primaryTextTheme.titleMedium,
                          ))),
                  Padding(
                    padding: const EdgeInsets.only(top: 3, left: 10, right: 10),
                    child: SizedBox(
                        height: 50,
                        child: TextFormField(
                          textAlign: TextAlign.start,
                          autofocus: false,
                          cursorColor: const Color(0xFFFA692C),
                          enabled: true,
                          style: Theme.of(context).primaryTextTheme.titleLarge,
                          controller: _cCardHolderName,
                          focusNode: _fCardHolderName,
                          onEditingComplete: () {
                            _fExpiryDate.requestFocus();
                          },
                          decoration: InputDecoration(
                              suffixIcon: Icon(
                                Icons.person_outline,
                                color: Theme.of(context).iconTheme.color!.withOpacity(0.5),
                                size: 18,
                              ),
                              hintText: "Card Holder Name"),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                                padding: const EdgeInsets.only(top: 0, left: 0, right: 10),
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Expiry Date',
                                      style: Theme.of(context).primaryTextTheme.titleMedium,
                                    ))),
                            Padding(
                              padding: const EdgeInsets.only(right: 4, top: 3),
                              child: SizedBox(
                                  height: 50,
                                  width: MediaQuery.of(context).size.width / 2 - 20,
                                  child: TextFormField(
                                    textAlign: TextAlign.start,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    keyboardType: TextInputType.number,
                                    autofocus: false,
                                    cursorColor: const Color(0xFFFA692C),
                                    enabled: true,
                                    style: Theme.of(context).primaryTextTheme.titleLarge,
                                    controller: _cExpiryDate,
                                    focusNode: _fExpiryDate,
                                    onEditingComplete: () {
                                      _fCVV.requestFocus();
                                    },
                                    decoration: InputDecoration(
                                        suffixIcon: Icon(
                                          MdiIcons.calendar,
                                          color: Theme.of(context).iconTheme.color!.withOpacity(0.5),
                                          size: 18,
                                        ),
                                        hintText: "Expiry Date"),
                                  )),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                                padding: const EdgeInsets.only(top: 0, left: 0, right: 10),
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Security Code',
                                      style: Theme.of(context).primaryTextTheme.titleMedium,
                                    ))),
                            Padding(
                              padding: const EdgeInsets.only(left: 4),
                              child: SizedBox(
                                  height: 50,
                                  width: MediaQuery.of(context).size.width / 2 - 20,
                                  child: TextFormField(
                                    textAlign: TextAlign.start,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(3),
                                    ],
                                    keyboardType: TextInputType.number,
                                    autofocus: false,
                                    cursorColor: const Color(0xFFFA692C),
                                    enabled: true,
                                    style: Theme.of(context).primaryTextTheme.titleLarge,
                                    controller: _cCVV,
                                    focusNode: _fCVV,
                                    onEditingComplete: () {
                                      FocusScope.of(context).unfocus();
                                    },
                                    decoration: InputDecoration(
                                        suffixIcon: Icon(
                                          MdiIcons.keyVariant,
                                          color: Theme.of(context).iconTheme.color!.withOpacity(0.5),
                                          size: 18,
                                        ),
                                        hintText: "Security Code"),
                                  )),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                      height: 50,
                      width: 150,
                      margin: const EdgeInsets.only(top: 15),
                      child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Save'))),
                ],
              ),
            ))));
  }


}
