import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:secretum/main.dart';
import 'package:secretum/stores/users_store.dart';

import 'edit_entry_contract.dart';
import 'edit_entry_model.dart';

class EditEntryPresenter implements Presenter {
  late final View _view;
  late final EditEntryModel _editEntryModel;

  late final UsersStore _usersStore;

  EditEntryPresenter(View view, BuildContext context, EditEntryModel editEntryModel) {
    _view = view;
    _editEntryModel = editEntryModel;

    _usersStore = context.read<UsersStore>();
  }

  @override
  bool validatePrimaryPassword(String? password) {
    if (password == null) {
      return false;
    }
    return _usersStore.user!.sensitiveInformation.primaryPassword == encryptionService.getHashedText(password);
  }

  @override
  bool validateSecondaryPassword(String? password) {
    if (password == null) {
      return false;
    }
    return _usersStore.user!.sensitiveInformation.secondaryPassword == encryptionService.getHashedText(password);
  }
}
