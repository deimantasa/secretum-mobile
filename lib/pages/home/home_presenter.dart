import 'package:get_it/get_it.dart';
import 'package:secretum/models/db_backup.dart';
import 'package:secretum/models/enums/export_from_type.dart';
import 'package:secretum/models/secret.dart';
import 'package:secretum/services/storage_service.dart';
import 'package:secretum/stores/db_backup_store.dart';
import 'package:secretum/stores/secrets_store.dart';
import 'package:secretum/stores/users_store.dart';

import 'home_contract.dart';
import 'home_model.dart';

class HomePresenter {
  final HomeView _view;
  final HomeModel _model;
  final StorageService _storageService;
  final DbBackupStore _dbBackupStore;
  final SecretsStore _secretsStore;
  final UsersStore _usersStore;

  HomePresenter(this._view, this._model)
      : this._storageService = GetIt.instance<StorageService>(),
        this._dbBackupStore = GetIt.instance<DbBackupStore>(),
        this._secretsStore = GetIt.instance<SecretsStore>(),
        this._usersStore = GetIt.instance<UsersStore>();

  void addNewSecret(String secretName) {
    final String userId = _usersStore.user!.id;
    final Secret secret = Secret.newSecret(
      addedBy: userId,
      createdAt: DateTime.now(),
      name: secretName,
    );

    _secretsStore.addNewSecret(userId, secret).then((isSuccess) {
      if (isSuccess) {
        _view.showMessage('$secretName added');
      } else {
        _view.showMessage('Cannot add $secretName, something went wrong', isSuccess: false);
      }
    });
  }

  void init() {
    updateData();

    // Export backup at app start. This will make sure user always has latest backup of their data in case something
    // goes wrong in the database.
    _storageService.exportBackup(_secretsStore.secrets, 'secretum-backup-${DateTime.now().toIso8601String()}');
  }

  void _updateSecrets() {
    _model.secrets = List.of(_secretsStore.secrets);
  }

  void _updateDbBackup() {
    _model.dbBackup = _dbBackupStore.dbBackup;
  }

  void updateData() {
    _updateSecrets();
    _updateDbBackup();
    _view.updateView();
  }

  void signOut() {
    _usersStore.resetStore();
    _secretsStore.resetStore();
    _storageService.resetStorage();
    _dbBackupStore.resetStore();

    _view.goToWelcomePage();
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
      case ExportFromType.backup:
        path = await _storageService.exportBackup(_model.dbBackup?.secrets ?? [], fileName);
        break;
      case ExportFromType.unknown:
        path = null;
        break;
    }

    _view.showMessageDialog('${path}');
  }

  Future<void> saveDbLocally() async {
    final DbBackup dbBackup = DbBackup(_model.secrets, DateTime.now());

    _dbBackupStore.updateDbBackupInLocalDb(dbBackup);
  }
}
