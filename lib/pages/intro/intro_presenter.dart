import 'package:get_it/get_it.dart';
import 'package:secretum/services/authentication_service.dart';
import 'package:secretum/stores/db_backup_store.dart';
import 'package:secretum/stores/secrets_store.dart';
import 'package:secretum/stores/users_store.dart';

import 'intro_contract.dart';
import 'intro_model.dart';

class IntroPresenter {
  final IntroView _view;
  //ignore: unused_field
  final IntroModel _model;
  final AuthenticationService _authenticationService;
  final DbBackupStore _dbBackupStore;
  final UsersStore _usersStore;
  final SecretsStore _secretsStore;

  IntroPresenter(this._view, this._model)
      : this._authenticationService = GetIt.instance<AuthenticationService>(),
        this._dbBackupStore = GetIt.instance<DbBackupStore>(),
        this._secretsStore = GetIt.instance<SecretsStore>(),
        this._usersStore = GetIt.instance<UsersStore>();

  Future<void> init() async {
    await Future.wait([
      Future.delayed(Duration(seconds: 2)),
      _authenticationService.init(),
      _usersStore.initUserOnAppStart(),
      _dbBackupStore.initDbBackup(),
    ]);

    if (_usersStore.user != null) {
      _view.goToAuthenticationPage();
    } else {
      _view.goToWelcomePage();
    }
  }

  void finishInit() {
    _secretsStore.init(_usersStore.user!.id);
  }
}
