import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:secretum/main.dart';
import 'package:secretum/models/user.dart';
import 'package:secretum/services/storage_service.dart';
import 'package:secretum/stores/secrets_store.dart';
import 'package:secretum/stores/users_store.dart';
import 'package:provider/provider.dart';

import 'welcome_contract.dart';
import 'welcome_model.dart';

class WelcomePresenter implements Presenter {
  late final View _view;
  late final WelcomeModel _welcomeModel;

  late final StorageService _storageService;

  late final UsersStore _usersStore;
  late final SecretsStore _secretsStore;

  WelcomePresenter(View view, BuildContext context, WelcomeModel welcomeModel) {
    _view = view;
    _welcomeModel = welcomeModel;

    _storageService = GetIt.instance<StorageService>();

    _usersStore = context.read<UsersStore>();
    _secretsStore = context.read<SecretsStore>();
  }

  @override
  Future<void> confirmSecretKey(String secretKey) async {
    _view.showMessage("Verifying...");
    //Make sure to update encryptionService for handling the key,
    //because if key is correct - then retrieved result will need to be decrypted,
    //thus secretKey should be initialised. Otherwise everything will crash
    encryptionService.updateSecretKey(secretKey);

    await _usersStore.initUserViaSecretKey(secretKey);
    if (_usersStore.user != null) {
      _secretsStore.init(_usersStore.user!.documentSnapshot!.id);
      _view.showMessage("Account retrieved. Welcome back!");
      _view.goToHomePage();
    } else {
      encryptionService.resetSecretKey();
      _view.showMessage("Key is incorrect, please try again", isSuccess: false);
    }
  }
}
