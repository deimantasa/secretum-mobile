import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';
import 'package:secretum/main.dart';
import 'package:secretum/models/enums/log_type.dart';
import 'package:secretum/models/secret.dart';
import 'package:secretum/services/encryption_service.dart';

class StorageService {
  static const String _kSecretKey = 'secretKey';

  final EncryptionService _encryptionService;
  final FlutterSecureStorage _flutterSecureStorage;

  StorageService({FlutterSecureStorage? flutterSecureStorage})
      : this._encryptionService = GetIt.instance<EncryptionService>(),
        this._flutterSecureStorage = flutterSecureStorage ?? FlutterSecureStorage();

  /// Not hashed and not encrypted secretKey (raw)
  Future<String?> getSecretKey() async {
    final String? secretKey = await _flutterSecureStorage.read(key: _kSecretKey);
    print(secretKey);

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

  Future<String> exportBackup(List<Secret> secrets, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/$fileName.txt');
    final List<Map<String, dynamic>> secretsJson = secrets.map((e) => e.toJson()).toList();
    final String secretsJsonString = json.encode(secretsJson);
    await file.writeAsString(secretsJsonString);

    return file.path;
  }

  Future<void> resetStorage() async {
    await _flutterSecureStorage.deleteAll();
    _encryptionService.updateSecretKey('');
    await deleteBackupFiles();

    loggingService.log('StorageService.resetStorage: Storage reset');
  }

  Future<bool> deleteBackupFiles() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    try {
      await directory.delete(recursive: true);
      return true;
    } catch (e) {
      loggingService.log('StorageService.deleteBackupFiles: Cannot delete backups. Exception: $e', logType: LogType.error);
      return false;
    }
  }
}
