import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:secretum/pages/authentication/authentication_page.dart';
import 'package:secretum/pages/home/home_page.dart';
import 'package:secretum/pages/welcome/welcome_page.dart';
import 'package:secretum/utils/app_assets.dart';
import 'package:secretum/utils/app_colors.dart';
import 'package:secretum/utils/dialogs.dart';

import 'intro_contract.dart';
import 'intro_model.dart';
import 'intro_presenter.dart';

class IntroPage extends StatefulWidget {
  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> implements IntroView {
  late final IntroModel _introModel;
  late final IntroPresenter _introPresenter;

  @override
  void initState() {
    super.initState();

    _introModel = IntroModel();
    _introPresenter = IntroPresenter(this, _introModel);
    _introPresenter.init();
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
    return Center(
      child: Column(
        children: [
          Spacer(),
          SvgPicture.asset(
            AppAssets.kSecretumLogo,
            height: 200,
            color: Colors.white,
          ),
          SizedBox(height: 24),
          Text(
            'SECRETUM',
            style: TextStyle(
              color: AppColors.kMaterialColor1,
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
  Future<void> goToAuthenticationPage() async {
    final bool? isSuccess = await Navigator.push(context, MaterialPageRoute(builder: (context) => AuthenticationPage()));

    if (isSuccess == true) {
      _introPresenter.finishInit();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(isFirstTime: false),
        ),
      );
    }
  }
}
