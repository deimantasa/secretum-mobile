import 'package:get_it/get_it.dart';
import 'package:secretum/services/encryption_service.dart';
import 'package:secretum/stores/secrets_store.dart';
import 'package:secretum/stores/users_store.dart';

import 'welcome_contract.dart';
import 'welcome_model.dart';

class WelcomePresenter {
  final WelcomeView _view;
  // ignore:unused_field
  final WelcomeModel _model;
  final EncryptionService _encryptionService;
  final SecretsStore _secretsStore;
  final UsersStore _usersStore;

  WelcomePresenter(this._view, this._model)
      : this._encryptionService = GetIt.instance<EncryptionService>(),
        this._secretsStore = GetIt.instance<SecretsStore>(),
        this._usersStore = GetIt.instance<UsersStore>();

  Future<void> confirmSecretKey(String secretKey) async {
    // TODO: anti-spam mechanism
    _view.showMessage('Verifying...');
    // Make sure to update encryptionService for handling the key,
    // because if key is correct - then retrieved result will need to be decrypted,
    // thus secretKey should be initialised. Otherwise everything will crash
    _encryptionService.updateSecretKey(secretKey);

    await _usersStore.initUserViaSecretKey(secretKey);
    if (_usersStore.user != null) {
      _secretsStore.init(_usersStore.user!.id);

      _view.showMessage('Account retrieved. Welcome back!');
      _view.goToHomePage();
    } else {
      _encryptionService.resetSecretKey();
      _view.showMessage('Key is incorrect, please try again', isSuccess: false);
    }
  }
}
