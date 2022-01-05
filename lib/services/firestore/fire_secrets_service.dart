import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_helper/firestore_helper.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:secretum/main.dart';
import 'package:secretum/models/secret.dart';
import 'package:secretum/services/encryption_service.dart';
import 'package:secretum/services/firestore/fire_users_service.dart';

enum SecretsQueryType {
  allSecrets,
}

class FireSecretsService {
  static const String kSubCollectionSecrets = 'secrets';

  final EncryptionService _encryptionService;
  final FirebaseFirestore _firebaseFirestore;
  final FirestoreHelper _fireGenericService;

  FireSecretsService()
      : this._encryptionService = GetIt.instance<EncryptionService>(),
        this._firebaseFirestore = FirebaseFirestore.instance,
        this._fireGenericService = GetIt.instance<FirestoreHelper>();

  StreamSubscription listenToSecretById(
    String userId,
    String secretId, {
    required ValueSetter<Secret> onSecretChanged,
  }) {
    final StreamSubscription<DocumentSnapshot> streamSubscription = _fireGenericService.listenToDocument(
      [FireUsersService.kCollectionUsers, userId, kSubCollectionSecrets, secretId],
      logReference: 'FireSecretsService.listenToSecretById',
      onDocumentChange: (documentSnapshot) {
        if (documentSnapshot.data() != null) {
          final Secret secret = Secret.fromFirestore(documentSnapshot);
          onSecretChanged(secret);
        }
      },
    );

    return streamSubscription;
  }

  Future<Secret?> getSecretById(String secretId) async {
    final Secret? secret = await _fireGenericService.getDocument<Secret>(
      [kSubCollectionSecrets, secretId],
      logReference: 'FireSecretsService.getSecretById:',
      onDocumentSnapshot: (docSnapshot) {
        if (docSnapshot.data() != null) {
          return Secret.fromFirestore(docSnapshot);
        } else {
          return null;
        }
      },
    );

    return secret;
  }

  Future<bool> addNewSecret(String userId, Secret secret) async {
    final Map<String, dynamic> dataMap = secret.toJson();

    loggingService.log('FireSecretsService.addNewSecret: Data: $dataMap');

    final String? documentId = await _fireGenericService.addDocument(
      [FireUsersService.kCollectionUsers, userId, kSubCollectionSecrets],
      dataMap,
    );

    return documentId != null;
  }

  Future<bool> updateSecret(String userId, String secretId, Secret secretUpdate) async {
    final bool isSuccess = await _fireGenericService.updateDocument(
      [FireUsersService.kCollectionUsers, userId, FireSecretsService.kSubCollectionSecrets, secretId],
      secretUpdate.toJson(),
    );
    return isSuccess;
  }

  Future<List<Secret>> getAllSecrets(String userId) async {
    final List<Secret>? secrets = await _fireGenericService.getDocuments(
      query: getQueryByType(SecretsQueryType.allSecrets, userId: userId),
      logReference: 'FireSecretsService.getAllSecrets',
      onDocumentSnapshot: (documentSnapshot) => Secret.fromFirestore(documentSnapshot),
    );

    return secrets ?? [];
  }

  Query getQueryByType(SecretsQueryType secretsQueryType, {String? userId}) {
    switch (secretsQueryType) {
      case SecretsQueryType.allSecrets:
        if (userId == null) {
          throw AssertionError('userId cannot be null');
        }

        final String encryptedAddedBy = _encryptionService.getEncryptedText(userId);

        return _firebaseFirestore
            .collection(FireUsersService.kCollectionUsers)
            .doc(userId)
            .collection(kSubCollectionSecrets)
            .where(Secret.kFieldAddedBy, isEqualTo: encryptedAddedBy)
            .orderBy(Secret.kFieldCreatedAt, descending: true);
    }
  }
}
