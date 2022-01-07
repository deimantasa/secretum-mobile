import 'package:get_it/get_it.dart';
import 'package:secretum/models/user.dart';
import 'package:secretum/models/users_sensitive_information.dart';
import 'package:secretum/services/encryption_service.dart';
import 'package:secretum/stores/secrets_store.dart';
import 'package:secretum/stores/users_store.dart';

import 'registration_contract.dart';
import 'registration_model.dart';

class RegistrationPresenter {
  final RegistrationView _view;
  //ignore: unused_field
  final RegistrationModel _model;
  final EncryptionService _encryptionService;
  final SecretsStore _secretsStore;
  final UsersStore _usersStore;

  RegistrationPresenter(this._view, this._model)
      : this._encryptionService = GetIt.instance<EncryptionService>(),
        this._secretsStore = GetIt.instance<SecretsStore>(),
        this._usersStore = GetIt.instance<UsersStore>();

  Future<void> finishRegistration(String primaryPassword) async {
    _model.registrationLoadingState.isLoading = true;
    _view.updateView();

    _view.showMessage('Registration in progress...');

    final String secretKey = _encryptionService.generateSecretKey();
    final UsersSensitiveInformation usersSensitiveInformation = UsersSensitiveInformation.newUser(secretKey, primaryPassword);
    final User user = User.newUser(usersSensitiveInformation);
    final bool isSuccess = await _usersStore.registerUser(user);

    _model.registrationLoadingState.isLoading = false;
    _view.updateView();

    if (isSuccess) {
      // After success is returned, we already initialised user in the Store
      _secretsStore.init(_usersStore.user!.id);

      _view.goToHomePage();
    } else {
      _view.showMessage('Cannot register. Something went wrong', isSuccess: false);
    }
  }
}
