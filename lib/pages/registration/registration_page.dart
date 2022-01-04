import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:secretum/pages/home/home_page.dart';
import 'package:secretum/utils/dialogs.dart';
import 'package:secretum/utils/hero_tags.dart';
import 'package:secretum/utils/app_assets.dart';

import 'registration_contract.dart';
import 'registration_model.dart';
import 'registration_presenter.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> implements RegistrationView {
  final PageController _pageController = PageController();
  final GlobalKey<FormState> _primaryPasswordFormKey = GlobalKey<FormState>();
  final TextEditingController _primaryPasswordTEC = TextEditingController();
  final FocusNode _primaryPasswordFocusNode = FocusNode();
  final TextEditingController _primaryPasswordConfirmationTEC = TextEditingController();
  final FocusNode _primaryPasswordConfirmationFocusNode = FocusNode();

  late final RegistrationModel _registrationModel;
  late final RegistrationPresenter _registrationPresenter;

  @override
  void initState() {
    super.initState();

    _registrationModel = RegistrationModel();
    _registrationPresenter = RegistrationPresenter(this, _registrationModel);
    _primaryPasswordFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration'),
        actions: [
          Hero(
            tag: HeroTags.kFromWelcomeToRegistrationTag,
            child: SvgPicture.asset(
              AppAssets.kSecretumLogo,
              width: 24,
              height: 24,
              color: Colors.white,
            ),
          ),
          // Mock side padding, so SVGAsset wouldn't be so close
          // to the edge
          SizedBox(width: 16),
        ],
      ),
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
    return PageView(
      controller: _pageController,
      physics: NeverScrollableScrollPhysics(),
      children: [
        _buildPasswordsSection(
          formKey: _primaryPasswordFormKey,
          primaryPasswordFocusNode: _primaryPasswordFocusNode,
          confirmationPasswordFocusNode: _primaryPasswordConfirmationFocusNode,
          description: 'Primary Password is used to secure most important actions within the application.',
          passwordTEC: _primaryPasswordTEC,
          isPasswordObscured: _registrationModel.isPrimaryPasswordObscure,
          onObscureChanged: (isObscure) => setState(() => _registrationModel.isPrimaryPasswordObscure = isObscure),
          passwordHint: 'Primary Password',
          passwordLength: 6,
          passwordConfirmationTEC: _primaryPasswordConfirmationTEC,
          buttonText: 'Finish',
          onFinish: () => _finishRegistration(),
        ),
      ],
    );
  }

  Widget _buildPasswordsSection({
    required GlobalKey<FormState> formKey,
    required FocusNode primaryPasswordFocusNode,
    required FocusNode confirmationPasswordFocusNode,
    required String description,
    required TextEditingController passwordTEC,
    required bool isPasswordObscured,
    required ValueSetter<bool> onObscureChanged,
    required String passwordHint,
    required int passwordLength,
    required TextEditingController passwordConfirmationTEC,
    required String buttonText,
    required void Function()? onFinish,
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
                    focusNode: primaryPasswordFocusNode,
                    controller: passwordTEC,
                    obscureText: isPasswordObscured,
                    decoration: InputDecoration(hintText: passwordHint),
                    validator: (input) => input != null && input.length >= passwordLength
                        ? null
                        : 'Password must be at least $passwordLength characters',
                    onEditingComplete: () => confirmationPasswordFocusNode.requestFocus(),
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
              focusNode: confirmationPasswordFocusNode,
              controller: passwordConfirmationTEC,
              obscureText: true,
              decoration: InputDecoration(hintText: 'Confirm Password'),
              validator: (input) => input == passwordTEC.text ? null : "Passwords doesn't match",
              onEditingComplete: onFinish,
            ),
            Spacer(flex: 2),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    child: Text(buttonText),
                    onPressed: onFinish,
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

  void _finishRegistration() {
    FocusScope.of(context).unfocus();

    if (_primaryPasswordFormKey.currentState!.validate()) {
      _registrationPresenter.finishRegistration(_primaryPasswordConfirmationTEC.text);
    }
  }
}
