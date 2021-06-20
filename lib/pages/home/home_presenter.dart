import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:secretum/models/db_backup.dart';
import 'package:secretum/models/enums/export_from_type.dart';
import 'package:secretum/models/secret.dart';
import 'package:secretum/services/encryption_service.dart';
import 'package:secretum/services/storage_service.dart';
import 'package:secretum/stores/db_backup_store.dart';
import 'package:secretum/stores/secrets_store.dart';
import 'package:secretum/stores/users_store.dart';
import 'package:path_provider/path_provider.dart';

import 'home_contract.dart';
import 'home_model.dart';

class HomePresenter implements Presenter {
  final View _view;
  final HomeModel _homeModel;
  final EncryptionService _encryptionService;
  final StorageService _storageService;
  final DbBackupStore _dbBackupStore;
  final SecretsStore _secretsStore;
  final UsersStore _usersStore;

  HomePresenter(
    this._view,
    this._homeModel, {
    EncryptionService? encryptionService,
    StorageService? storageService,
    DbBackupStore? dbBackupStore,
    SecretsStore? secretsStore,
    UsersStore? usersStore,
  })  : this._encryptionService = encryptionService ?? GetIt.instance<EncryptionService>(),
        this._storageService = storageService ?? GetIt.instance<StorageService>(),
        this._dbBackupStore = dbBackupStore ?? GetIt.instance<DbBackupStore>(),
        this._secretsStore = secretsStore ?? GetIt.instance<SecretsStore>(),
        this._usersStore = usersStore ?? GetIt.instance<UsersStore>();

  @override
  void addNewSecret(String secretName) {
    final String userId = _usersStore.user!.documentSnapshot.id;
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
      return _encryptionService.getHashedText(password) == _usersStore.user!.sensitiveInformation.secondaryPassword;
    } else {
      return false;
    }
  }

  @override
  void signOut() {
    _usersStore.resetStore();
    _secretsStore.resetStore();
    _storageService.resetStorage();
    _dbBackupStore.resetStore();

    _view.goToWelcomePage();
  }

  @override
  Future<void> exportSecrets(ExportFromType exportFromType, String fileName) async {
    if (fileName.isEmpty) {
      _view.showMessage('File name cannot be empty', isSuccess: false);
    } else {
      final Directory directory = await getApplicationDocumentsDirectory();
      final File file = File('${directory.path}/$fileName.txt');

      // Generate Text and write to file
      final StringBuffer stringBuffer = StringBuffer();
      stringBuffer.writeln('***************************');

      switch (exportFromType) {
        case ExportFromType.database:
          _homeModel.secrets.forEach((secret) {
            stringBuffer.writeln(secret.toJson(isEncrypted: false));
          });
          break;
        case ExportFromType.backup:
          _homeModel.dbBackup?.secrets.forEach((secret) {
            stringBuffer.writeln(secret.toJson(isEncrypted: false));
          });
          break;
        case ExportFromType.unknown:
          break;
      }

      await file.writeAsString(stringBuffer.toString());
      _view.showMessageDialog('${file.path}');
    }
  }

  @override
  Future<void> saveDbLocally() async {
    final DbBackup dbBackup = DbBackup(_homeModel.secrets, DateTime.now());

    _dbBackupStore.updateDbBackupInLocalDb(dbBackup);
  }
}
