import 'package:flutter/material.dart';
import 'package:secretum/main.dart';
import 'package:secretum/stores/secrets_store.dart';
import 'package:secretum/stores/users_store.dart';
import 'package:secretum/utils/dialogs.dart';
import 'package:secretum/utils/utils.dart';
import 'package:provider/provider.dart';

import 'intro_contract.dart';
import 'intro_model.dart';

class IntroPresenter implements Presenter {
  late final View _view;
  //ignore: unused_field
  late final IntroModel _introModel;

  late final UsersStore _usersStore;
  late final SecretsStore _secretsStore;

  IntroPresenter(View view, BuildContext context, IntroModel introModel) {
    _view = view;
    _introModel = introModel;

    _usersStore = context.read<UsersStore>();
    _secretsStore = context.read<SecretsStore>();
  }

  //Never use Context in Presenter.
  //But I'm feeling lazy to further decouple, therefore I'll allow it.
  @override
  Future<void> init(BuildContext context) async {
    await Future.wait([
      Future.delayed(Duration(seconds: 2)),
      _usersStore.initUserOnAppStart(),
    ]);

    if (_usersStore.user != null) {
      String? password = await Dialogs.showPasswordConfirmationDialog(context, hintText: "Primary Password");

      if (password != null &&
          encryptionService.getHashedText(password) == _usersStore.user!.sensitiveInformation.primaryPassword) {
        bool isSuccess = await Utils.authViaBiometric();
        if (isSuccess) {
          _secretsStore.init(_usersStore.user!.documentSnapshot!.id);
          _view.goToHomePage();
          return;
        }
      }
      //Since user is identified but password or biometric doesn't match - close the app
      //to prevent from any potential data leak
      Utils.closeApp();
    } else {
      _view.goToWelcomePage();
    }
  }
}
