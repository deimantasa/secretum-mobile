import 'package:flutter/material.dart';
import 'package:secretum/main.dart';
import 'package:secretum/models/user.dart';
import 'package:secretum/models/users_sensitive_information.dart';
import 'package:secretum/stores/secrets_store.dart';
import 'package:secretum/stores/users_store.dart';
import 'package:provider/provider.dart';

import 'registration_contract.dart';
import 'registration_model.dart';

class RegistrationPresenter implements Presenter {
  late final View _view;
  //ignore: unused_field
  late final RegistrationModel _registrationModel;

  late final UsersStore _usersStore;
  late final SecretsStore _secretsStore;

  RegistrationPresenter(View view, BuildContext context, RegistrationModel registrationModel) {
    _view = view;
    _registrationModel = registrationModel;

    _usersStore = context.read<UsersStore>();
    _secretsStore = context.read<SecretsStore>();
  }

  Future<void> finishRegistration(String primaryPassword, String secondaryPassword) async {
    _view.showMessage("Registration in progress...");

    String secretKey = encryptionService.generateSecretKey();

    UsersSensitiveInformation usersSensitiveInformation = UsersSensitiveInformation.newUser(
      secretKey,
      primaryPassword,
      secondaryPassword,
    );
    User user = User.newUser(usersSensitiveInformation);
    bool isSuccess = await _usersStore.registerUser(user);
    if (isSuccess) {
      //After success is returned, we already init'd user in Store
      _secretsStore.init(_usersStore.user!.documentSnapshot!.id);

      _view.goToHomePage();
    } else {
      _view.showMessage("Cannot register. Something went wrong", isSuccess: false);
    }
  }
}
