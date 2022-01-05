import 'dart:async';

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
  final FireUsersService _fireUsersService;
  final StorageService _storageService;
  final List<StreamSubscription?> _streamSubscriptions = [];

  User? user;

  UsersStore()
      : this._encryptionService = GetIt.instance<EncryptionService>(),
        this._fireUsersService = GetIt.instance<FireUsersService>(),
        this._storageService = GetIt.instance<StorageService>();

  void updateUserLocally(User? user) {
    this.user = user;
    notifyListeners();
  }

  Future<void> initUserViaSecretKey(String secretKey) async {
    final User? user = await _getUserBySecretKey(secretKey);

    if (user != null) {
      updateUserLocally(user);
      await _storageService.initSecretKey(secretKey);
      _listenToUserByUserId(user.id);
    }
  }

  Future<void> initUserOnAppStart() async {
    final String? secretKey = await _storageService.getSecretKey();

    if (secretKey != null) {
      final User? user = await _fireUsersService.getUserBySecretKey(secretKey);
      // If user exists, initialise listeners
      if (user != null) {
        // SecretKey is already initialised in the StorageService. We need to make
        // sure that EncryptionService `key` is also up to date
        _encryptionService.updateSecretKey(secretKey);
        // Update user immediately in Store, because listening might take 0.x second to retrieve the
        // user from stream
        updateUserLocally(user);
        _listenToUserByUserId(user.id);
      }
      // If user doesn't exist, something went wrong, because SecretKey is in storage
      // yet there is no user found in Firestore. Investigate.
      else {
        loggingService.log(
          'UsersStore._initAndListenToUser: User from firestore is null',
          logType: LogType.error,
        );
      }
    } else {
      loggingService.log('UsersStore.initUserOnAppStart: SecretKey is null - user is not logged in');
    }
  }

  Future<User?> _getUserBySecretKey(String secretKey) async {
    final User? user = await _fireUsersService.getUserBySecretKey(secretKey);

    return user;
  }

  Future<bool> registerUser(User user) async {
    await _storageService.initSecretKey(user.sensitiveInformation.secretKey);

    final String? userId = await _fireUsersService.registerUser(user);

    // If userId is not null, fetch user from firestore and start listener
    if (userId != null) {
      final User? user = await _getUserById(userId);

      if (user != null) {
        loggingService.log('UsersStore.registerUser: User registered. UserId: $userId');
        updateUserLocally(user);
        _listenToUserByUserId(userId);

        return true;
      }
      // If userId is not null but user from firestore is null, something went wrong.
      // Investigate
      else {
        loggingService.log('UsersStore.registerUser: User is null from Firestore', logType: LogType.error);
        return false;
      }
    }
    // If userId is null
    else {
      loggingService.log('UsersStore.registerUser: User is null', logType: LogType.error);
      return false;
    }
  }

  void _listenToUserByUserId(String userId) {
    final StreamSubscription streamSubscription = _fireUsersService.listenToUserById(
      userId,
      onUserChanged: (user) => updateUserLocally(user),
    );

    _streamSubscriptions.add(streamSubscription);
  }

  Future<User?> _getUserById(String userId) async {
    final User? user = await _fireUsersService.getUserById(userId);

    return user;
  }

  void resetStore() {
    _streamSubscriptions.forEach((element) {
      element?.cancel();
    });
    _streamSubscriptions.clear();

    updateUserLocally(null);
  }
}
