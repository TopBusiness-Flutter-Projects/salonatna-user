import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'dart:math';

import 'package:app/models/businessLayer/base_route.dart';
import 'package:app/models/businessLayer/global.dart' as global;
import 'package:app/models/user_model.dart';
import 'package:app/screens/add_phone_screen.dart';
import 'package:app/screens/forgot_password_screen.dart';
import 'package:app/screens/language_selection_screen.dart';
import 'package:app/screens/sign_up_screen.dart';
import 'package:app/widgets/bottom_navigation_widget.dart';
import 'package:crypto/crypto.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SignInScreen extends BaseRoute {
  const SignInScreen({super.key, super.a, super.o}) : super(r: 'SignInScreen');
  @override
  BaseRouteState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends BaseRouteState<SignInScreen> {
  GlobalKey<ScaffoldState>? _scaffoldKey;
  final TextEditingController _cEmail = TextEditingController();
  final TextEditingController _cPassword = TextEditingController();
  final FocusNode _fEmail = FocusNode();
  final FocusNode _fPassword = FocusNode();
  bool _isRemember = false;
  bool _isPasswordVisible = false;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);
  _SignInScreenState() : super();
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (bool didPop) {
        exitAppDialog();
      },
      child: Scaffold(
        key: _scaffoldKey,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 0, bottom: 0, left: 10, right: 10),
              child: Form(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.txt_welcome_back,
                          style: Theme.of(context).primaryTextTheme.headlineMedium,
                        ),
                        ElevatedButton(
                            style: ButtonStyle(elevation: WidgetStateProperty.all(0), backgroundColor: WidgetStateProperty.all(Colors.transparent)),
                            onPressed: () async {
                              showOnlyLoaderDialog();
                              await getCurrentPosition().then((_) async {
                                if (global.lat != null && global.lng != null) {
                                  global.user = CurrentUser();
                                  hideLoader();
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) => ChooseLanguageScreen(
                                              a: widget.analytics,
                                              o: widget.observer,
                                            )),
                                  );
                                } else {
                                  hideLoader();
                                  showSnackBar(key: _scaffoldKey, snackBarMessage: AppLocalizations.of(context)!.txt_please_enablet_location_permission_to_use_app);
                                }
                              });
                            },
                            child: Text(
                              AppLocalizations.of(context)!.lbl_skip,
                              style: Theme.of(context).primaryTextTheme.headlineSmall,
                            ))
                      ],
                    ),
                    Text(
                      AppLocalizations.of(context)!.txt_sigin_to_continue,
                      style: Theme.of(context).primaryTextTheme.displaySmall,
                    ),
                    Container(
                        margin: const EdgeInsets.only(top: 60),
                        height: 50,
                        child: TextFormField(
                          textAlign: TextAlign.start,
                          autofocus: false,
                          cursorColor: const Color(0xFFFA692C),
                          enabled: true,
                          style: Theme.of(context).primaryTextTheme.titleLarge,
                          controller: _cEmail,
                          focusNode: _fEmail,
                          keyboardType: TextInputType.emailAddress,
                          onEditingComplete: () {
                            _fPassword.requestFocus();
                          },
                          decoration: InputDecoration(hintText: AppLocalizations.of(context)!.hnt_email),
                        )),
                    Container(
                        height: 50,
                        margin: const EdgeInsets.only(top: 15),
                        child: TextFormField(
                          textAlign: TextAlign.start,
                          autofocus: false,
                          cursorColor: const Color(0xFFFA692C),
                          enabled: true,
                          style: Theme.of(context).primaryTextTheme.titleLarge,
                          controller: _cPassword,
                          focusNode: _fPassword,
                          obscureText: !_isPasswordVisible,
                          onEditingComplete: () {
                            FocusScope.of(context).unfocus();
                          },
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off, color: IconTheme.of(context).color),
                                onPressed: () {
                                  _isPasswordVisible = !_isPasswordVisible;
                                  setState(() {});
                                },
                              ),
                              hintText: AppLocalizations.of(context)!.hnt_password),
                        )),
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                              onTap: () {
                                FocusScope.of(context).unfocus();

                                if (_isRemember) {
                                  global.sp.remove('isRememberMeEmail');
                                }
                                _isRemember = !_isRemember;
                                setState(() {});
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    size: 20,
                                    color: _isRemember ? const Color(0xFFFA692C) : const Color(0xFF898A8D),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: Text(
                                      AppLocalizations.of(context)!.lbl_remember_me,
                                      style: Theme.of(context).primaryTextTheme.titleMedium,
                                    ),
                                  )
                                ],
                              )),
                          GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => ForgotPasswordScreen(a: widget.analytics, o: widget.observer)),
                                );
                              },
                              child: Text(AppLocalizations.of(context)!.lbl_forgot_password, style: Theme.of(context).primaryTextTheme.headlineSmall))
                        ],
                      ),
                    ),
                    Container(
                        margin: const EdgeInsets.only(top: 50),
                        height: 50,
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            _loginWithEmail();
                          },
                          child: Text(AppLocalizations.of(context)!.btn_sign_in),
                        )),
                    Padding(
                      padding: const EdgeInsets.only(top: 60),
                      child: Text(AppLocalizations.of(context)!.txt_or_Connect_with_social_account, style: Theme.of(context).primaryTextTheme.titleMedium),
                    ),
                    Container(
                        margin: const EdgeInsets.only(top: 10),
                        height: 50,
                        width: double.infinity,
                        child: TextButton(
                            onPressed: () async {
                              FocusScope.of(context).unfocus();
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => AddPhoneScreen(a: widget.analytics, o: widget.observer)),
                              );
                              PermissionStatus permissionStatus = await Permission.phone.status;
                              if (!permissionStatus.isGranted) {
                                permissionStatus = await Permission.phone.request();
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Icon(Icons.phone_outlined),
                                Text(AppLocalizations.of(context)!.btn_connect_with_phone_number),
                                const Icon(
                                  Icons.phone,
                                  color: Colors.transparent,
                                ),
                              ],
                            ))),
                    Platform.isIOS
                        ? Container(
                            height: 50,
                            width: double.infinity,
                            margin: const EdgeInsets.only(top: 10),
                            child: TextButton(
                                style: ButtonStyle(
                                    textStyle: WidgetStateProperty.all(const TextStyle(fontSize: 15, color: Colors.white, letterSpacing: 1, fontWeight: FontWeight.w400)),
                                    backgroundColor: WidgetStateProperty.all(
                                      Colors.black,
                                    )),
                                onPressed: () {
                                  _signInWithApple();
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Padding(padding: const EdgeInsets.only(right: 5), child: Icon(MdiIcons.apple)),
                                    const Text('Sign in with Apple'),
                                    Icon(
                                      MdiIcons.apple,
                                      color: Colors.transparent,
                                    ),
                                  ],
                                )))
                        : const SizedBox(),
                    // Container(
                    //     height: 50,
                    //     width: double.infinity,
                    //     margin: const EdgeInsets.only(top: 10),
                    //     child: TextButton(
                    //         style: ButtonStyle(textStyle: WidgetStateProperty.all(const TextStyle(fontSize: 15, color: Colors.white, letterSpacing: 1, fontWeight: FontWeight.w400)), backgroundColor: WidgetStateProperty.all(const Color(0xFF3B5999))),
                    //         onPressed: () {
                    //           FocusScope.of(context).unfocus();
                    //           _signInWithFacebook();
                    //         },
                    //         child: Row(
                    //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //           children: [
                    //             const Icon(FontAwesomeIcons.facebook),
                    //             Text(AppLocalizations.of(context)!.btn_sign_in_with_facebook),
                    //             Icon(
                    //               MdiIcons.facebook,
                    //               color: Colors.transparent,
                    //             ),
                    //           ],
                    //         ))),
                    Container(
                        height: 50,
                        width: double.infinity,
                        margin: const EdgeInsets.only(top: 10),
                        child: TextButton(
                            style: ButtonStyle(textStyle: WidgetStateProperty.all(const TextStyle(fontSize: 15, color: Colors.white, letterSpacing: 1, fontWeight: FontWeight.w400)), backgroundColor: WidgetStateProperty.all(const Color(0xFFE94235))),
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              _signInWithGoogle();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(MdiIcons.google),
                                Text(AppLocalizations.of(context)!.btn_sign_in_with_google),
                                const Icon(
                                  Icons.facebook_outlined,
                                  color: Colors.transparent,
                                ),
                              ],
                            ))),
                  ],
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(AppLocalizations.of(context)!.txt_you_dont_have_an_account, style: Theme.of(context).primaryTextTheme.titleMedium),
                GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => SignUpScreen(a: widget.analytics, o: widget.observer)),
                      );
                    },
                    child: Text(AppLocalizations.of(context)!.lbl_sign_up, style: Theme.of(context).primaryTextTheme.headlineSmall))
              ],
            )),
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
      if (global.sp.getString('isRememberMeEmail') != null) {
        _cEmail.text = global.sp.getString('isRememberMeEmail')!;
        _isRemember = true;
      }
    } catch (e) {
      debugPrint("Exception - sign_in_screen.dart - _init():$e");
    }
  }

  _loginWithEmail() async {
    try {
      CurrentUser user = CurrentUser();
      user.userEmail = _cEmail.text.trim();
      user.userPassword = _cPassword.text.trim();
      user.deviceId = global.appDeviceId;

      if (_cEmail.text.isNotEmpty && EmailValidator.validate(_cEmail.text) && _cPassword.text.isNotEmpty && _cPassword.text.trim().length >= 8) {
        bool isConnected = await br.checkConnectivity();
        if (isConnected) {
          showOnlyLoaderDialog();
          await apiHelper!.loginWithEmail(user).then((result) async {
            if (result != null) {
              if (result.status == "1") {
                global.user = result.recordList;
                global.sp.setString('currentUser', json.encode(global.user!.toJson()));
                if (_isRemember) {
                  global.sp.setString('isRememberMeEmail', global.user!.email!);
                }
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
                    showSnackBar(key: _scaffoldKey, snackBarMessage: AppLocalizations.of(context)!.txt_please_enablet_location_permission_to_use_app);
                  }
                });
              } else {
                hideLoader();
                showSnackBar(key: _scaffoldKey, snackBarMessage: '${result.message}');
              }
            }
          });
        } else {
          showNetworkErrorSnackBar(_scaffoldKey);
        }
      } else if (_cEmail.text.isEmpty) {
        showSnackBar(key: _scaffoldKey, snackBarMessage: AppLocalizations.of(context)!.txt_please_enter_your_email);
      } else if (_cEmail.text.isNotEmpty && !EmailValidator.validate(_cEmail.text)) {
        showSnackBar(key: _scaffoldKey, snackBarMessage: AppLocalizations.of(context)!.txt_please_enter_your_valid_email);
      } else if (_cPassword.text.isEmpty || _cPassword.text.trim().length < 8) {
        showSnackBar(key: _scaffoldKey, snackBarMessage: AppLocalizations.of(context)!.txt_password_should_be_of_minimum_8_character);
      }
    } catch (e) {
      debugPrint("Exception - sign_in_screen.dart - _loginWithEmail():$e");
    }
  }

  _signInWithApple() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        showOnlyLoaderDialog();

        final firebaseAuth = FirebaseAuth.instance;

        String generateNonce([int length = 32]) {
          const charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
          final random = Random.secure();
          return List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
        }

        String sha256ofString(String input) {
          final bytes = utf8.encode(input);
          final digest = sha256.convert(bytes);
          return digest.toString();
        }

        final rawNonce = generateNonce();
        final nonce = sha256ofString(rawNonce);
        final credential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
          nonce: nonce,
        );
        final oauthCredential = OAuthProvider("apple.com").credential(
          idToken: credential.identityToken,
          rawNonce: rawNonce,
        );
        final UserCredential authResult = await firebaseAuth.signInWithCredential(oauthCredential);
        await apiHelper!.socialLogin(emailId: credential.email, type: "apple", appleId: authResult.user?.uid).then((result) async {
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
                  showSnackBar(key: _scaffoldKey, snackBarMessage: AppLocalizations.of(context)!.txt_please_enablet_location_permission_to_use_app);
                }
              });
            } else if (result.status == "4") {
              hideLoader();
              if(!mounted) return;
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => SignUpScreen(
                          a: widget.analytics,
                          o: widget.observer,
                          email: credential.email,
                          appleId: authResult.user?.uid,
                        )),
              );
            }
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
    } catch (e) {
      hideLoader();
      debugPrint("Exception - sign_in_screen.dart - _signinWithApple():$e");
    }
  }

  _signInWithFacebook() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {

        await apiHelper!.socialLogin(emailId: _googleSignIn.currentUser!.email, facebookId: '', type: "facebook").then((result) async {
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
                  showSnackBar(key: _scaffoldKey, snackBarMessage: AppLocalizations.of(context)!.txt_please_enablet_location_permission_to_use_app);
                }
              });
            } else if (result.status == "3") {
              hideLoader();
              if(!mounted) return;
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => SignUpScreen(
                          a: widget.analytics,
                          o: widget.observer,
                          fbId: '',
                        )),
              );
            }
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
    } catch (e) {
      debugPrint("Exception - sign_in_screen.dart - _signInWithFacebook():$e");
    }
  }

  _signInWithGoogle() async {
    try {
      bool isConnected = await br.checkConnectivity();
      if (isConnected) {
        showOnlyLoaderDialog();
         await _googleSignIn.signOut();
        await _googleSignIn.signIn().then((value) async {
           debugPrint("value: $value");
          if (value != null) {
            await value.authentication.then((value1) async {
              await apiHelper!.socialLogin(userEmail: _googleSignIn.currentUser!.email, type: "google").then((result) async {
                debugPrint("result: $result");
                if (result != null) {
                  debugPrint("result.status: ${result.status}");
                  if (result.status == "1") {
                    debugPrint("result.recordList: ${result.recordList}");
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
                        showSnackBar(key: _scaffoldKey, snackBarMessage: AppLocalizations.of(context)!.txt_please_enablet_location_permission_to_use_app);
                      }
                    });
                  } else if (result.status == "2") {
                    hideLoader();
                    if(!mounted) return;
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => SignUpScreen(
                                a: widget.analytics,
                                o: widget.observer,
                                email: _googleSignIn.currentUser!.email,
                                name: _googleSignIn.currentUser!.displayName,
                              )),
                    );
                  }
                }
              }).catchError((e) {
                hideLoader();
                debugPrint("Exception - sign_in_screen.dart - _signInWithGoogle():$e");
              });
            });
          }
        });
      } else {
        showNetworkErrorSnackBar(_scaffoldKey);
      }
    } catch (e) {
      hideLoader();
      debugPrint("Exception - sign_in_screen.dart - _signInWithGoogle():$e");
    }
  }
}
