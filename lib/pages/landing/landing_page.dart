import 'package:flutter/material.dart';
import 'package:secretum/models/clickable.dart';
import 'package:secretum/pages/home/home_page.dart';
import 'package:secretum/utils/dialogs.dart';

import 'landing_contract.dart';
import 'landing_model.dart';
import 'landing_presenter.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> implements View {
  late LandingModel _landingModel;
  late LandingPresenter _landingPresenter;

  @override
  void initState() {
    _landingModel = LandingModel();
    _landingPresenter = LandingPresenter(this, context, _landingModel);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBodyWidget(),
    );
  }

  Widget _buildClickableArea(Clickable clickable) {
    return GestureDetector(
      onTap: () => _landingPresenter.updateClickable(clickable),
      child: Container(
        width: 50,
        height: 50,
        color: Colors.transparent,
      ),
    );
  }

  @override
  void showMessage(String message, {bool isSuccess = true}) {
    //
  }

  @override
  void updateView() {
    if (mounted) setState(() {});
  }

  Widget _buildBodyWidget() {
    return SafeArea(
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            child: _buildClickableArea(_landingModel.topLeftClickable),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: _buildClickableArea(_landingModel.topRightClickable),
          ),
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () => _landingPresenter.verifyClickThrough(),
                  child: Text("Test"),
                ),
                _buildClickableArea(_landingModel.bottomCenterClickable)
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Future<void> showPasswordInputDialog() async {
    String? password = await Dialogs.showPasswordConfirmationDialog(
      context,
      hintText: "Primary Password",
    );

    if (password != null) {
      _landingPresenter.verifyPassword(password);
    }
  }

  @override
  void goToHomePage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(
          isFirstTime: false
        ),
      ),
    );
  }
}
