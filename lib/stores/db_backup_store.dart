import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:secretum/models/db_backup.dart';
import 'package:secretum/services/storage_service.dart';

class DbBackupStore extends ChangeNotifier {
  final StorageService _storageService;

  DbBackup? _dbBackup;

  DbBackup? get dbBackup => _dbBackup;

  DbBackupStore({
    StorageService? storageService,
  }) : this._storageService = storageService ?? GetIt.instance<StorageService>();

  Future<void> initDbBackup() async {
    final DbBackup? dbBackup = await _storageService.getDbBackup();

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

  void resetStore() {
    _dbBackup = null;
  }
}
