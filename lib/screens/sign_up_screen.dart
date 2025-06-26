import 'dart:developer';
import 'dart:io';

import 'package:app/models/businessLayer/base_route.dart';
import 'package:app/models/businessLayer/global.dart' as global;
import 'package:app/models/user_model.dart';
import 'package:app/screens/otp_verification_screen.dart';
import 'package:app/screens/sign_in_screen.dart';
import 'package:app/screens/terms_of_services_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class SignUpScreen extends BaseRoute {
  final String? appleId;
  final String? email;
  final String? fbId;
  final String? name;
  const SignUpScreen({super.key, super.a, super.o, this.email, this.fbId, this.name, this.appleId}) : super(r: 'SignUpScreen');
  @override
  BaseRouteState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends BaseRouteState<SignUpScreen> {
  GlobalKey<ScaffoldState>? _scaffoldKey;
  final TextEditingController _cName = TextEditingController();
  final TextEditingController _cEmail = TextEditingController();
  final TextEditingController _cMobile = TextEditingController();
  final TextEditingController _cPassword = TextEditingController();
  final TextEditingController _cConfirmPassword = TextEditingController();
  final TextEditingController _cReferralCode = TextEditingController();
  final FocusNode _fReferralCode = FocusNode();
  final FocusNode _fName = FocusNode();
  final FocusNode _fEmail = FocusNode();
  final FocusNode _fMobile = FocusNode();
  final FocusNode _fPassword = FocusNode();
  final FocusNode _fConfirmPassword = FocusNode();
  bool _isAgree = false;
  File? _tImage;
  bool _isPasswordVisible = false;
  final int _phoneNumberLength = 10;

  bool _isConfirmPasswordVisible = false;
  _SignUpScreenState() : super();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: sc(Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 0, bottom: 0, left: 10, right: 10),
            child: Form(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.lbl_warm_welcome,
                          style: Theme.of(context).primaryTextTheme.headlineMedium,
                        ),
                        Text(
                          AppLocalizations.of(context)!.txt_sign_up_to_join,
                          style: Theme.of(context).primaryTextTheme.displaySmall,
                        ),
                      ],
                    ),
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        _tImage != null
                            ? CircleAvatar(
                                radius: 32,
                                child: ClipRRect(borderRadius: BorderRadius.circular(32), child: Image.file(_tImage!)),
                              )
                            : global.user!.image != null
                                ? CachedNetworkImage(
                                    imageUrl: global.baseUrlForImage + global.user!.image!,
                                    imageBuilder: (context, imageProvider) => CircleAvatar(
                                      radius: 32,
                                      backgroundImage: imageProvider,
                                    ),
                                    placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                    errorWidget: (context, url, error) => const Icon(Icons.error),
                                  )
                                : const CircleAvatar(
                                    radius: 24,
                                    backgroundColor: Colors.white,
                                    child: Icon(Icons.person),
                                  ),
                        CircleAvatar(
                          radius: 32,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(32),
                              child: _tImage == null
                                  ? const CircleAvatar(
                                      radius: 30,
                                      backgroundColor: Colors.white,
                                      child: Icon(Icons.person),
                                    )
                                  : Image.file(_tImage!)),
                        ),
                        Positioned(
                            top: 30,
                            left: 30,
                            child: IconButton(
                                padding: const EdgeInsets.all(0),
                                onPressed: () {
                                  _showCupertinoModalSheet();
                                  setState(() {});
                                },
                                icon: Container(
                                    padding: const EdgeInsets.all(0),
                                    margin: const EdgeInsets.all(0),
                                    decoration: BoxDecoration(color: const Color(0xFFFA692C), borderRadius: BorderRadius.circular(34)),
                                    child: const Icon(
                                      Icons.add,
                                      color: Colors.white,
                                      size: 20,
                                    ))))
                      ],
                    )
                  ],
                ),
                Container(
                    margin: const EdgeInsets.only(top: 60),
                    height: 50,
                    child: TextFormField(
                      textAlign: TextAlign.start,
                      autofocus: false,
                      inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.deny(RegExp(r'[0-9]'))],
                      textCapitalization: TextCapitalization.words,
                      cursorColor: const Color(0xFFFA692C),
                      enabled: true,
                      style: Theme.of(context).primaryTextTheme.titleLarge,
                      controller: _cName,
                      focusNode: _fName,
                      onEditingComplete: () {
                        _fEmail.requestFocus();
                      },
                      decoration: InputDecoration(hintText: AppLocalizations.of(context)!.lbl_name),
                    )),
                Container(
                    margin: const EdgeInsets.only(top: 15),
                    height: 50,
                    child: TextFormField(
                      textAlign: TextAlign.start,
                      autofocus: false,
                      cursorColor: const Color(0xFFFA692C),
                      enabled: true,
                      readOnly: widget.email != null ? true : false,
                      keyboardType: TextInputType.emailAddress,
                      style: Theme.of(context).primaryTextTheme.titleLarge,
                      controller: _cEmail,
                      focusNode: _fEmail,
                      decoration: InputDecoration(hintText: widget.email ?? AppLocalizations.of(context)!.lbl_email),
                      onEditingComplete: () {
                        _fMobile.requestFocus();
                      },
                    )),
                // Container(
                //     margin: const EdgeInsets.only(top: 15),
                //     height: 50,
                //     child: TextFormField(
                //       textAlign: TextAlign.start,
                //       autofocus: false,
                //       inputFormatters: [
                //         FilteringTextInputFormatter.digitsOnly,
                //         LengthLimitingTextInputFormatter(_phoneNumberLength),
                //       ],
                //       keyboardType: TextInputType.number,
                //       cursorColor: const Color(0xFFFA692C),
                //       enabled: true,
                //       style: Theme.of(context).primaryTextTheme.titleLarge,
                //       controller: _cMobile,
                //       focusNode: _fMobile,
                //       decoration: InputDecoration(hintText: AppLocalizations.of(context)!.lbl_mobile),
                //       onEditingComplete: () {
                //         _fPassword.requestFocus();
                //       },
                //     )),
                       Container(
                      margin: EdgeInsets.only(top: 15),
                      // height: 50,
                      child: IntlPhoneField(
                        decoration: InputDecoration(hintText: AppLocalizations.of(context)!.lbl_mobile),
                        controller: _cMobile,
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
                        focusNode: _fMobile,
                      ),
                    ),
                Container(
                    margin: const EdgeInsets.only(top: 15),
                    height: 50,
                    child: TextFormField(
                      textAlign: TextAlign.start,
                      autofocus: false,
                      cursorColor: const Color(0xFFFA692C),
                      enabled: true,
                      obscureText: !_isPasswordVisible,
                      style: Theme.of(context).primaryTextTheme.titleLarge,
                      controller: _cPassword,
                      focusNode: _fPassword,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off, color: IconTheme.of(context).color),
                            onPressed: () {
                              _isPasswordVisible = !_isPasswordVisible;
                              setState(() {});
                            },
                          ),
                          hintText: AppLocalizations.of(context)!.hnt_password),
                      onEditingComplete: () {
                        _fConfirmPassword.requestFocus();
                      },
                    )),
                Container(
                    margin: const EdgeInsets.only(top: 15),
                    height: 50,
                    child: TextFormField(
                      textAlign: TextAlign.start,
                      autofocus: false,
                      obscureText: !_isConfirmPasswordVisible,
                      cursorColor: const Color(0xFFFA692C),
                      enabled: true,
                      style: Theme.of(context).primaryTextTheme.titleLarge,
                      controller: _cConfirmPassword,
                      focusNode: _fConfirmPassword,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(_isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off, color: IconTheme.of(context).color),
                            onPressed: () {
                              _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                              setState(() {});
                            },
                          ),
                          hintText: AppLocalizations.of(context)!.lbl_confirm_password),
                      onEditingComplete: () {
                        FocusScope.of(context).requestFocus(_fReferralCode);
                      },
                    )),
                Container(
                    margin: const EdgeInsets.only(top: 15),
                    height: 50,
                    child: TextFormField(
                      textAlign: TextAlign.start,
                      autofocus: false,
                      cursorColor: const Color(0xFFFA692C),
                      enabled: true,
                      style: Theme.of(context).primaryTextTheme.titleLarge,
                      controller: _cReferralCode,
                      focusNode: _fReferralCode,
                      decoration: InputDecoration(hintText: AppLocalizations.of(context)!.lbl_referral_code),
                      onEditingComplete: () {
                        FocusScope.of(context).unfocus();
                      },
                    )),
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: GestureDetector(
                      onTap: () {
                        _isAgree = !_isAgree;
                        setState(() {});
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            size: 20,
                            color: _isAgree ? const Color(0xFFFA692C) : const Color(0xFF898A8D),
                          ),
                          Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Wrap(
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.txt_i_agree_to_the,
                                    style: Theme.of(context).primaryTextTheme.titleMedium,
                                  ),
                                  InkWell(
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      overlayColor: WidgetStateProperty.all(Colors.transparent),
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context) => TermsOfServices(a: widget.analytics, o: widget.observer)),
                                        );
                                      },
                                      child: Text(AppLocalizations.of(context)!.txt_term_of_services, style: Theme.of(context).primaryTextTheme.titleSmall))
                                ],
                              ))
                        ],
                      )),
                ),
                Container(
                    height: 50,
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 10),
                    child: TextButton(
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          _signUp();
                        },
                        child: Text(AppLocalizations.of(context)!.btn_sign_up))),
              ],
            )),
          ),
        ),
        bottomNavigationBar: Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(AppLocalizations.of(context)!.txt_you_already_have_account, style: Theme.of(context).primaryTextTheme.titleMedium),
                GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => SignInScreen(a: widget.analytics, o: widget.observer)),
                      );
                    },
                    child: Text(AppLocalizations.of(context)!.lbl_sign_in, style: Theme.of(context).primaryTextTheme.headlineSmall))
              ],
            )),
      )),
    );
  }


  @override
  void initState() {
    super.initState();
    _fillData();
  }

  _fillData() {
    _cEmail.text = widget.email != null ? widget.email! : '';
    _cName.text = widget.name != null ? widget.name! : '';
  }
 String phoneCodeintl = '+20';
  _sendOTP(String phoneNumber) async {
    log("phoneNumber: $phoneCodeintl$phoneNumber");
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
                      verificationId: verificationId,
                      phoneNumberOrEmail: phoneNumber,
                      phoneCodeintl2: phoneCodeintl,
                    )),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      debugPrint("Exception - sign_up_screen.dart - _sendOTP():$e");
    }
  }

  _showCupertinoModalSheet() {
    try {
      showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) => CupertinoActionSheet(
          title: Text(AppLocalizations.of(context)!.lbl_actions),
          actions: [
            CupertinoActionSheetAction(
              child: Text(AppLocalizations.of(context)!.lbl_take_picture, style: const TextStyle(color: Color(0xFF171D2C))),
              onPressed: () async {
                Navigator.pop(context);
                showOnlyLoaderDialog();
                _tImage = await br.openCamera();
                hideLoader();

                setState(() {});
              },
            ),
            CupertinoActionSheetAction(
              child: Text(AppLocalizations.of(context)!.lbl_choose_from_library, style: const TextStyle(color: Color(0xFF171D2C))),
              onPressed: () async {
                Navigator.pop(context);
                showOnlyLoaderDialog();
                _tImage = await br.selectImageFromGallery();
                hideLoader();

                setState(() {});
              },
            )
          ],
          cancelButton: CupertinoActionSheetAction(
            child: Text(AppLocalizations.of(context)!.lbl_cancel, style: const TextStyle(color: Color(0xFFFA692C))),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      );
    } catch (e) {
      debugPrint("Exception - sign_up_screen.dart - _showCupertinoModalSheet():$e");
    }
  }

  _signUp() async {
    try {
      CurrentUser user = CurrentUser();
      if (widget.appleId != null) {
        user.appleId = widget.appleId;
      }

      user.username = _cName.text.trim();
      user.userEmail = _cEmail.text.trim();
      user.userPhone = _cMobile.text.trim();
      user.userPassword = _cPassword.text.trim();
      user.userImage = _tImage;
      user.deviceId = global.appDeviceId;
      user.referralCode = null;
      user.fbId = widget.fbId;
      user.referralCode = _cReferralCode.text;
      if (_cName.text.isNotEmpty &&
          EmailValidator.validate(_cEmail.text) &&
          _cEmail.text.isNotEmpty &&
          _cMobile.text.isNotEmpty &&
          _cMobile.text.trim().length == _phoneNumberLength &&
          _cPassword.text.isNotEmpty &&
          _cPassword.text.trim().length >= 8 &&
          _cConfirmPassword.text.isNotEmpty &&
          _cPassword.text.trim() == _cConfirmPassword.text.trim() &&
          _isAgree) {
        bool isConnected = await br.checkConnectivity();
        if (isConnected) {
          showOnlyLoaderDialog();
          await apiHelper!.signUp(user).then((result) async {    
           
            if (result != null) {
              if (result.status.toString() == "1") {
                hideLoader();
                await _sendOTP(_cMobile.text.trim());
              } else {
                hideLoader();
                showSnackBar(key: _scaffoldKey, snackBarMessage: result.message.toString());
              }
            }else{
              hideLoader();}
          });
        } else {
          showNetworkErrorSnackBar(_scaffoldKey);
        }
      } else if (_cName.text.isEmpty) {
        showSnackBar(key: _scaffoldKey, snackBarMessage: AppLocalizations.of(context)!.txt_please_enter_your_name);
      } else if (_cEmail.text.isEmpty) {
        showSnackBar(key: _scaffoldKey, snackBarMessage: AppLocalizations.of(context)!.txt_please_enter_your_email);
      } else if (_cEmail.text.isNotEmpty && !EmailValidator.validate(_cEmail.text)) {
        showSnackBar(key: _scaffoldKey, snackBarMessage: AppLocalizations.of(context)!.txt_please_enter_your_valid_email);
      } else if (_cMobile.text.isEmpty || (_cMobile.text.isNotEmpty && _cMobile.text.trim().length < _phoneNumberLength)) {
        showSnackBar(key: _scaffoldKey, snackBarMessage: AppLocalizations.of(context)!.txt_please_enter_valid_mobile_number);
      } else if (_cPassword.text.isEmpty) {
        showSnackBar(key: _scaffoldKey, snackBarMessage: AppLocalizations.of(context)!.txt_please_enter_your_password);
      } else if (_cPassword.text.isNotEmpty && _cPassword.text.trim().length < 8) {
        showSnackBar(key: _scaffoldKey, snackBarMessage: AppLocalizations.of(context)!.txt_password_should_be_of_minimum_8_character);
      } else if (_cConfirmPassword.text.isEmpty && _cPassword.text.isNotEmpty) {
        showSnackBar(key: _scaffoldKey, snackBarMessage: AppLocalizations.of(context)!.txt_please_reEnter_your_password);
      } else if (_cConfirmPassword.text.isNotEmpty && _cPassword.text.isNotEmpty && (_cConfirmPassword.text.trim() != _cPassword.text.trim())) {
        showSnackBar(key: _scaffoldKey, snackBarMessage: AppLocalizations.of(context)!.txt_password_do_not_match);
      } else if (!_isAgree) {
        showSnackBar(key: _scaffoldKey, snackBarMessage: AppLocalizations.of(context)!.txt_please_agree_term_condition_to_complete_your_registeration);
      }
    } catch (e) {
      debugPrint("Exception - sign_up_screen.dart - _signUp():$e");
    }
  }
}
