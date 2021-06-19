import 'package:get_it/get_it.dart';
import 'package:secretum/services/encryption_service.dart';
import 'package:secretum/stores/users_store.dart';

import 'edit_entry_contract.dart';
import 'edit_entry_model.dart';

class EditEntryPresenter implements Presenter {
  //ignore: unused_field
  final View _view;
  //ignore: unused_field
  final EditEntryModel _editEntryModel;
  final EncryptionService _encryptionService;
  final UsersStore _usersStore;

  EditEntryPresenter(
    this._view,
    this._editEntryModel, {
    EncryptionService? encryptionService,
    UsersStore? usersStore,
  })  : this._encryptionService = encryptionService ?? GetIt.instance<EncryptionService>(),
        this._usersStore = usersStore ?? GetIt.instance<UsersStore>();

  @override
  bool validatePrimaryPassword(String? password) {
    if (password == null) {
      return false;
    }
    return _usersStore.user!.sensitiveInformation.primaryPassword == _encryptionService.getHashedText(password);
  }

  @override
  bool validateSecondaryPassword(String? password) {
    if (password == null) {
      return false;
    }
    return _usersStore.user!.sensitiveInformation.secondaryPassword == _encryptionService.getHashedText(password);
  }
}
