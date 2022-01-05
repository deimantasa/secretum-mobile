import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:secretum/pages/home/home_page.dart';
import 'package:secretum/pages/registration/registration_page.dart';
import 'package:secretum/utils/dialogs.dart';
import 'package:secretum/utils/hero_tags.dart';
import 'package:secretum/utils/app_assets.dart';
import 'package:secretum/utils/app_colors.dart';

import 'welcome_contract.dart';
import 'welcome_model.dart';
import 'welcome_presenter.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> implements WelcomeView {
  late final WelcomeModel _model;
  late final WelcomePresenter _presenter;

  @override
  void initState() {
    super.initState();

    _model = WelcomeModel();
    _presenter = WelcomePresenter(this, _model);
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Spacer(),
                Hero(
                  tag: HeroTags.kFromWelcomeToRegistrationTag,
                  child: SvgPicture.asset(
                    AppAssets.kSecretumLogo,
                    height: 200,
                    color: Colors.white,
                  ),
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
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        child: Text('Existing User'),
                        onPressed: () => _showExistingUserDialog(),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        child: Text('New User'),
                        onPressed: () => _goToRegistrationPage(),
                      ),
                    ),
                  ],
                ),
                Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void goToHomePage() {
    //Close dialog
    Navigator.pop(context);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(isFirstTime: false),
      ),
    );
  }

  void _showExistingUserDialog() {
    showDialog(
        context: context,
        builder: (context) {
          final TextEditingController textEditingController = TextEditingController();
          return AlertDialog(
            title: Text('Enter your secret key'),
            content: TextFormField(
              autofocus: true,
              controller: textEditingController,
              decoration: InputDecoration(hintText: 'Secret Key'),
              minLines: 1,
              maxLines: 3,
            ),
            actions: [
              TextButton(
                child: Text('Paste'),
                onPressed: () async {
                  ClipboardData? clipboardData = await Clipboard.getData(Clipboard.kTextPlain);

                  //If there is some data within clipboard - paste it
                  if (clipboardData?.text != null) {
                    textEditingController.text = clipboardData!.text!;
                    textEditingController.selection = TextSelection.fromPosition(
                      TextPosition(offset: textEditingController.text.length),
                    );
                  }
                },
              ),
              TextButton(
                child: Text('Cancel'),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: Text('Confirm'),
                onPressed: () => _presenter.confirmSecretKey(textEditingController.text),
              ),
            ],
          );
        });
  }

  void _goToRegistrationPage() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrationPage()));
  }
}
