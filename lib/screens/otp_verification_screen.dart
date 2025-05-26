import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:app/models/businessLayer/base_route.dart';
import 'package:app/models/businessLayer/global.dart' as global;
import 'package:app/screens/cookies_policy_screen.dart';
import 'package:app/screens/explore_screen.dart';
import 'package:app/screens/privacy_and_policy.dart';
import 'package:app/screens/reset_password_screen.dart';
import 'package:app/screens/terms_of_services_screen.dart';
import 'package:app/widgets/bottom_navigation_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:otp_autofill/otp_autofill.dart';
import 'package:sms_autofill/sms_autofill.dart';

class OTPVerificationScreen extends BaseRoute {
  final int? screenId;
  final String? verificationId;
  final String? phoneNumberOrEmail;
  const OTPVerificationScreen({super.key, super.a, super.o, this.screenId, this.verificationId, this.phoneNumberOrEmail}) : super(r: 'OTPVerificationScreen');
  @override
  BaseRouteState<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends BaseRouteState<OTPVerificationScreen> {
  GlobalKey<ScaffoldState>? _scaffoldKey;
  int _seconds = 60;
  late Timer _countDown;
  var _cCode = TextEditingController();
  String? status;

  _OTPVerificationScreenState() : super();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: sc(Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          automaticallyImplyLeading: false,
        ),
        body: widget.screenId == 2
            ? SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: 0, bottom: 0, left: 10, right: 10),
                  child: Column(
                    children: [
                      Text(
                        'Verifying OTP',
                        style: Theme.of(context).primaryTextTheme.bodySmall,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Text(
                          'Enter the verification code from the email we just sent you.',
                          style: Theme.of(context).primaryTextTheme.displaySmall,
                        ),
                      ),
                      PinFieldAutoFill(
                        key: const Key("1"),
                        decoration:
                            BoxLooseDecoration(textStyle: const TextStyle(fontSize: 20, color: Colors.black), strokeColorBuilder: const FixedColorBuilder(Colors.transparent), bgColorBuilder: FixedColorBuilder(Colors.grey[100]!), hintText: '••••••', hintTextStyle: const TextStyle(fontSize: 70, color: Colors.black)),
                        currentCode: _cCode.text,
                        controller: _cCode,
                        codeLength: 6,
                        keyboardType: TextInputType.number,
                        onCodeSubmitted: (code) {
                          setState(() {
                            _cCode.text = code;
                          });
                        },
                        onCodeChanged: (code) async {
                          if (code!.length == 6) {
                            _cCode.text = code;
                            setState(() {});
                            FocusScope.of(context).requestFocus(FocusNode());
                            _verifyForgotPasswordOtp();
                          }
                        },
                      ),
                      Container(
                          height: 50,
                          width: double.infinity,
                          margin: const EdgeInsets.only(top: 10),
                          child: TextButton(
                              onPressed: () async {
                                _verifyForgotPasswordOtp();
                              },
                              child: const Text('Verify'))),
                      Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width - 30,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('By tapping verification code above, you agree ', style: Theme.of(context).primaryTextTheme.titleMedium),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text('to the ', style: Theme.of(context).primaryTextTheme.titleMedium),
                                    InkWell(
                                        splashColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        overlayColor: WidgetStateProperty.all(Colors.transparent),
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(builder: (context) => TermsOfServices(a: widget.analytics, o: widget.observer)),
                                          );
                                        },
                                        child: Text('Terms of Services,', style: Theme.of(context).primaryTextTheme.titleSmall)),
                                    InkWell(
                                        splashColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        overlayColor: WidgetStateProperty.all(Colors.transparent),
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(builder: (context) => PrivacyAndPolicy(a: widget.analytics, o: widget.observer)),
                                          );
                                        },
                                        child: Text('  privacy policy', style: Theme.of(context).primaryTextTheme.titleSmall)),
                                    Text(' and', style: Theme.of(context).primaryTextTheme.titleMedium),
                                  ],
                                ),
                                InkWell(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    overlayColor: WidgetStateProperty.all(Colors.transparent),
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) => CookiesPolicy(a: widget.analytics, o: widget.observer)),
                                      );
                                    },
                                    child: Text(' cookies policy.', style: Theme.of(context).primaryTextTheme.titleSmall))
                              ],
                            ),
                          ))
                    ],
                  ),
                ),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: 0, bottom: 0, left: 10, right: 10),
                  child: Column(
                    children: [
                      Text(
                        'Verifying Number',
                        style: Theme.of(context).primaryTextTheme.bodySmall,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Text(
                          'Enter the verification code from the phone we just sent you.',
                          style: Theme.of(context).primaryTextTheme.displaySmall,
                        ),
                      ),
                      PinFieldAutoFill(
                        key: const Key("1"),
                        decoration:
                            BoxLooseDecoration(textStyle: const TextStyle(fontSize: 20, color: Colors.black), strokeColorBuilder: const FixedColorBuilder(Colors.transparent), bgColorBuilder: FixedColorBuilder(Colors.grey[100]!), hintText: '••••••', hintTextStyle: const TextStyle(fontSize: 70, color: Colors.black)),
                        currentCode: _cCode.text,
                        controller: _cCode,
                        codeLength: 6,
                        keyboardType: TextInputType.number,
                        onCodeSubmitted: (code) {
                          setState(() {
                            _cCode.text = code;
                          });
                        },
                        onCodeChanged: (code) async {
                          if (code!.length == 6) {
                            _cCode.text = code;
                            setState(() {});
                            await _checkOTP(_cCode.text);
                            if(!context.mounted) return;
                            FocusScope.of(context).requestFocus(FocusNode());
                          }
                        },
                      ),
                      Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                              onTap: () async {
                                await _getOTP(widget.phoneNumberOrEmail);
                              },
                              child: Text(_seconds != 0 ? 'Resend code 0:$_seconds' : 'Resend OTP', style: Theme.of(context).primaryTextTheme.headlineSmall))),
                      Container(
                          height: 50,
                          width: double.infinity,
                          margin: const EdgeInsets.only(top: 10),
                          child: TextButton(
                              onPressed: () async {
                                _checkSecurityPin();
                              },
                              child: const Text('Verify'))),
                      Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width - 30,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('By tapping verification code above, you agree ', style: Theme.of(context).primaryTextTheme.titleMedium),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text('to the ', style: Theme.of(context).primaryTextTheme.titleMedium),
                                    InkWell(
                                        splashColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        overlayColor: WidgetStateProperty.all(Colors.transparent),
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(builder: (context) => TermsOfServices(a: widget.analytics, o: widget.observer)),
                                          );
                                        },
                                        child: Text('Terms of Services,', style: Theme.of(context).primaryTextTheme.titleSmall)),
                                    InkWell(
                                        splashColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        overlayColor: WidgetStateProperty.all(Colors.transparent),
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(builder: (context) => PrivacyAndPolicy(a: widget.analytics, o: widget.observer)),
                                          );
                                        },
                                        child: Text('  privacy policy', style: Theme.of(context).primaryTextTheme.titleSmall)),
                                    Text(' and', style: Theme.of(context).primaryTextTheme.titleMedium),
                                  ],
                                ),
                                InkWell(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    overlayColor: WidgetStateProperty.all(Colors.transparent),
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) => CookiesPolicy(a: widget.analytics, o: widget.observer)),
                                      );
                                    },
                                    child: Text(' cookies policy.', style: Theme.of(context).primaryTextTheme.titleSmall))
                              ],
                            ),
                          ))
                    ],
                  ),
                ),
              ),
      )),
    );
  }

  @override
  void dispose() {
    super.dispose();
    SmsAutoFill().unregisterListener();
  }

  @override
  void initState() {
    super.initState();
    OTPInteractor().getAppSignature()
        //ignore: avoid_print
        .then((value) => debugPrint('signature - $value'));
    _cCode = OTPTextEditController(
      codeLength: 6,
      //ignore: avoid_print
      onCodeReceive: (code) {
        setState(() {
          _cCode.text = code;
        });
      },
    )..startListenUserConsent(
        (code) {
          final exp = RegExp(r'(\d{6})');
          return exp.stringMatch(code ?? '') ?? '';
        },
        strategies: [],
      );
    _init();
    startTimer();
  }

  Future startTimer() async {
    try {
      setState(() {});
      const oneSec = Duration(seconds: 1);
      _countDown = Timer.periodic(
        oneSec,
        (timer) {
          if (_seconds == 0) {
            setState(() {
              _countDown.cancel();
              timer.cancel();
            });
          } else {
            setState(() {
              _seconds--;
            });
          }
        },
      );

      setState(() {});
    } catch (e) {
      debugPrint("Exception - otp_verification_screen.dart - startTimer():$e");
    }
  }

  Future _checkOTP(String otp) async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      var credential = PhoneAuthProvider.credential(verificationId: widget.verificationId!, smsCode: otp.trim());
      showOnlyLoaderDialog();
      await auth.signInWithCredential(credential).then((result) {
        status = 'success';
        hideLoader();

        _verifyOtp(status);
      }).catchError((e) {
        status = 'failed';
        hideLoader();

        _verifyOtp(status);
      }).onError((dynamic error, stackTrace) {
        hideLoader();
      });
    } catch (e) {
      debugPrint("Exception - otp_verification_screen.dart - _checkOTP():$e");
    }
  }

  _checkSecurityPin() async {
    try {
      if (_cCode.text.length == 6) {
        await _checkOTP(_cCode.text);
      } else {
        showSnackBar(key: _scaffoldKey, snackBarMessage: 'Please enter 6 digit otp');
      }
    } catch (e) {
      debugPrint("Exception - otp_verification_screen.dart - _checkSecurityPin() : $e");
    }
  }

  Future _getOTP(String? mobileNumber) async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      await auth.verifyPhoneNumber(
        phoneNumber: '+20$mobileNumber',
        timeout: const Duration(seconds: 60),
        verificationCompleted: (AuthCredential authCredential) async {
          setState(() {});
        },
        verificationFailed: (authException) {},
        codeSent: (String verificationId, [int? forceResendingToken]) async {
          _cCode.clear();
          _seconds = 60;
          startTimer();
          setState(() {});
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          verificationId = verificationId;
        },
      );
    } catch (e) {
      debugPrint("Exception - otp_verification_screen.dart - _getOTP():$e");
      return null;
    }
  }

  _init() async {
    try {
      SmsAutoFill().listenForCode;
    } catch (e) {
      debugPrint("Exception - otp_verification_screen.dart - _init():$e");
    }
  }

  _verifyForgotPasswordOtp() async {
    try {
      if (_cCode.text.length == 6) {
        showOnlyLoaderDialog();
        await apiHelper!.verifyOtpForgotPassword(widget.phoneNumberOrEmail, _cCode.text).then((result) {
          if (result != null) {
            if (result.status == "1") {
              hideLoader();
              if(!mounted) return;
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => ResetPasswordScreen(
                      widget.phoneNumberOrEmail,
                          a: widget.analytics,
                          o: widget.observer,
                        )),
              );
            } else {
              hideLoader();
              showSnackBar(key: _scaffoldKey, snackBarMessage: '${result.message}');
              setState(() {});
            }
          }
        });
      } else {
        showSnackBar(key: _scaffoldKey, snackBarMessage: 'Please enter 6 digit OTP');
      }
    } catch (e) {
      debugPrint("Exception - otp_verification_screen.dart - _verifyForgotPasswordOtp():$e");
    }
  }

  _verifyOtp(String? status) async {
    try {
      log("status: $status");
      log ("widget.screenId: ${widget.screenId}");
      log ("widget.phoneNumberOrEmail: ${widget.phoneNumberOrEmail}");
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        if (widget.screenId == 1) {
          showOnlyLoaderDialog();
          await apiHelper!.verifyOtpAfterLogin(widget.phoneNumberOrEmail, status, global.appDeviceId).then((result) async {
            if (result != null) {
              if (result.status == "1") {
                global.user = result.recordList;
                global.sp.setString('currentUser', json.encode(global.user!.toJson()));

                await getCurrentPosition().then((_) async {
                  if (global.lat != null && global.lng != null) {
                    hideLoader();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => BottomNavigationWidget(
                                a: widget.analytics,
                                o: widget.observer,
                              )),
                    );
                  } else {
                    hideLoader();
                    showSnackBar(key: _scaffoldKey, snackBarMessage: 'Please enable location permission to use this App');
                  }
                });
              } else {
                hideLoader();
                showSnackBar(key: _scaffoldKey, snackBarMessage: '${result.message}');
              }
            } else {
              hideLoader();
            }
          }).catchError((e) {});
        } else {
          showOnlyLoaderDialog();
          await apiHelper!. verifyOtpAfterRegistration(widget.phoneNumberOrEmail, status, null, global.appDeviceId).then((result) async {
            if (result != null) {
              if (result.status == "1") {
                global.user = result.recordList;
                global.sp.setString('currentUser', json.encode(global.user!.toJson()));

                await getCurrentPosition().then((_) async {
                  if (global.lat != null && global.lng != null) {
                    hideLoader();
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ExploreScreen(a: widget.analytics, o: widget.observer)),
                    );
                  } else {
                    hideLoader();
                    showSnackBar(key: _scaffoldKey, snackBarMessage: 'Please enable location permission to use this App');
                  }
                });
              } else {
                hideLoader();
                showSnackBar(key: _scaffoldKey, snackBarMessage: '${result.message}');
              }
            } else {
              hideLoader();
            }
          });
        }
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
    } catch (e) {
      debugPrint("Exception - otp_verification_screen.dart - _verifyOtp():$e");
    }
  }
}
