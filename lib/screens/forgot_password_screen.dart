import 'package:app/models/businessLayer/base_route.dart';
import 'package:app/screens/otp_verification_screen.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ForgotPasswordScreen extends BaseRoute {
  const ForgotPasswordScreen({super.key, super.a, super.o}) : super(r: 'ForgotPasswordScreen');

  @override
  BaseRouteState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends BaseRouteState<ForgotPasswordScreen> {
  GlobalKey<ScaffoldState>? _scaffoldKey;

  final TextEditingController _cEmail = TextEditingController();
  final FocusNode _fEmail = FocusNode();
  _ForgotPasswordScreenState() : super();

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
            child: Column(
              children: [
                Text(AppLocalizations.of(context)!.txt_forgot_password, style: Theme.of(context).primaryTextTheme.bodySmall),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(AppLocalizations.of(context)!.txt_please_enter_your_email_so_we_can_help_you_to_recover_your_password, textAlign: TextAlign.center, style: Theme.of(context).primaryTextTheme.displaySmall),
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 70),
                    child: TextFormField(
                      textAlign: TextAlign.start,
                      autofocus: false,
                      cursorColor: const Color(0xFFFA692C),
                      enabled: true,
                      style: Theme.of(context).primaryTextTheme.titleLarge,
                      controller: _cEmail,
                      focusNode: _fEmail,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(hintText: AppLocalizations.of(context)!.lbl_email),
                      onEditingComplete: () {
                        FocusScope.of(context).unfocus();
                      },
                    )),
                Container(
                    height: 50,
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 20),
                    child: TextButton(
                        onPressed: () {
                          _forgotPassword();
                        },
                        child: Text(AppLocalizations.of(context)!.btn_send))),
              ],
            ),
          ),
        ),
      )),
    );
  }


  _forgotPassword() async {
    try {
      if (_cEmail.text.isNotEmpty) {
        bool isConnected = await br.checkConnectivity();
        if (isConnected) {
          showOnlyLoaderDialog();
          await apiHelper!.forgotPassword(_cEmail.text.trim()).then((result) {
            if (result != null) {
              if (result.status == "1") {
                hideLoader();
                if(!mounted) return;
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => OTPVerificationScreen(
                            a: widget.analytics,
                            o: widget.observer,
                            screenId: 2,
                            phoneNumberOrEmail: _cEmail.text.trim(),
                          )),
                );

                setState(() {});
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
      }
    } catch (e) {
      debugPrint("Exception - forgot_password_screen.dart - _forgotPassword():$e");
    }
  }
}
