import 'dart:io';

import 'package:clock/clock.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:secretum/models/enums/export_from_type.dart';
import 'package:secretum/models/secret.dart';
import 'package:secretum/models/user.dart';
import 'package:secretum/services/storage_service.dart';
import 'package:secretum/stores/secrets_store.dart';
import 'package:secretum/stores/users_store.dart';

import 'home_contract.dart';
import 'home_model.dart';

class HomePresenter {
  final HomeView _view;
  final HomeModel _model;
  final HomePresenterHelper _helper;
  final StorageService _storageService;
  final SecretsStore _secretsStore;
  final UsersStore _usersStore;

  HomePresenter(this._view, this._model, {HomePresenterHelper? helper})
      : this._helper = helper ?? HomePresenterHelper(),
        this._storageService = GetIt.instance<StorageService>(),
        this._secretsStore = GetIt.instance<SecretsStore>(),
        this._usersStore = GetIt.instance<UsersStore>();

  void init() {
    updateData();
    _helper.exportSecretsLocally(_model.user!, _secretsStore, _storageService);

    _view.updateView();
  }

  void updateData() {
    // Cannot force non-nullable because it's null after logging out
    _model.user = _usersStore.user;
    _model.secrets = List.of(_secretsStore.secrets);
    _view.updateView();
  }

  void signOut() {
    _usersStore.resetStore();
    _secretsStore.resetStore();
    _storageService.resetStorage();

    _view.goToWelcomePage();
  }

  Future<void> addNewSecret(String secretName) async {
    _model.loadingState.isLoading = true;
    _view.updateView();

    final String userId = _model.user!.id;
    final Secret secret = Secret.newSecret(clock.now(), addedBy: userId, name: secretName);
    final bool isSuccess = await _secretsStore.addNewSecret(userId, secret);

    _model.loadingState.isLoading = false;
    _view.updateView();

    if (isSuccess) {
      _view.showMessage('$secretName added');
    } else {
      _view.showMessage('Cannot add $secretName, something went wrong', isSuccess: false);
    }
  }

  Future<void> exportSecrets(ExportFromType exportFromType, String fileName) async {
    if (fileName.isEmpty) {
      _view.showMessage('File name cannot be empty', isSuccess: false);
      return;
    }

    final String? path;
    switch (exportFromType) {
      case ExportFromType.database:
        path = await _storageService.exportBackup(_model.secrets, fileName);
        break;
      case ExportFromType.unknown:
        path = null;
        break;
    }

    _view.showMessageDialog('${path}');
  }

  Future<void> deleteBackups() async {
    final bool isSuccess = await _storageService.deleteBackupFiles();

    if (isSuccess) {
      _view.showMessage('Backups were deleted');
    } else {
      _view.showMessage('Cannot delete backups, something went wrong', isSuccess: false);
    }
  }

  Future<Directory> getBackupsDirectory() async {
    return _storageService.getBackupsDirectory();
  }
}

@visibleForTesting
class HomePresenterHelper {
  /// Exports backup at app start. This will make sure user always has latest backup of their data in case something
  /// goes wrong in the database.
  Future<String> exportSecretsLocally(User user, SecretsStore secretsStore, StorageService storageService) async {
    final List<Secret> secrets = await secretsStore.getAllSecrets(user.id);
    final String filePath = await storageService.exportBackup(secrets, 'secretum-backup-${clock.now().toIso8601String()}');

    return filePath;
  }
}
