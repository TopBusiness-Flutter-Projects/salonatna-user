import 'dart:convert';
import 'dart:io';

import 'package:app/models/businessLayer/base_route.dart';
import 'package:app/models/businessLayer/global.dart' as global;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AccountSettingScreen extends BaseRoute {
  const AccountSettingScreen({super.key, super.a, super.o}) : super(r: 'AccountSettingScreen');

  @override
  BaseRouteState<AccountSettingScreen> createState() => _AccountSettingScreenState();
}

class _AccountSettingScreenState extends BaseRouteState<AccountSettingScreen> {
  GlobalKey<ScaffoldState>? _scaffoldKey;
  final TextEditingController _cName = TextEditingController();
  final TextEditingController _cEmail = TextEditingController();
  final TextEditingController _cMobile = TextEditingController();
  final TextEditingController _cPassword = TextEditingController();
  final TextEditingController _cConfirmPassword = TextEditingController();
  final FocusNode _fName = FocusNode();
  final FocusNode _fEmail = FocusNode();
  final FocusNode _fMobile = FocusNode();
  final FocusNode _fPassword = FocusNode();
  final FocusNode _fConfirmPassword = FocusNode();
  File? _tImage;

  _AccountSettingScreenState() : super();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.lbl_account_settings),
          ),
          body: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.height * 0.19,
                    child: Stack(
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _tImage != null
                                ? Container(
                                    height: MediaQuery.of(context).size.height * 0.17,
                                    width: MediaQuery.of(context).size.height * 0.17,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).cardTheme.color,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(MediaQuery.of(context).size.height * 0.17),
                                      ),
                                      image: DecorationImage(image: FileImage(_tImage!), fit: BoxFit.cover),
                                      border: Border.all(
                                        color: Theme.of(context).primaryColor,
                                        width: 3.0,
                                      ),
                                    ),
                                  )
                                : global.user!.image != ''
                                    ? CachedNetworkImage(
                                        imageUrl: global.baseUrlForImage + global.user!.image!,
                                        imageBuilder: (context, imageProvider) => Container(
                                          height: MediaQuery.of(context).size.height * 0.17,
                                          width: MediaQuery.of(context).size.height * 0.17,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).cardTheme.color,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(MediaQuery.of(context).size.height * 0.17),
                                            ),
                                            image: DecorationImage(image: imageProvider),
                                            border: Border.all(
                                              color: Theme.of(context).primaryColor,
                                              width: 3.0,
                                            ),
                                          ),
                                        ),
                                        placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                        errorWidget: (context, url, error) => const Icon(Icons.error),
                                      )
                                    : Container(
                                        height: MediaQuery.of(context).size.height * 0.17,
                                        width: MediaQuery.of(context).size.height * 0.17,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).cardTheme.color,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(MediaQuery.of(context).size.height * 0.17),
                                          ),
                                          border: Border.all(
                                            color: Theme.of(context).primaryColor,
                                            width: 3.0,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.person,
                                          size: 50,
                                        ),
                                      ),
                            const SizedBox(
                              height: 10,
                            )
                          ],
                        ),
                        Positioned(
                            top: 86,
                            right: 15,
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
                                      size: 30,
                                    ))))
                      ],
                    ),
                  ),
                ),
                Center(
                    child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    '${global.user!.name}',
                    style: Theme.of(context).appBarTheme.titleTextStyle,
                  ),
                )),
                Align(
                    alignment: global.isRTL ? Alignment.centerRight : Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                      child: Text(
                        AppLocalizations.of(context)!.lbl_name,
                        style: Theme.of(context).primaryTextTheme.displaySmall,
                      ),
                    )),
                Container(
                    margin: const EdgeInsets.only(top: 5, left: 10, right: 10),
                    height: 50,
                    child: TextFormField(
                      textAlign: TextAlign.start,
                      autofocus: false,
                      cursorColor: const Color(0xFFFA692C),
                      style: Theme.of(context).inputDecorationTheme.hintStyle,
                      controller: _cName,
                      focusNode: _fName,
                      onEditingComplete: () {
                        _fPassword.requestFocus();
                      },
                      decoration: const InputDecoration(prefixIcon: Icon(Icons.person), hintText: 'Fahim Khan'),
                    )),
                Align(
                    alignment: global.isRTL ? Alignment.centerRight : Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                      child: Text(
                        AppLocalizations.of(context)!.lbl_email,
                        style: Theme.of(context).primaryTextTheme.displaySmall,
                      ),
                    )),
                Container(
                    margin: const EdgeInsets.only(top: 5, left: 10, right: 10),
                    height: 50,
                    child: TextFormField(
                      textAlign: TextAlign.start,
                      autofocus: false,
                      cursorColor: const Color(0xFFFA692C),
                      enabled: true,
                      readOnly: true,
                      style: Theme.of(context).inputDecorationTheme.hintStyle,
                      controller: _cEmail,
                      focusNode: _fEmail,
                      decoration: InputDecoration(prefixIcon: const Icon(Icons.email), hintText: AppLocalizations.of(context)!.hnt_email),
                    )),
                Align(
                    alignment: global.isRTL ? Alignment.centerRight : Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                      child: Text(
                        AppLocalizations.of(context)!.lbl_mobile,
                        style: Theme.of(context).primaryTextTheme.displaySmall,
                      ),
                    )),
                Container(
                    margin: const EdgeInsets.only(top: 5, left: 10, right: 10),
                    height: 50,
                    child: TextFormField(
                      textAlign: TextAlign.start,
                      autofocus: false,
                      cursorColor: const Color(0xFFFA692C),
                      enabled: true,
                      readOnly: true,
                      style: Theme.of(context).inputDecorationTheme.hintStyle,
                      controller: _cMobile,
                      focusNode: _fMobile,
                      decoration: InputDecoration(prefixIcon: const Icon(Icons.phone), hintText: AppLocalizations.of(context)!.hnt_phone),
                    )),
                Align(
                    alignment: global.isRTL ? Alignment.centerRight : Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                      child: Text(
                        AppLocalizations.of(context)!.lbl_change_password,
                        style: Theme.of(context).primaryTextTheme.displaySmall,
                      ),
                    )),
                Container(
                    margin: const EdgeInsets.only(top: 5, left: 10, right: 10),
                    height: 50,
                    child: TextFormField(
                      textAlign: TextAlign.start,
                      autofocus: false,
                      cursorColor: const Color(0xFFFA692C),
                      enabled: true,
                      obscureText: true,
                      style: Theme.of(context).inputDecorationTheme.hintStyle,
                      controller: _cPassword,
                      focusNode: _fPassword,
                      decoration: InputDecoration(prefixIcon: const Icon(Icons.password), hintText: AppLocalizations.of(context)!.hnt_password),
                      onEditingComplete: () {
                        _fConfirmPassword.requestFocus();
                      },
                    )),
                Align(
                    alignment: global.isRTL ? Alignment.centerRight : Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                      child: Text(
                        AppLocalizations.of(context)!.lbl_confirm_password,
                        style: Theme.of(context).primaryTextTheme.displaySmall,
                      ),
                    )),
                Container(
                    margin: const EdgeInsets.only(top: 5, left: 10, right: 10),
                    height: 50,
                    child: TextFormField(
                      textAlign: TextAlign.start,
                      autofocus: false,
                      cursorColor: const Color(0xFFFA692C),
                      enabled: true,
                      obscureText: true,
                      style: Theme.of(context).inputDecorationTheme.hintStyle,
                      controller: _cConfirmPassword,
                      focusNode: _fConfirmPassword,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.password),
                        hintText: AppLocalizations.of(context)!.lbl_confirm_password,
                      ),
                      onEditingComplete: () {
                        FocusScope.of(context).unfocus();
                      },
                    )),
              ],
            ),
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(),
                  SizedBox(
                    width: 150,
                    height: 43,
                    child: TextButton(
                        onPressed: () {
                          _save();
                        },
                        child: Text(AppLocalizations.of(context)!.btn_save)),
                  ),
                ],
              ),
            ),
          ),
        ),
    );
  }


  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() {
    try {
      _cName.text = global.user!.name!;
      _cEmail.text = global.user!.email!;
      _cMobile.text = global.user!.userPhone!;
      setState(() {});
    } catch (e) {
      debugPrint("Exception - account_setting_screen.dart - _init():$e");
    }
  }

  _save() async {
    try {
      FocusScope.of(context).unfocus();
      global.user!.username = _cName.text;
      global.user!.userPassword = _cPassword.text.isEmpty ? null : _cPassword.text;
      if (_cPassword.text.isNotEmpty && _cPassword.text.trim().length >= 8 && _cConfirmPassword.text.isNotEmpty && _cPassword.text.trim() == _cConfirmPassword.text.trim()) {
      } else if (_cPassword.text.isNotEmpty && _cPassword.text.trim().length < 8) {
        showSnackBar(key: _scaffoldKey, snackBarMessage: AppLocalizations.of(context)!.txt_password_should_be_of_minimum_8_character);
      } else if (_cConfirmPassword.text.isNotEmpty && _cConfirmPassword.text.trim() != _cPassword.text.trim()) {
        showSnackBar(key: _scaffoldKey, snackBarMessage: AppLocalizations.of(context)!.txt_password_do_not_match);
      }

      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        showOnlyLoaderDialog();
        await apiHelper!
            .updateProfile(
          global.user!.id,
          global.user!.username,
          _tImage,
          userPassword: global.user!.userPassword,
        )
            .then((result) {
          if (result != null) {
            if (result.status == "1") {
              hideLoader();

              global.user = result.data;

              global.sp.setString('currentUser', json.encode(global.user!.toJson()));
              if(!mounted) return;
              Navigator.of(context).pop();

              setState(() {});
            } else {
              showSnackBar(key: _scaffoldKey, snackBarMessage: '${result.message}');
            }
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
    } catch (e) {
      debugPrint("Exception - account_setting_screen.dart - _save():$e");
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
      debugPrint("Exception - account_setting_screen.dart - _showCupertinoModalSheet():$e");
    }
  }
}
