import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:secretum/main.dart';
import 'package:secretum/models/secret.dart';
import 'package:secretum/services/encryption_service.dart';
import 'package:secretum/services/firestore/fire_users_service.dart';
import 'package:secretum/services/firestore/generic/firestore_generic_service.dart';

enum SecretsQueryType {
  allSecrets,
}

class FireSecretsService {
  static const String kSubCollectionSecrets = 'secrets';

  final EncryptionService _encryptionService;
  final FirebaseFirestore _firebaseFirestore;
  final FireGenericService _fireGenericService;

  FireSecretsService({
    EncryptionService? encryptionService,
    FirebaseFirestore? firebaseFirestore,
    FireGenericService? fireGenericService,
  })  : this._encryptionService = encryptionService ?? GetIt.instance<EncryptionService>(),
        this._firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance,
        this._fireGenericService = fireGenericService ?? GetIt.instance<FireGenericService>();

  StreamSubscription listenToSecretById(
    String userId,
    String secretId, {
    required ValueSetter<Secret> onSecretChanged,
  }) {
    final StreamSubscription<DocumentSnapshot> streamSubscription = _fireGenericService.listenToSubCollectionDocument(
      FireUsersService.kCollectionUsers,
      userId,
      kSubCollectionSecrets,
      secretId,
      'FireSecretsService.listenToSecretById',
      onDocumentChange: (documentSnapshot) {
        if (documentSnapshot.data() != null) {
          Secret secret = Secret.fromFirestore(documentSnapshot);
          onSecretChanged(secret);
        }
      },
    );

    return streamSubscription;
  }

  Future<Secret?> getSecretById(String secretId) async {
    final Secret? secret = await _fireGenericService.getElement<Secret>(
      kSubCollectionSecrets,
      secretId,
      'FireSecretsService.getSecretById:',
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

    final String? documentId = await _fireGenericService.addSubCollectionDocument(
      collection: FireUsersService.kCollectionUsers,
      documentId: userId,
      subCollection: kSubCollectionSecrets,
      update: dataMap,
    );

    return documentId != null;
  }

  Future<bool> updateSecret(String userId, String secretId, Secret secretUpdate) async {
    final bool isSuccess = await _fireGenericService.updateSubCollectionsDocument(
      collection: FireUsersService.kCollectionUsers,
      documentId: userId,
      subCollection: FireSecretsService.kSubCollectionSecrets,
      subCollectionDocumentId: secretId,
      update: secretUpdate.toJson(),
    );
    return isSuccess;
  }

  Query getQueryByType(SecretsQueryType secretsQueryType, {String? userId}) {
    switch (secretsQueryType) {
      case SecretsQueryType.allSecrets:
        final String encryptedAddedBy = _encryptionService.getEncryptedText(userId!);

        return _firebaseFirestore
            .collection(FireUsersService.kCollectionUsers)
            .doc(userId)
            .collection(kSubCollectionSecrets)
            .where(Secret.kFieldAddedBy, isEqualTo: encryptedAddedBy)
            .orderBy(Secret.kFieldCreatedAt, descending: true);
    }
  }
}
