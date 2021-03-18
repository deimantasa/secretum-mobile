import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:secretum/models/db_backup.dart';
import 'package:secretum/services/storage_service.dart';

class DbBackupStore extends ChangeNotifier {
  final StorageService _storageService = GetIt.instance<StorageService>();

  DbBackup? _dbBackup;

  DbBackup? get dbBackup => _dbBackup;

  Future<void> initDbBackup() async {
    DbBackup? dbBackup = await _storageService.getDbBackup();
    _updateDbBackup(dbBackup);
  }

  Future<void> updateDbBackupInLocalDb(DbBackup dbBackup) async {
    await _storageService.updateDbBackup(dbBackup);
    _updateDbBackup(dbBackup);
  }

  void _updateDbBackup(DbBackup? dbBackup) {
    _dbBackup = dbBackup;
    notifyListeners();
  }
}
