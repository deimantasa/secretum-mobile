import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:secretum/main.dart';
import 'package:secretum/models/secret.dart';
import 'package:secretum/services/firestore/fire_users_service.dart';
import 'package:secretum/services/firestore/generic/firestore_generic_service.dart';

enum SecretsQueryType {
  allSecrets,
}

class FireSecretsService {
  static const String kSubCollectionSecrets = "secrets";

  final FireGenericService _fireGenericService = GetIt.instance<FireGenericService>();
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  StreamSubscription listenToSecretById(
    String userId,
    String secretId, {
    required ValueSetter<Secret> onSecretChanged,
  }) {
    StreamSubscription<DocumentSnapshot> streamSubscription = _fireGenericService.listenToSubCollectionDocument(
      FireUsersService.kCollectionUsers,
      userId,
      kSubCollectionSecrets,
      secretId,
      "FireSecretsService.listenToSecretById",
      onDocumentChange: (documentSnapshot) {
        if (documentSnapshot.data() != null) {
          Secret secret = Secret.fromFirestore(documentSnapshot, documentSnapshot.data()!);
          onSecretChanged(secret);
        }
      },
    );

    return streamSubscription;
  }

  Future<Secret?> getSecretById(String secretId) async {
    Secret? secret = await _fireGenericService.getElement<Secret>(
      kSubCollectionSecrets,
      secretId,
      "FireSecretsService.getSecretById:",
      onDocumentSnapshot: (docSnapshot) {
        if (docSnapshot.data() != null) {
          return Secret.fromFirestore(docSnapshot, docSnapshot.data()!);
        } else {
          return null;
        }
      },
    );

    return secret;
  }

  Future<bool> addNewSecret(String userId, Secret secret) async {
    Map<String, dynamic> dataMap = secret.toJson();
    loggingService.log("FireSecretsService.addNewSecret: Data: $dataMap");

    String? documentId = await _fireGenericService.addSubCollectionDocument(
      collection: FireUsersService.kCollectionUsers,
      documentId: userId,
      subCollection: kSubCollectionSecrets,
      update: dataMap,
    );

    return documentId != null;
  }

  Future<bool> updateSecret(String userId, String secretId, Secret secretUpdate) async {
    bool isSuccess = await _fireGenericService.updateSubCollectionsDocument(
      collection: FireUsersService.kCollectionUsers,
      collectionDocId: userId,
      subCollection: FireSecretsService.kSubCollectionSecrets,
      subCollectionDocId: secretId,
      update: secretUpdate.toJson(),
    );
    return isSuccess;
  }

  Query getQueryByType(SecretsQueryType secretsQueryType, {String? userId}) {
    switch (secretsQueryType) {
      case SecretsQueryType.allSecrets:
        String encryptedAddedBy = encryptionService.getEncryptedText(userId!);

        return _firebaseFirestore
            .collection(FireUsersService.kCollectionUsers)
            .doc(userId)
            .collection(kSubCollectionSecrets)
            .where(Secret.kFieldAddedBy, isEqualTo: encryptedAddedBy)
            .orderBy(Secret.kFieldCreatedAt, descending: true);
    }
  }
}
