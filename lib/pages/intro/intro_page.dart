import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:secretum/pages/home/home_page.dart';
import 'package:secretum/pages/welcome/welcome_page.dart';
import 'package:secretum/utils/secretum_assets.dart';
import 'package:secretum/utils/secretum_colors.dart';

import 'intro_contract.dart';
import 'intro_model.dart';
import 'intro_presenter.dart';

class IntroPage extends StatefulWidget {
  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> implements View {
  late final IntroModel _introModel;
  late final IntroPresenter _introPresenter;

  @override
  void initState() {
    _introModel = IntroModel();
    _introPresenter = IntroPresenter(this, context, _introModel);

    _introPresenter.init(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBodyWidget(),
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
    return Center(
      child: Column(
        children: [
          Spacer(),
          SvgPicture.asset(
            SecretumAssets.kSecretumLogo,
            height: 200,
            color: Colors.white,
          ),
          SizedBox(height: 24),
          Text(
            "SECRETUM",
            style: TextStyle(
              color: SecretumColors.kMaterialColor1,
              fontWeight: FontWeight.bold,
              fontSize: 40,
            ),
          ),
          Spacer(),
          Container(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }

  @override
  void goToWelcomePage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => WelcomePage(),
      ),
    );
  }

  @override
  void goToHomePage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(isFirstTime: false),
      ),
    );
  }
}
