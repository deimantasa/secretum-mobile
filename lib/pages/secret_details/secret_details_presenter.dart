import 'dart:async';

import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:secretum/main.dart';
import 'package:secretum/models/enums/log_type.dart';
import 'package:secretum/models/secret.dart';
import 'package:secretum/services/encryption_service.dart';
import 'package:secretum/stores/secrets_store.dart';
import 'package:secretum/stores/users_store.dart';

import 'secret_details_contract.dart';
import 'secret_details_model.dart';

class SecretDetailsPresenter {
  final SecretDetailsView _view;
  final SecretDetailsModel _model;
  final EncryptionService _encryptionService;
  final SecretsStore _secretsStore;
  final UsersStore _usersStore;
  final List<StreamSubscription?> _streamSubscriptions = [];

  SecretDetailsPresenter(this._view, this._model)
      : this._encryptionService = GetIt.instance<EncryptionService>(),
        this._secretsStore = GetIt.instance<SecretsStore>(),
        this._usersStore = GetIt.instance<UsersStore>();

  void updateSecretName(String name) {
    final Secret? secret = _model.secret;
    if (secret == null) {
      loggingService.log('SecretDetailsPresenter.updateSecretName: Secret is null', logType: LogType.error);
      return;
    }

    secret.name = name;
    _secretsStore.updateSecret(_usersStore.user!.id, _model.secret!.id, secret).then((isSuccess) {
      if (isSuccess) {
        _view.showMessage('Name has been updated');
      } else {
        _view.showMessage('Cannot update name, something went wrong', isSuccess: false);
      }
    });
  }

  void updateSecretNote(String note) {
    final Secret? secret = _model.secret;
    if (secret == null) {
      loggingService.log('SecretDetailsPresenter.updateSecretNote: Secret is null', logType: LogType.error);
      return;
    }

    secret.note = note;
    _secretsStore.updateSecret(_usersStore.user!.id, _model.secret!.id, secret).then((isSuccess) {
      if (isSuccess) {
        _view.showMessage('Note has been updated');
      } else {
        _view.showMessage('Cannot update note, something went wrong', isSuccess: false);
      }
    });
  }

  void updateSecretCode(String code) {
    final Secret? secret = _model.secret;
    if (secret == null) {
      loggingService.log('SecretDetailsPresenter.updateSecretCode: Secret is null', logType: LogType.error);
      return;
    }

    secret.code = code;
    _secretsStore.updateSecret(_usersStore.user!.id, _model.secret!.id, secret).then((isSuccess) {
      if (isSuccess) {
        _view.showMessage('Code has been updated');
      } else {
        _view.showMessage('Cannot update code, something went wrong', isSuccess: false);
      }
    });
  }

  void init() {
    _listenToSecretById();
  }

  void _listenToSecretById() {
    final StreamSubscription streamSubscription = _secretsStore.listenToSecretById(
      _usersStore.user!.id,
      _model.secretId,
      onSecretChanged: (secret) {
        _model.secret = secret;
        _view.updateView();
      },
    );

    _streamSubscriptions.add(streamSubscription);
  }

  void deleteSecret(String password) async {
    final bool isPasswordCorrect =
        _encryptionService.getHashedText(password) == _usersStore.user!.sensitiveInformation.primaryPassword;
    if (isPasswordCorrect) {
      final bool isSuccess = await _secretsStore.deleteSecret(
        _usersStore.user!.id,
        _model.secret!.id,
      );

      final String? secretName = _model.secret?.name;

      if (isSuccess) {
        _view.showMessage('$secretName was deleted');
        _view.closePage();
      } else {
        _view.showMessage('Cannot delete $secretName. Something went wrong', isSuccess: false);
      }
    } else {
      _view.showMessage('Password is not correct', isSuccess: false);
    }
  }

  void dispose() {
    _streamSubscriptions.forEach((element) {
      element?.cancel();
    });
  }

  Future<void> copyText(String code) async {
    await Clipboard.setData(ClipboardData(text: code));

    _view.showMessage('Code was copied to clipboard');
    _view.closePage();
  }
}
