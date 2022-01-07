import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as f_auth;
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:secretum/main.dart';
import 'package:secretum/models/enums/log_type.dart';
import 'package:secretum/models/user.dart';
import 'package:secretum/services/encryption_service.dart';
import 'package:secretum/services/firestore/fire_users_service.dart';
import 'package:secretum/services/storage_service.dart';

class UsersStore extends ChangeNotifier {
  final EncryptionService _encryptionService;
  final f_auth.FirebaseAuth _firebaseAuth;
  final FireUsersService _fireUsersService;
  final StorageService _storageService;
  final List<StreamSubscription?> _streamSubscriptions = [];

  User? user;

  UsersStore({f_auth.FirebaseAuth? firebaseAuth})
      : this._encryptionService = GetIt.instance<EncryptionService>(),
        this._firebaseAuth = firebaseAuth ?? f_auth.FirebaseAuth.instance,
        this._fireUsersService = GetIt.instance<FireUsersService>(),
        this._storageService = GetIt.instance<StorageService>();

  void updateUserLocally(User? user) {
    this.user = user;
    notifyListeners();
  }

  Future<void> initUserViaSecretKey(String secretKey) async {
    final User? user = await _fireUsersService.getUserBySecretKey(secretKey);

    if (user != null) {
      await _firebaseAuth.signInAnonymously();
      updateUserLocally(user);
      await _storageService.initSecretKey(secretKey);
      _listenToUserByUserId(user.id);
    }
  }

  Future<void> initUserOnAppStart() async {
    final String? secretKey = await _storageService.getSecretKey();
    if (secretKey == null) {
      loggingService.log('UsersStore.initUserOnAppStart: SecretKey is null - user is not logged in');
      return;
    }

    final User? user = await _fireUsersService.getUserBySecretKey(secretKey);
    // If user doesn't exist, something went wrong, because SecretKey is in storage
    // yet there is no user found in Firestore. Investigate.
    if (user == null) {
      loggingService.log('UsersStore._initAndListenToUser: User from firestore is null', logType: LogType.error);
      return;
    }

    await _firebaseAuth.signInAnonymously();
    // SecretKey is already initialised in the StorageService. We need to make
    // sure that EncryptionService `key` is also up to date
    _encryptionService.updateSecretKey(secretKey);
    // Update user immediately in Store, because listening might take 0.x second to retrieve the
    // user from stream
    updateUserLocally(user);
    _listenToUserByUserId(user.id);
  }

  Future<bool> registerUser(User userToRegister) async {
    await _storageService.initSecretKey(userToRegister.sensitiveInformation.secretKey);
    final String? userId = await _fireUsersService.registerUser(userToRegister);

    // If userId is not null but user from firestore is null, something went wrong. Investigate
    if (userId == null) {
      loggingService.log('UsersStore.registerUser: User is null', logType: LogType.error);
      return false;
    }

    // Sign in immediately because we need to query for exact user
    await _firebaseAuth.signInAnonymously();
    final User? user = await _fireUsersService.getUserById(userId);
    if (user == null) {
      // If user does not exist - sign user out immediately
      await _firebaseAuth.signOut();
      loggingService.log('UsersStore.registerUser: User is null from Firestore', logType: LogType.error);
      return false;
    }

    loggingService.log('UsersStore.registerUser: User registered. UserId: $userId');

    updateUserLocally(user);
    _listenToUserByUserId(userId);

    return true;
  }

  void _listenToUserByUserId(String userId) {
    final StreamSubscription streamSubscription = _fireUsersService.listenToUserById(
      userId,
      onUserChanged: (user) => updateUserLocally(user),
    );

    _streamSubscriptions.add(streamSubscription);
  }

  void resetStore() {
    _streamSubscriptions.forEach((element) {
      element?.cancel();
    });
    _streamSubscriptions.clear();

    _firebaseAuth.signOut();
    updateUserLocally(null);
  }
}
