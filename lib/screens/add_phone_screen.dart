import 'dart:io';

import 'package:app/models/businessLayer/base_route.dart';
import 'package:app/models/businessLayer/global.dart' as global;
import 'package:app/models/user_model.dart';
import 'package:app/screens/otp_verification_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:mobile_number/mobile_number.dart';
import 'package:permission_handler/permission_handler.dart';

class AddPhoneScreen extends BaseRoute {
  const AddPhoneScreen({super.key, super.a, super.o}) : super(r: 'AddPhoneScreen');

  @override
  BaseRouteState<AddPhoneScreen> createState() => _AddPhoneScreenState();
}

class _AddPhoneScreenState extends BaseRouteState<AddPhoneScreen> {
  final TextEditingController _cPhoneNumber = TextEditingController();
  final _fPhoneNumber = FocusNode();
  GlobalKey<ScaffoldState>? _scaffoldKey;
  bool showOtpTextBox = false;
  List<SimCard> _simCard = <SimCard>[];
  _AddPhoneScreenState() : super();

  @override
  Widget build(BuildContext context) {
    return sc(PopScope(
      canPop: true,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(),
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  AppLocalizations.of(context)!.txt_connect_with_phone,
                  style: Theme.of(context).primaryTextTheme.bodySmall,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(AppLocalizations.of(context)!.txt_you_will_receive_otp_on_this_number, textAlign: TextAlign.center, style: Theme.of(context).primaryTextTheme.displaySmall),
                ),
                    Container(
                      margin: EdgeInsets.only(top: 70),
                      // height: 50,
                      child: IntlPhoneField(
                        decoration: InputDecoration(hintText: AppLocalizations.of(context)!.lbl_mobile),
                    controller: _cPhoneNumber,
                        initialCountryCode: 'EG',
                        showCountryFlag: false,
                        onCountryChanged: (country) {
                          phoneCodeintl = '+' + country.fullCountryCode;
                          print("sssssssssssss$phoneCodeintl");

                          print("sssssssssssss$phoneCodeintl");
                        },
                        onChanged: (phone) {
                          print(phone.completeNumber);
                        },
                        textAlign: TextAlign.start,
                        autofocus: false,
                        cursorColor: Color(0xFFF36D86),
                        enabled: true,
                        
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.number,
                           style: Theme.of(context).primaryTextTheme.titleLarge,
                    focusNode: _fPhoneNumber,
                      ),
                    ),
                // Padding(
                //   padding: const EdgeInsets.only(top: 70.0),
                //   child: TextFormField(
                //     textAlign: TextAlign.start,
                //     autofocus: false,
                //     cursorColor: const Color(0xFFFA692C),
                //     enabled: true,
                //     inputFormatters: [
                //       FilteringTextInputFormatter.digitsOnly,
                //       LengthLimitingTextInputFormatter(10),
                //     ],
                //     textInputAction: TextInputAction.done,
                //     keyboardType: TextInputType.number,
                //     style: Theme.of(context).primaryTextTheme.titleLarge,
                //     controller: _cPhoneNumber,
                //     focusNode: _fPhoneNumber,
                //     maxLength: 10,
                //     decoration: InputDecoration(
                //       hintText: AppLocalizations.of(context)!.lbl_phone_number,
                //       counterText: '',
                //       prefixIcon: const Icon(Icons.email),
                //     ),
                //     onEditingComplete: () {
                //       FocusScope.of(context).unfocus();
                //     },
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.only(top: 70.0),
                  child: ElevatedButton(
                      onPressed: () {
                        _loginWithPhone();
                      },
                      child: Text(
                        AppLocalizations.of(context)!.btn_send_otp,
                        style: TextStyle(color: Colors.white)
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }

  Future<void> initMobileNumberState() async {
    String mobileNumber = '';
    try {
      _simCard = (await MobileNumber.getSimCards!);
      _simCard.removeWhere((e) => e.number == '' || e.number == null || e.number!.contains(RegExp(r'[A-Z]')));
      if (_simCard.length > 1) {
        await _selectPhoneNumber();
      } else if (_simCard.isNotEmpty) {
        mobileNumber = _simCard[0].number!.substring(_simCard[0].number!.length - 10);
      }
    } on PlatformException catch (e) {
      debugPrint("Failed to get mobile number because of '${e.message}'");
    }

    if (!mounted) return;

    setState(() {
      _cPhoneNumber.text = mobileNumber;
    });
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() async {
    try {
      PermissionStatus permissionStatus = await Permission.phone.status;
      if (Platform.isAndroid && permissionStatus.isGranted) {
        await initMobileNumberState();
      }
    } catch (e) {
      debugPrint("Exception - add_phone_screen.dart - _init():$e");
    }
  }

  _loginWithPhone() async {
    try {
      CurrentUser tUser = CurrentUser();
      debugPrint(_cPhoneNumber.text.trim());
      debugPrint(global.appDeviceId);
      tUser.userPhone = _cPhoneNumber.text.trim();
      tUser.deviceId = global.appDeviceId;

      if (_cPhoneNumber.text.isNotEmpty && _cPhoneNumber.text.trim().length == 10) {
        bool isConnected = await br.checkConnectivity();
        if (isConnected) {
          showOnlyLoaderDialog();
          await apiHelper!.loginWithPhone(tUser).then((result) async {
            if (result != null) {
              if (result.status == "1") {
                await _sendOTP(_cPhoneNumber.text.trim());
              } else {
                hideLoader();
                showSnackBar(key: _scaffoldKey, snackBarMessage: '${result.message}');
              }
            }
          });

          setState(() {});
        } else {
          showNetworkErrorSnackBar(_scaffoldKey);
        }
      } else if (_cPhoneNumber.text.isEmpty || _cPhoneNumber.text.trim().length < 10) {
        showSnackBar(key: _scaffoldKey, snackBarMessage: AppLocalizations.of(context)!.txt_please_enter_valid_contact_no);
      }
    } catch (e) {
      debugPrint("Exception - add_phone_screen.dart - _loginWithPhone():$e");
    }
  }

  _selectPhoneNumber() {
    try {
      showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) => CupertinoActionSheet(
          title: Text(AppLocalizations.of(context)!.txt_select_phonenumber),
          actions: _simCard
              .map((e) => CupertinoActionSheetAction(
                    child: Text(e.number!.substring(e.number!.length - 10)),
                    onPressed: () async {
                      setState(() {
                        _cPhoneNumber.text = e.number!.substring(e.number!.length - 10);
                      });
                      Navigator.pop(context);
                    },
                  ))
              .toList(),
          cancelButton: CupertinoActionSheetAction(
            child: Text(AppLocalizations.of(context)!.lbl_cancel),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      );
    } catch (e) {
      debugPrint("Exception - add_phone_screen.dart - _showCupertinoModalSheet():$e");
    }
  }
 String phoneCodeintl = '+20';

  _sendOTP(String phoneNumber) async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '$phoneCodeintl$phoneNumber',
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          hideLoader();
          showSnackBar(key: _scaffoldKey, snackBarMessage: AppLocalizations.of(context)!.txt_please_try_again_after_sometime);
        },
        codeSent: (String verificationId, int? resendToken) async {
          hideLoader();
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => OTPVerificationScreen(
                      a: widget.analytics,
                      o: widget.observer,
                      screenId: 1,
                      verificationId: verificationId,
                      phoneNumberOrEmail: phoneNumber,
                      phoneCodeintl2: phoneCodeintl,
                    )),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      debugPrint("Exception - add_phone_screen.dart - _sendOTP():$e");
    }
  }
}
