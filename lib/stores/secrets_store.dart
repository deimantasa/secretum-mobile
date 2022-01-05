import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_helper/firestore_helper.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:secretum/main.dart';
import 'package:secretum/models/enums/log_type.dart';
import 'package:secretum/models/secret.dart';
import 'package:secretum/services/firestore/fire_secrets_service.dart';
import 'package:secretum/services/firestore/fire_users_service.dart';
import 'package:secretum/utils/extensions.dart';

class SecretsStore extends ChangeNotifier {
  final FirestoreHelper _firestoreHelper;
  final FireSecretsService _fireSecretsService;
  final List<StreamSubscription?> _streamSubscriptions = [];
  final List<Secret> secrets = [];

  SecretsStore()
      : this._firestoreHelper = GetIt.instance<FirestoreHelper>(),
        this._fireSecretsService = GetIt.instance<FireSecretsService>();

  void init(String userId) {
    _listenToAllSecrets(userId);
  }

  void _listenToAllSecrets(String userId) {
    final StreamSubscription streamSubscription = _firestoreHelper.listenToDocumentsStream(
      logReference: 'UsersStore._listenToAllSecrets',
      query: _fireSecretsService.getQueryByType(SecretsQueryType.allSecrets, userId: userId),
      onDocumentChange: (docChange) {
        if (docChange.doc.data() != null) {
          final Secret secret = Secret.fromFirestoreChanged(docChange);

          _updateSecretsLocally(secret);
        } else {
          loggingService.log(
            'UsersStore._listenToAllSecrets: DocChange.doc.data is null, docId: ${docChange.doc.id}',
            logType: LogType.error,
          );
        }
      },
    );

    _streamSubscriptions.add(streamSubscription);
  }

  StreamSubscription listenToSecretById(
    String userId,
    String secretId, {
    required ValueSetter<Secret> onSecretChanged,
  }) {
    final StreamSubscription streamSubscription = _fireSecretsService.listenToSecretById(
      userId,
      secretId,
      onSecretChanged: onSecretChanged,
    );
    return streamSubscription;
  }

  Future<bool> addNewSecret(String userId, Secret secret) async {
    final bool isSuccess = await _fireSecretsService.addNewSecret(userId, secret);

    return isSuccess;
  }

  void _updateSecretsLocally(Secret secret) {
    switch (secret.documentChangeType!) {
      case DocumentChangeType.added:
        secrets.onAdded<Secret>(
          secret,
          logReference: 'SecretsStore._updateSecretsLocally',
          onSort: (secrets) => _sortListByCreatedAtDesc(secrets),
          onViewUpdate: () => notifyListeners(),
        );
        break;
      case DocumentChangeType.modified:
        secrets.onModified<Secret>(
          secret,
          logReference: 'SecretsStore._updateSecretsLocally',
          onSort: (secrets) => _sortListByCreatedAtDesc(secrets),
          onViewUpdate: () => notifyListeners(),
        );
        break;
      case DocumentChangeType.removed:
        secrets.onRemoved<Secret>(
          secret,
          logReference: 'SecretsStore._updateSecretsLocally',
          onViewUpdate: () => notifyListeners(),
        );
        break;
    }
  }

  void _sortListByCreatedAtDesc(List<Secret> secrets) {
    secrets.sort((a, b) {
      if (a.createdAt != null && b.createdAt != null) {
        return b.createdAt!.compareTo(a.createdAt!);
      } else {
        return -1;
      }
    });
  }

  void resetStore() {
    secrets.clear();

    _streamSubscriptions.forEach((element) {
      element?.cancel();
    });
    _streamSubscriptions.clear();
  }

  Future<bool> deleteSecret(String userId, String secretId) async {
    final bool isSuccess = await _firestoreHelper.deleteDocument([
      FireUsersService.kCollectionUsers,
      userId,
      FireSecretsService.kSubCollectionSecrets,
      secretId,
    ]);

    return isSuccess;
  }

  Future<bool> updateSecret(String userId, String secretId, Secret secret) async {
    final bool isSuccess = await _fireSecretsService.updateSecret(userId, secretId, secret);

    return isSuccess;
  }
}
