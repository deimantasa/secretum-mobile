import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:secretum/pages/home/home_page.dart';
import 'package:secretum/utils/dialogs.dart';
import 'package:secretum/utils/hero_tags.dart';
import 'package:secretum/utils/secretum_assets.dart';

import 'registration_contract.dart';
import 'registration_model.dart';
import 'registration_presenter.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> implements View {
  final PageController _pageController = PageController();

  final GlobalKey<FormState> _primaryPasswordFormKey = GlobalKey<FormState>();
  final TextEditingController _primaryPasswordTEC = TextEditingController();
  final TextEditingController _primaryPasswordConfirmationTEC = TextEditingController();

  final GlobalKey<FormState> _secondaryPasswordFormKey = GlobalKey<FormState>();
  final TextEditingController _secondaryPasswordTEC = TextEditingController();
  final TextEditingController _secondaryPasswordConfirmationTEC = TextEditingController();

  late final RegistrationModel _registrationModel;
  late final RegistrationPresenter _registrationPresenter;

  bool _isPrimaryPasswordObscure = true;
  bool _isSecondaryPasswordObscure = true;

  @override
  void initState() {
    _registrationModel = RegistrationModel();
    _registrationPresenter = RegistrationPresenter(this, context, _registrationModel);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registration"),
        actions: [
          Hero(
            tag: HeroTags.kFromWelcomeToRegistrationTag,
            child: SvgPicture.asset(
              SecretumAssets.kSecretumLogo,
              width: 24,
              height: 24,
              color: Colors.white,
            ),
          ),
          //Mock side padding, so SVGAsset wouldn't be so close
          //to the edge
          SizedBox(width: 16),
        ],
      ),
      body: _buildBodyWidget(),
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

  Widget _buildBodyWidget() {
    return PageView(
      controller: _pageController,
      physics: NeverScrollableScrollPhysics(),
      children: [
        _buildPassword(
          formKey: _primaryPasswordFormKey,
          description: "Primary Password is used to secure most important actions within the application.",
          passwordTEC: _primaryPasswordTEC,
          isPasswordObscured: _isPrimaryPasswordObscure,
          onObscureChanged: (isObscure) => setState(() => _isPrimaryPasswordObscure = isObscure),
          passwordHint: "Primary Password",
          passwordLength: 6,
          passwordConfirmationTEC: _primaryPasswordConfirmationTEC,
          buttonText: "Continue",
          onTap: () async {
            if (_primaryPasswordFormKey.currentState!.validate()) {
              await _pageController.nextPage(duration: kTabScrollDuration, curve: Curves.easeOut);
            }
          },
        ),
        _buildPassword(
          formKey: _secondaryPasswordFormKey,
          description: "Secondary Password is used to secure less important actions within the application.",
          passwordTEC: _secondaryPasswordTEC,
          isPasswordObscured: _isSecondaryPasswordObscure,
          onObscureChanged: (isObscure) => setState(() => _isSecondaryPasswordObscure = isObscure),
          passwordHint: "Secondary Password",
          passwordLength: 3,
          passwordConfirmationTEC: _secondaryPasswordConfirmationTEC,
          buttonText: "Finish",
          onTap: () {
            if (_secondaryPasswordFormKey.currentState!.validate()) {
              _registrationPresenter.finishRegistration(
                  _primaryPasswordConfirmationTEC.text, _secondaryPasswordConfirmationTEC.text);
            }
          },
        )
      ],
    );
  }

  Widget _buildPassword({
    required GlobalKey<FormState> formKey,
    required String description,
    required TextEditingController passwordTEC,
    required bool isPasswordObscured,
    required ValueSetter<bool> onObscureChanged,
    required String passwordHint,
    required int passwordLength,
    required TextEditingController passwordConfirmationTEC,
    required String buttonText,
    required Function()? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            Spacer(),
            Text(
              description,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    autofocus: true,
                    controller: passwordTEC,
                    obscureText: isPasswordObscured,
                    decoration: InputDecoration(hintText: passwordHint),
                    validator: (input) => input != null && input.length >= passwordLength
                        ? null
                        : "Password must be at least $passwordLength characters",
                  ),
                ),
                SizedBox(width: 4),
                IconButton(
                  icon: Icon(isPasswordObscured ? Icons.remove_red_eye : Icons.remove_red_eye_outlined),
                  onPressed: () => onObscureChanged(!isPasswordObscured),
                )
              ],
            ),
            SizedBox(height: 16),
            TextFormField(
              autofocus: true,
              controller: passwordConfirmationTEC,
              obscureText: true,
              decoration: InputDecoration(hintText: "Confirm Password"),
              validator: (input) => input == passwordTEC.text ? null : "Passwords doesn't match",
            ),
            Spacer(flex: 2),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    child: Text(buttonText),
                    onPressed: onTap,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  @override
  void goToHomePage() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => HomePage(isFirstTime: true),
      ),
      (route) => false,
    );
  }
}
