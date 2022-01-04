import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:secretum/main.dart';
import 'package:secretum/utils/app_assets.dart';
import 'package:secretum/utils/dialogs.dart';

import 'authentication_contract.dart';
import 'authentication_model.dart';
import 'authentication_presenter.dart';

class AuthenticationPage extends StatefulWidget {
  @override
  _AuthenticationPageState createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> implements AuthenticationView {
  late final AuthenticationModel _model;
  late final AuthenticationPresenter _presenter;

  @override
  void initState() {
    super.initState();
    isAuthenticationPageShown = true;

    _model = AuthenticationModel();
    _presenter = AuthenticationPresenter(this, _model);

    // Once page is opened, immediately fire authentication
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _presenter.authenticate();
    });
  }

  @override
  void dispose() {
    // For iOS there is a infinite loop bug therefore delay flag setup for a while.
    // If flag is reset immediately, `onResume` will trigger yet flag will be true and Auth will
    // be shown again.
    if (Platform.isIOS) {
      Future.delayed(Duration(seconds: 1)).then((value) => isAuthenticationPageShown = false);
    } else {
      isAuthenticationPageShown = false;
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  @override
  void showMessage(String message, {bool isSuccess = true}) {
    Dialogs.showMessage(message: message, isSuccess: isSuccess);
  }

  @override
  void updateView() {
    if (mounted) setState(() {});
  }

  Widget _buildBody() {
    return WillPopScope(
      onWillPop: () async => false,
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            Spacer(),
            SvgPicture.asset(
              AppAssets.kSecretumLogo,
              height: 200,
              color: Colors.white,
            ),
            Spacer(),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    child: Text('Unlock'),
                    onPressed: () => _presenter.authenticate(),
                  ),
                ),
              ],
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }

  @override
  void closePage() {
    Navigator.pop(context, true);
  }
}
