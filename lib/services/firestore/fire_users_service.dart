import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:secretum/main.dart';
import 'package:secretum/models/user.dart';
import 'package:secretum/models/users_sensitive_information.dart';
import 'package:secretum/services/firestore/generic/firestore_generic_service.dart';

enum UsersQueryType {
  userBySecretKey,
}

class FireUsersService {
  static const String kCollectionUsers = "users";

  final FireGenericService _fireGenericService = GetIt.instance<FireGenericService>();
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<User?> getUserBySecretKey(String secretKey) async {
    String hashedSecretKey = encryptionService.getHashedText(secretKey);

    loggingService.log("FireUsersService.getUserBySecretKey: SecretKey: $secretKey, Hashed: $hashedSecretKey");

    QuerySnapshot querySnapshot = await _firebaseFirestore
        .collection(kCollectionUsers)
        .where(
          "${User.kMapSensitiveInformation}.${UsersSensitiveInformation.kFieldSecretKey}",
          isEqualTo: hashedSecretKey,
        )
        .limit(1)
        .get();

    List<User?> users = querySnapshot.docs.map((e) {
      if (e.data() != null) {
        return User.fromFirestore(e, e.data()!);
      }
      return null;
    }).toList();
    users.removeWhere((element) => element == null);

    if (users.isNotEmpty) {
      loggingService.log("FireUsersService.getUserBySecretKey: User retrieved");
      return users.first;
    } else {
      loggingService.log("FireUsersService.getUserBySecretKey: User is null");
      return null;
    }
  }

  Future<String?> registerUser(User user) async {
    Map<String, dynamic> dataMap = user.toJson();

    loggingService.log("FireUsersService.registerUser: Data: $dataMap");
    String? documentId = await _fireGenericService.addDocument(kCollectionUsers, dataMap);
    if (documentId != null) {
      loggingService.log("FireUsersService.registerUser: User added. DocID: $documentId");
      return documentId;
    } else {
      loggingService.log("FireUsersService.registerUser: User cannot be added: DocID: null");
      return null;
    }
  }

  StreamSubscription listenToUserById(
    String userId, {
    required ValueSetter<User> onUserChanged,
  }) {
    StreamSubscription<DocumentSnapshot> streamSubscription = _fireGenericService.listenToDocument(
      kCollectionUsers,
      userId,
      "FireUsersService.listenToUserById",
      onDocumentChange: (documentSnapshot) {
        if (documentSnapshot.data() != null) {
          User user = User.fromFirestore(documentSnapshot, documentSnapshot.data()!);
          onUserChanged(user);
        }
      },
    );

    return streamSubscription;
  }

  Future<User?> getUserById(String userId) async {
    User? user = await _fireGenericService.getElement<User>(
      kCollectionUsers,
      userId,
      "FireUsersService.getUserById:",
      onDocumentSnapshot: (docSnapshot) {
        if (docSnapshot.data() != null) {
          return User.fromFirestore(docSnapshot, docSnapshot.data()!);
        } else {
          return null;
        }
      },
    );

    return user;
  }
}
