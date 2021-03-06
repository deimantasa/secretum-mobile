import 'package:get_it/get_it.dart';
import 'package:secretum/services/encryption_service.dart';
import 'package:secretum/stores/db_backup_store.dart';
import 'package:secretum/stores/secrets_store.dart';
import 'package:secretum/stores/users_store.dart';

import 'welcome_contract.dart';
import 'welcome_model.dart';

class WelcomePresenter implements Presenter {
  final View _view;
  // ignore:unused_field
  final WelcomeModel _welcomeModel;
  final EncryptionService _encryptionService;
  final DbBackupStore _dbBackupStore;
  final SecretsStore _secretsStore;
  final UsersStore _usersStore;

  WelcomePresenter(
    this._view,
    this._welcomeModel, {
    EncryptionService? encryptionService,
    DbBackupStore? dbBackupStore,
    SecretsStore? secretsStore,
    UsersStore? usersStore,
  })  : this._encryptionService = encryptionService ?? GetIt.instance<EncryptionService>(),
        this._dbBackupStore = dbBackupStore ?? GetIt.instance<DbBackupStore>(),
        this._secretsStore = secretsStore ?? GetIt.instance<SecretsStore>(),
        this._usersStore = usersStore ?? GetIt.instance<UsersStore>();

  @override
  Future<void> confirmSecretKey(String secretKey) async {
    // TODO anti-spam mechanism
    _view.showMessage('Verifying...');
    // Make sure to update encryptionService for handling the key,
    // because if key is correct - then retrieved result will need to be decrypted,
    // thus secretKey should be initialised. Otherwise everything will crash
    _encryptionService.updateSecretKey(secretKey);

    await _usersStore.initUserViaSecretKey(secretKey);
    if (_usersStore.user != null) {
      _secretsStore.init(_usersStore.user!.documentSnapshot.id);
      await _dbBackupStore.initDbBackup();

      _view.showMessage('Account retrieved. Welcome back!');
      _view.goToHomePage();
    } else {
      _encryptionService.resetSecretKey();
      _view.showMessage('Key is incorrect, please try again', isSuccess: false);
    }
  }
}
