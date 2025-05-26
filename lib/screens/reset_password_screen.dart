import 'package:app/models/businessLayer/base_route.dart';
import 'package:app/screens/sign_in_screen.dart';
import 'package:flutter/material.dart';

class ResetPasswordScreen extends BaseRoute {
  final String? email;
  const ResetPasswordScreen(this.email, {super.key, super.a, super.o}) : super(r: 'ResetPasswordScreen');
  @override
  BaseRouteState<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends BaseRouteState<ResetPasswordScreen> {
  GlobalKey<ScaffoldState>? _scaffoldKey;
  final TextEditingController _cNewPassword = TextEditingController();
  final TextEditingController _cConfirmPassword = TextEditingController();
  final FocusNode _fNewPassword = FocusNode();
  final FocusNode _fConfirmPassword = FocusNode();

  _ResetPasswordScreenState() : super();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: sc(Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 0, bottom: 0, left: 10, right: 10),
            child: Column(
              children: [
                Text(
                  'Reset Password',
                  style: Theme.of(context).primaryTextTheme.bodySmall,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text('Please enter your Email so we can help you to recover your password.', textAlign: TextAlign.center, style: Theme.of(context).primaryTextTheme.displaySmall),
                ),
                Container(
                    margin: const EdgeInsets.only(top: 70),
                    height: 50,
                    child: TextFormField(
                      textAlign: TextAlign.start,
                      autofocus: false,
                      cursorColor: const Color(0xFFFA692C),
                      enabled: true,
                      style: Theme.of(context).primaryTextTheme.titleLarge,
                      controller: _cNewPassword,
                      focusNode: _fNewPassword,
                      decoration: const InputDecoration(hintText: 'New Password'),
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
                      cursorColor: const Color(0xFFFA692C),
                      enabled: true,
                      style: Theme.of(context).primaryTextTheme.titleLarge,
                      controller: _cConfirmPassword,
                      focusNode: _fConfirmPassword,
                      decoration: const InputDecoration(hintText: 'Confirm Password'),
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
                          _changePassword();
                        },
                        child: const Text('Reset Password'))),
              ],
            ),
          ),
        ),
      )),
    );
  }



  _changePassword() async {
    try {
      if (_cNewPassword.text.isNotEmpty && _cNewPassword.text.trim().length >= 8 && _cConfirmPassword.text.isNotEmpty && _cNewPassword.text.trim() == _cConfirmPassword.text.trim()) {
        bool isConnected = await br.checkConnectivity();
        if (isConnected) {
          showOnlyLoaderDialog();
          await apiHelper!.changePassword(widget.email, _cNewPassword.text.trim()).then((result) {
            if (result != null) {
              if (result.status == "1") {
                hideLoader();
                if(!mounted) return;
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => SignInScreen(
                            a: widget.analytics,
                            o: widget.observer,
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
      } else if (_cNewPassword.text.isEmpty || _cNewPassword.text.trim().length < 8) {
        showSnackBar(key: _scaffoldKey, snackBarMessage: 'Password should be of minimun 8 characters');
      } else if (_cConfirmPassword.text.isEmpty || _cConfirmPassword.text.trim() != _cNewPassword.text.trim()) {
        showSnackBar(key: _scaffoldKey, snackBarMessage: 'Passwords do not match');
      }
    } catch (e) {
      debugPrint("Exception - reset_password_screen.dart - _changePassword():$e");
    }
  }
}
