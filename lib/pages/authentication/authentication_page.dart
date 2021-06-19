import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:secretum/utils/app_assets.dart';
import 'package:secretum/utils/dialogs.dart';

import 'authentication_contract.dart';
import 'authentication_model.dart';
import 'authentication_presenter.dart';

class AuthenticationPage extends StatefulWidget {
  @override
  _AuthenticationPageState createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> implements View {
  late final AuthenticationModel _authenticationModel;
  late final AuthenticationPresenter _authenticationPresenter;

  @override
  void initState() {
    super.initState();

    _authenticationModel = AuthenticationModel();
    _authenticationPresenter = AuthenticationPresenter(this, _authenticationModel);

    // Once page is opened, immediately fire authentication
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _authenticationPresenter.authenticate();
    });
  }

  @override
  void dispose() {
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
                    onPressed: () => _authenticationPresenter.authenticate(),
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
