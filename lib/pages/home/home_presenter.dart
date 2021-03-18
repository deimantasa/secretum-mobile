import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:secretum/main.dart';
import 'package:secretum/models/db_backup.dart';
import 'package:secretum/models/export_from_type.dart';
import 'package:secretum/models/secret.dart';
import 'package:secretum/services/storage_service.dart';
import 'package:secretum/stores/db_backup_store.dart';
import 'package:secretum/stores/secrets_store.dart';
import 'package:secretum/stores/users_store.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'home_contract.dart';
import 'home_model.dart';

class HomePresenter implements Presenter {
  late final View _view;
  late final HomeModel _homeModel;

  late final StorageService _storageService;

  late final DbBackupStore _dbBackupStore;
  late final UsersStore _usersStore;
  late final SecretsStore _secretsStore;

  HomePresenter(View view, BuildContext context, HomeModel homeModel) {
    _view = view;
    _homeModel = homeModel;

    _storageService = GetIt.instance<StorageService>();

    _dbBackupStore = context.read<DbBackupStore>();
    _usersStore = context.read<UsersStore>();
    _secretsStore = context.read<SecretsStore>();
  }

  @override
  void addNewSecret(String secretName) {
    String userId = _usersStore.user!.documentSnapshot!.id;
    Secret secret = Secret.newSecret(
      addedBy: userId,
      createdAt: DateTime.now(),
      name: secretName,
    );

    _secretsStore.addNewSecret(userId, secret).then((isSuccess) {
      if (isSuccess) {
        _view.showMessage("$secretName added");
      } else {
        _view.showMessage("Cannot add $secretName, something went wrong", isSuccess: false);
      }
    });
  }

  @override
  void init() {
    updateData();
  }

  void _updateSecrets() {
    _homeModel.secrets = List.of(_secretsStore.secrets);
  }

  void _updateDbBackup() {
    _homeModel.dbBackup = _dbBackupStore.dbBackup;
  }

  @override
  void updateData() {
    _updateSecrets();
    _updateDbBackup();
    _view.updateView();
  }

  @override
  bool isPasswordMatch(String password) {
    if (_usersStore.user != null) {
      return encryptionService.getHashedText(password) == _usersStore.user!.sensitiveInformation.secondaryPassword;
    } else {
      return false;
    }
  }

  @override
  void signOut() {
    _usersStore.resetStore();
    _secretsStore.resetStore();
    _storageService.resetStorage();

    _view.goToWelcomePage();
  }

  @override
  Future<void> exportSecrets(ExportFromType exportFromType, String fileName) async {
    if (fileName.isEmpty) {
      _view.showMessage("File name cannot be empty", isSuccess: false);
    } else {
      final Directory directory = await getApplicationDocumentsDirectory();
      File file = File('${directory.path}/$fileName.txt');

      //Generate Text and write to file
      StringBuffer stringBuffer = StringBuffer();
      stringBuffer.writeln("***************************");

      switch (exportFromType) {
        case ExportFromType.database:
          _homeModel.secrets.forEach((element) {
            stringBuffer.writeln(element.toJson(isEncrypted: false));
          });
          break;
        case ExportFromType.backup:
          _homeModel.dbBackup?.secrets.forEach((element) {
            stringBuffer.writeln(element.toJson(isEncrypted: false));
          });
          break;
      }

      await file.writeAsString(stringBuffer.toString());
      _view.showMessageDialog("${file.path}");
    }
  }

  @override
  Future<void> saveDbLocally() async {
    DbBackup dbBackup = DbBackup(_homeModel.secrets, DateTime.now());
    _dbBackupStore.updateDbBackupInLocalDb(dbBackup);
  }
}
