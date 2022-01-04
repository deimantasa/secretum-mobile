import 'dart:async';

import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:secretum/models/secret.dart';
import 'package:secretum/services/authentication_service.dart';
import 'package:secretum/services/encryption_service.dart';
import 'package:secretum/stores/secrets_store.dart';
import 'package:secretum/stores/users_store.dart';

import 'secret_details_contract.dart';
import 'secret_details_model.dart';

class SecretDetailsPresenter {
  final SecretDetailsView _view;
  final SecretDetailsModel _secretDetailsModel;
  final AuthenticationService _authenticationService;
  final EncryptionService _encryptionService;
  final SecretsStore _secretsStore;
  final UsersStore _usersStore;
  final List<StreamSubscription?> _streamSubscriptions = [];

  SecretDetailsPresenter(this._view, this._secretDetailsModel)
      : this._authenticationService = GetIt.instance<AuthenticationService>(),
        this._encryptionService = GetIt.instance<EncryptionService>(),
        this._secretsStore = GetIt.instance<SecretsStore>(),
        this._usersStore = GetIt.instance<UsersStore>();

  Future<void> updateSecret(Secret secret) async {
    if (_secretDetailsModel.secret != null) {
      _secretsStore
          .updateSecret(
        _usersStore.user?.documentSnapshot.id ?? '',
        _secretDetailsModel.secret?.documentSnapshot.id ?? '',
        secret,
      )
          .then((isSuccess) {
        if (isSuccess) {
          _view.showMessage('Secret updated');
        } else {
          _view.showMessage('Cannot update secret, something went wrong');
        }
      });
    }
  }

  void init() {
    _listenToSecretById();
  }

  void _listenToSecretById() {
    final StreamSubscription streamSubscription = _secretsStore.listenToSecretById(
      _usersStore.user!.documentSnapshot.id,
      _secretDetailsModel.secretId,
      onSecretChanged: (secret) {
        _secretDetailsModel.secret = secret;
        _view.updateView();
      },
    );

    _streamSubscriptions.add(streamSubscription);
  }

  void deleteSecret(String password) async {
    if (_encryptionService.getHashedText(password) == _usersStore.user!.sensitiveInformation.primaryPassword) {
      final bool isSuccess = await authenticate();

      if (isSuccess) {
        _secretsStore
            .deleteSecret(
          _usersStore.user!.documentSnapshot.id,
          _secretDetailsModel.secret!.documentSnapshot.id,
        )
            .then((isSuccess) {
          if (isSuccess) {
            _view.showMessage('${_secretDetailsModel.secret?.name} was deleted');
          } else {
            _view.showMessage('Cannot delete ${_secretDetailsModel.secret?.name}. Something went wrong');
          }
        });

        _view.closePage();
      }
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

  Future<bool> authenticate() async {
    final bool isSuccess = await _authenticationService.authViaBiometric();

    return isSuccess;
  }
}
