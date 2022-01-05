import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';
import 'package:secretum/main.dart';
import 'package:secretum/models/db_backup.dart';
import 'package:secretum/models/enums/log_type.dart';
import 'package:secretum/models/secret.dart';
import 'package:secretum/services/encryption_service.dart';

class StorageService {
  static const String _kSecretKey = 'secretKey';
  static const String _kDbBackupKey = 'dbBackupKey';

  final EncryptionService _encryptionService;
  final FlutterSecureStorage _flutterSecureStorage;

  StorageService({FlutterSecureStorage? flutterSecureStorage})
      : this._encryptionService = GetIt.instance<EncryptionService>(),
        this._flutterSecureStorage = flutterSecureStorage ?? FlutterSecureStorage();

  /// Not hashed and not encrypted secretKey (raw)
  Future<String?> getSecretKey() async {
    final String? secretKey = await _flutterSecureStorage.read(key: _kSecretKey);

    if (secretKey != null) {
      loggingService.log('StorageService.getSecretKey: SecretKey retrieved: $secretKey');
      return secretKey;
    } else {
      loggingService.log('StorageService.getSecretKey: SecretKey is null');
      return null;
    }
  }

  /// Not hashed and not encrypted secretKey (raw)
  Future<void> initSecretKey(String secretKey) async {
    await _flutterSecureStorage.write(key: _kSecretKey, value: secretKey);
    _encryptionService.updateSecretKey(secretKey);

    loggingService.log("StorageService.initSecretKey: SecretKey init'd. $secretKey");
  }

  Future<DbBackup?> getDbBackup() async {
    final String? dbBackupString = await _flutterSecureStorage.read(key: _kDbBackupKey);

    if (dbBackupString != null) {
      try {
        final DbBackup dbBackup = DbBackup.fromJson(json.decode(dbBackupString));

        loggingService.log('StorageService.getDbBackup: DbBackup retrieved');
        return dbBackup;
      } catch (e) {
        loggingService.log('StorageService.getDbBackup: DbBackup parsing failed. $e', logType: LogType.error);
        return null;
      }
    } else {
      loggingService.log('StorageService.getDbBackup: dbBackupString is null');
      return null;
    }
  }

  Future<void> updateDbBackup(DbBackup dbBackup) async {
    final String dbBackupString = json.encode(dbBackup.toJson());

    await _flutterSecureStorage.write(key: _kDbBackupKey, value: dbBackupString);
    loggingService.log('StorageService.updateDbBackup: DbBackup backed up');
  }

  Future<String> exportBackup(List<Secret> secrets, String fileName) async {
    const String divider = '***************************';
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/$fileName.txt');

    // Generate Text and write to file
    final StringBuffer stringBuffer = StringBuffer();
    stringBuffer.writeln(divider);
    stringBuffer.writeln('');

    secrets.forEach((secret) {
      stringBuffer.writeln('Secret Name: ${secret.name}');
      stringBuffer.writeln('Secret Code: ${secret.code}');
      stringBuffer.writeln('');
      stringBuffer.writeln(divider);
      stringBuffer.writeln('');
    });

    await file.writeAsString(stringBuffer.toString());

    return file.path;
  }

  Future<void> resetStorage() async {
    await _flutterSecureStorage.deleteAll();
    _encryptionService.updateSecretKey('');

    //TODO test
    final Directory directory = await getApplicationDocumentsDirectory();
    directory.delete(recursive: true);

    loggingService.log('StorageService.resetStorage: Storage reset');
  }
}
