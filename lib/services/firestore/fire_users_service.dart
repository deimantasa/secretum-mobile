import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_helper/firestore_helper.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:secretum/main.dart';
import 'package:secretum/models/user.dart';
import 'package:secretum/models/users_sensitive_information.dart';
import 'package:secretum/services/encryption_service.dart';

enum UsersQueryType {
  userBySecretKey,
}

class FireUsersService {
  static const String kCollectionUsers = 'users';

  final EncryptionService _encryptionService;
  final FirebaseFirestore _firebaseFirestore;
  final FirestoreHelper _firestoreHelper;

  FireUsersService({FirebaseFirestore? firebaseFirestore})
      : this._encryptionService = GetIt.instance<EncryptionService>(),
        this._firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance,
        this._firestoreHelper = GetIt.instance<FirestoreHelper>();

  Future<User?> getUserBySecretKey(String secretKey) async {
    final String hashedSecretKey = _encryptionService.getHashedText(secretKey);

    loggingService.log('FireUsersService.getUserBySecretKey: SecretKey: $secretKey, Hashed: $hashedSecretKey');

    final QuerySnapshot querySnapshot = await _firebaseFirestore
        .collection(kCollectionUsers)
        .where('${User.kMapSensitiveInformation}.${UsersSensitiveInformation.kFieldSecretKey}', isEqualTo: hashedSecretKey)
        .limit(1)
        .get();

    final List<User?> users = querySnapshot.docs.map((queryDocumentSnapshot) {
      if (queryDocumentSnapshot.data() != null) {
        return User.fromFirestore(queryDocumentSnapshot);
      }

      return null;
    }).toList();

    // Remove all nulls to make sure list is non-nullable
    users.removeWhere((element) => element == null);

    if (users.isNotEmpty) {
      loggingService.log('FireUsersService.getUserBySecretKey: User retrieved');
      return users.first;
    } else {
      loggingService.log('FireUsersService.getUserBySecretKey: User is null');
      return null;
    }
  }

  Future<String?> registerUser(User user) async {
    final Map<String, dynamic> dataMap = user.toJson();

    loggingService.log('FireUsersService.registerUser: Data: $dataMap');
    final String? documentId = await _firestoreHelper.addDocument([kCollectionUsers], dataMap);

    if (documentId != null) {
      loggingService.log('FireUsersService.registerUser: User added. DocID: $documentId');
      return documentId;
    } else {
      loggingService.log('FireUsersService.registerUser: User cannot be added: DocID: null');
      return null;
    }
  }

  StreamSubscription listenToUserById(
    String userId, {
    required ValueSetter<User> onUserChanged,
  }) {
    final StreamSubscription<DocumentSnapshot> streamSubscription = _firestoreHelper.listenToDocument(
      [kCollectionUsers, userId],
      logReference: 'FireUsersService.listenToUserById',
      onDocumentChange: (documentSnapshot) {
        if (documentSnapshot.data() != null) {
          final User user = User.fromFirestore(documentSnapshot);
          onUserChanged(user);
        }
      },
    );

    return streamSubscription;
  }

  Future<User?> getUserById(String userId) async {
    final User? user = await _firestoreHelper.getDocument<User>(
      [kCollectionUsers, userId],
      logReference: 'FireUsersService.getUserById:',
      onDocumentSnapshot: (docSnapshot) {
        if (docSnapshot.data() != null) {
          return User.fromFirestore(docSnapshot);
        } else {
          return null;
        }
      },
    );

    return user;
  }
}
