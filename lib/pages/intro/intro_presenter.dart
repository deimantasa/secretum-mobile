import 'package:get_it/get_it.dart';
import 'package:secretum/stores/db_backup_store.dart';
import 'package:secretum/stores/secrets_store.dart';
import 'package:secretum/stores/users_store.dart';

import 'intro_contract.dart';
import 'intro_model.dart';

class IntroPresenter implements Presenter {
  final View _view;
  //ignore: unused_field
  final IntroModel _introModel;
  final DbBackupStore _dbBackupStore;
  final UsersStore _usersStore;
  final SecretsStore _secretsStore;

  IntroPresenter(
    this._view,
    this._introModel, {
    DbBackupStore? dbBackupStore,
    SecretsStore? secretsStore,
    UsersStore? usersStore,
  })  : this._dbBackupStore = dbBackupStore ?? GetIt.instance<DbBackupStore>(),
        this._secretsStore = secretsStore ?? GetIt.instance<SecretsStore>(),
        this._usersStore = usersStore ?? GetIt.instance<UsersStore>();

  // TODO Never use Context in Presenter.
  // But I'm feeling lazy to further decouple, therefore I'll allow it.
  @override
  Future<void> init() async {
    await Future.wait([
      Future.delayed(Duration(seconds: 2)),
      _usersStore.initUserOnAppStart(),
      _dbBackupStore.initDbBackup(),
    ]);

    if (_usersStore.user != null) {
      // TODO
      _view.goToAuthenticationPage();
      // final String? password = await Dialogs.showPasswordConfirmationDialog(context, hintText: 'Primary Password');
      //
      // if (password != null &&
      //     _encryptionService.getHashedText(password) == _usersStore.user!.sensitiveInformation.primaryPassword) {
      //   final bool isSuccess = await Utils.authViaBiometric();
      //
      //   if (isSuccess) {
      //     _secretsStore.init(_usersStore.user!.documentSnapshot.id);
      //     _view.goToHomePage();
      //     return;
      //   }
      // }
      // // Since user is identified but password or biometric doesn't match - close the app
      // // to prevent from any potential data leak
      // Utils.closeApp();
    } else {
      _view.goToWelcomePage();
    }
  }

  @override
  void finishInit() {
    _secretsStore.init(_usersStore.user!.documentSnapshot.id);
  }
}
