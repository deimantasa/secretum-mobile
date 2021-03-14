import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:secretum/main.dart';
import 'package:secretum/models/log_type.dart';
import 'package:secretum/models/user.dart';
import 'package:secretum/services/firestore/fire_users_service.dart';
import 'package:secretum/services/storage_service.dart';

class UsersStore extends ChangeNotifier {
  final StorageService _storageService = GetIt.instance<StorageService>();
  final FireUsersService _fireUsersService = GetIt.instance<FireUsersService>();

  List<StreamSubscription?> _streamSubscriptions = [];

  User? user;

  void updateUserLocally(User? user) {
    this.user = user;
    notifyListeners();
  }

  Future<void> initUserViaSecretKey(String secretKey) async {
    User? user = await _getUserBySecretKey(secretKey);
    if (user != null) {
      updateUserLocally(user);
      await _storageService.initSecretKey(secretKey);
      _listenToUserByUserId(user.documentSnapshot!.id);
    }
  }

  Future<void> initUserOnAppStart() async {
    String? secretKey = await _storageService.getSecretKey();

    if (secretKey != null) {
      User? user = await _fireUsersService.getUserBySecretKey(secretKey);
      //If user exists, initialise listeners
      if (user != null && user.documentSnapshot != null) {
        //SecretKey is already init'd in the StorageService. We need to make
        //sure that EncryptionService `key` is also up to date
        encryptionService.updateSecretKey(secretKey);
        _listenToUserByUserId(user.documentSnapshot!.id);
      }
      //If user doesn't exist, something went wrong, because SecretKey is in storage
      //yet there is no user found in Firestore. Investigate.
      else {
        loggingService.log(
          "UsersStore._initAndListenToUser: User from firestore is null",
          logType: LogType.error,
        );
      }
    } else {
      loggingService.log("UsersStore.initUserOnAppStart: SecretKey is null - user is not logged in");
    }
  }

  Future<User?> _getUserBySecretKey(String secretKey) async {
    User? user = await _fireUsersService.getUserBySecretKey(secretKey);
    return user;
  }

  Future<bool> registerUser(User user) async {
    await _storageService.initSecretKey(user.sensitiveInformation.secretKey);

    String? userId = await _fireUsersService.registerUser(user);

    //If userId is not null, fetch user from firestore and start listener
    if (userId != null) {
      User? user = await _getUserById(userId);
      if (user != null) {
        loggingService.log("UsersStore.registerUser: User registered. UserId: $userId");
        updateUserLocally(user);
        _listenToUserByUserId(userId);

        return true;
      }
      //If userId is not null but user from firestore is null, something went wrong.
      //Investigate
      else {
        loggingService.log(
          "UsersStore.registerUser: User is null from Firestore",
          logType: LogType.error,
        );
        return false;
      }
    }
    //If userId is null
    else {
      loggingService.log(
        "UsersStore.registerUser: User is null",
        logType: LogType.error,
      );
      return false;
    }
  }

  void _listenToUserByUserId(String userId) {
    StreamSubscription streamSubscription = _fireUsersService.listenToUserById(
      userId,
      onUserChanged: (user) => updateUserLocally(user),
    );

    _streamSubscriptions.add(streamSubscription);
  }

  Future<User?> _getUserById(String userId) async {
    User? user = await _fireUsersService.getUserById(userId);
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
