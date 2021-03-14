import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:secretum/pages/home/home_page.dart';
import 'package:secretum/pages/registration/registration_page.dart';
import 'package:secretum/utils/dialogs.dart';

import 'welcome_contract.dart';
import 'welcome_model.dart';
import 'welcome_presenter.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> implements View {
  late final WelcomeModel _welcomeModel;
  late final WelcomePresenter _welcomePresenter;

  @override
  void initState() {
    _welcomeModel = WelcomeModel();
    _welcomePresenter = WelcomePresenter(this, context, _welcomeModel);
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
    Dialogs.showMessage(context, message: message, isSuccess: isSuccess);
  }

  @override
  void updateView() {
    if (mounted) setState(() {});
  }

  Widget _buildBodyWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Spacer(),
                FlutterLogo(size: 200),
                Spacer(),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        child: Text("Existing User"),
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
                        child: Text("New User"),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegistrationPage(),
                          ),
                        ),
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
          bool isLoading = false;
          return AlertDialog(
            title: Text("Enter your secret key"),
            content: TextFormField(
              autofocus: true,
              controller: textEditingController,
              decoration: InputDecoration(hintText: "Secret Key"),
              minLines: 1,
              maxLines: 3,
            ),
            actions: [
              TextButton(
                child: Text("Paste"),
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
                child: Text("Cancel"),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: Text("Confirm"),
                onPressed: () => _welcomePresenter.confirmSecretKey(textEditingController.text),
              ),
            ],
          );
        });
  }
}
