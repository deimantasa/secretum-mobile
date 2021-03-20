import 'package:flutter/material.dart';
import 'package:secretum/main.dart';
import 'package:secretum/stores/db_backup_store.dart';
import 'package:secretum/stores/secrets_store.dart';
import 'package:secretum/stores/users_store.dart';
import 'package:provider/provider.dart';

import 'welcome_contract.dart';
import 'welcome_model.dart';

class WelcomePresenter implements Presenter {
  late final View _view;
  //ignore: unused_field
  late final WelcomeModel _welcomeModel;

  late final UsersStore _usersStore;
  late final SecretsStore _secretsStore;
  late final DbBackupStore _dbBackupStore;

  WelcomePresenter(View view, BuildContext context, WelcomeModel welcomeModel) {
    _view = view;
    _welcomeModel = welcomeModel;

    _usersStore = context.read<UsersStore>();
    _secretsStore = context.read<SecretsStore>();
    _dbBackupStore = context.read<DbBackupStore>();
  }

  @override
  Future<void> confirmSecretKey(String secretKey) async {
    //TODO anti-spam mechanism
    _view.showMessage("Verifying...");
    //Make sure to update encryptionService for handling the key,
    //because if key is correct - then retrieved result will need to be decrypted,
    //thus secretKey should be initialised. Otherwise everything will crash
    encryptionService.updateSecretKey(secretKey);

    await _usersStore.initUserViaSecretKey(secretKey);
    if (_usersStore.user != null) {
      _secretsStore.init(_usersStore.user!.documentSnapshot!.id);
      await _dbBackupStore.initDbBackup();

      _view.showMessage("Account retrieved. Welcome back!");
      _view.goToHomePage();
    } else {
      encryptionService.resetSecretKey();
      _view.showMessage("Key is incorrect, please try again", isSuccess: false);
    }
  }
}
