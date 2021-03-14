import 'dart:async';

import 'package:flutter/material.dart';
import 'package:secretum/main.dart';
import 'package:secretum/models/secret.dart';
import 'package:secretum/stores/secrets_store.dart';
import 'package:secretum/stores/users_store.dart';
import 'package:secretum/utils/utils.dart';
import 'package:provider/provider.dart';

import 'secret_details_contract.dart';
import 'secret_details_model.dart';

class SecretDetailsPresenter implements Presenter {
  late final View _view;
  late final SecretDetailsModel _secretDetailsModel;

  late final UsersStore _usersStore;
  late final SecretsStore _secretsStore;

  List<StreamSubscription?> _streamSubscriptions = [];

  SecretDetailsPresenter(View view, BuildContext context, SecretDetailsModel secretDetailsModel) {
    _view = view;
    _secretDetailsModel = secretDetailsModel;

    _usersStore = context.read<UsersStore>();
    _secretsStore = context.read<SecretsStore>();
  }

  @override
  Future<void> updateSecret(Secret secret) async {
    if (_secretDetailsModel.secret != null) {
      bool isSuccess = await _secretsStore.updateSecret(
        _usersStore.user?.documentSnapshot?.id ?? "",
        _secretDetailsModel.secret?.documentSnapshot?.id ?? "",
        secret,
      );

      if (isSuccess) {
        _view.showMessage("Secret updated");
      } else {
        _view.showMessage("Cannot update secret, something went wrong");
      }
    }
  }

  @override
  void init() {
    _listenToSecretById();
  }

  void _listenToSecretById() {
    StreamSubscription streamSubscription = _secretsStore.listenToSecretById(
      _usersStore.user!.documentSnapshot!.id,
      _secretDetailsModel.secretId,
      onSecretChanged: (secret) {
        _secretDetailsModel.secret = secret;
        _view.updateView();
      },
    );

    _streamSubscriptions.add(streamSubscription);
  }

  @override
  void deleteSecret(String password) async {
    if (encryptionService.getHashedText(password) == _usersStore.user!.sensitiveInformation.primaryPassword) {
      bool isSuccess = await Utils.authViaBiometric("");
      if (isSuccess) {
        _secretsStore.deleteSecret(
          _usersStore.user!.documentSnapshot!.id,
          _secretDetailsModel.secret!.documentSnapshot!.id,
        );
        _view.closePage();
      }
    }
  }

  @override
  void dispose() {
    _streamSubscriptions.forEach(
      (element) {
        element?.cancel();
      },
    );
  }
}
