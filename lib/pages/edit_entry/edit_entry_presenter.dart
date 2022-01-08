import 'package:get_it/get_it.dart';
import 'package:secretum/services/encryption_service.dart';
import 'package:secretum/stores/users_store.dart';

import 'edit_entry_contract.dart';
import 'edit_entry_model.dart';

class EditEntryPresenter {
  // ignore: unused_field
  final EditEntryView _view;
  // ignore: unused_field
  final EditEntryModel _model;
  final EncryptionService _encryptionService;
  final UsersStore _usersStore;

  EditEntryPresenter(this._view, this._model)
      : this._encryptionService = GetIt.instance<EncryptionService>(),
        this._usersStore = GetIt.instance<UsersStore>();

  bool validatePrimaryPassword(String? password) {
    if (password == null) {
      return false;
    }

    return _usersStore.user!.sensitiveInformation.primaryPassword == _encryptionService.getHashedText(password);
  }
}
