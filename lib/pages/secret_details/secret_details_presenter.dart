import 'dart:async';

import 'package:flutter/material.dart';
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

  void init() {
    listenToSecretById();
    updateData();
  }

  @visibleForTesting
  void listenToSecretById() {
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

  void updateData() {
    _model.user = _usersStore.user!;
    _view.updateView();
  }

  Future<void> updateSecretName(String name) async {
    final Secret? secret = _model.secret;
    if (secret == null) {
      loggingService.log('SecretDetailsPresenter.updateSecretName: Secret is null', logType: LogType.error);
      return;
    }

    secret.name = name;

    _model.loadingState.isLoading = true;
    _view.updateView();

    final bool isSuccess = await _secretsStore.updateSecret(_model.user.id, secret.id, secret);

    _model.loadingState.isLoading = false;
    _view.updateView();

    if (isSuccess) {
      _view.showMessage('Name has been updated');
    } else {
      _view.showMessage('Cannot update name, something went wrong', isSuccess: false);
    }
  }

  Future<void> updateSecretNote(String note) async {
    final Secret? secret = _model.secret;
    if (secret == null) {
      loggingService.log('SecretDetailsPresenter.updateSecretNote: Secret is null', logType: LogType.error);
      return;
    }

    secret.note = note;
    _model.loadingState.isLoading = true;
    _view.updateView();

    final bool isSuccess = await _secretsStore.updateSecret(_model.user.id, secret.id, secret);

    _model.loadingState.isLoading = false;
    _view.updateView();

    if (isSuccess) {
      _view.showMessage('Note has been updated');
    } else {
      _view.showMessage('Cannot update note, something went wrong', isSuccess: false);
    }
  }

  Future<void> updateSecretCode(String code) async {
    final Secret? secret = _model.secret;
    if (secret == null) {
      loggingService.log('SecretDetailsPresenter.updateSecretCode: Secret is null', logType: LogType.error);
      return;
    }

    secret.code = code;

    _model.loadingState.isLoading = true;
    _view.updateView();

    final bool isSuccess = await _secretsStore.updateSecret(_model.user.id, secret.id, secret);

    _model.loadingState.isLoading = false;
    _view.updateView();

    if (isSuccess) {
      _view.showMessage('Code has been updated');
    } else {
      _view.showMessage('Cannot update code, something went wrong', isSuccess: false);
    }
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
