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

  late final RegistrationModel _model;
  late final RegistrationPresenter _presenter;

  @override
  void initState() {
    super.initState();

    _model = RegistrationModel();
    _presenter = RegistrationPresenter(this, _model);
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
    if (_model.registrationLoadingState.isLoading) {
      return Center(child: CircularProgressIndicator());
    } else {
      final bool isPasswordObscured = _model.isPrimaryPasswordObscure;
      const int kPasswordLength = 6;

      return PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Form(
              key: _primaryPasswordFormKey,
              child: Column(
                children: [
                  Spacer(),
                  Text(
                    'Primary Password is used to secure most important actions within the application.',
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          focusNode: _primaryPasswordFocusNode,
                          controller: _primaryPasswordTEC,
                          obscureText: isPasswordObscured,
                          // Update UI on every single entry. Needed in order to show enable/disable `finish` button
                          onChanged: (_) => setState(() {}),
                          decoration: InputDecoration(hintText: 'Primary Password'),
                          validator: (input) => input != null && input.length >= kPasswordLength
                              ? null
                              : 'Password must be at least $kPasswordLength characters',
                          onEditingComplete: () => _primaryPasswordConfirmationFocusNode.requestFocus(),
                        ),
                      ),
                      SizedBox(width: 4),
                      IconButton(
                        icon: Icon(isPasswordObscured ? Icons.remove_red_eye : Icons.remove_red_eye_outlined),
                        onPressed: () => _presenter.toggleObscurity(),
                      )
                    ],
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    focusNode: _primaryPasswordConfirmationFocusNode,
                    controller: _primaryPasswordConfirmationTEC,
                    obscureText: true,
                    // Update UI on every single entry. Needed in order to show enable/disable `finish` button
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(hintText: 'Confirm Password'),
                    validator: (input) => _presenter.validatePassword(_primaryPasswordTEC.text, input),
                    onEditingComplete: _finishRegistration,
                  ),
                  Spacer(flex: 2),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          child: Text('Finish'),
                          onPressed: _primaryPasswordTEC.text.isEmpty || _primaryPasswordConfirmationTEC.text.isEmpty
                              ? null
                              : _finishRegistration,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          )
        ],
      );
    }
  }

  @override
  void goToHomePage() {
    // Remove all pages from the stack and push Home as a very first page
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
      _presenter.finishRegistration(_primaryPasswordConfirmationTEC.text);
    }
  }
}
