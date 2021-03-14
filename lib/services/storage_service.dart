import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:secretum/main.dart';

class StorageService {
  final String _secretKey = "secretKey";
  final FlutterSecureStorage _flutterSecureStorage = FlutterSecureStorage();

  ///Not hashed and not encrypted secretKey (raw)
  Future<String?> getSecretKey() async {
    String? secretKey = await _flutterSecureStorage.read(key: _secretKey);
    if (secretKey != null) {
      loggingService.log("StorageService.getSecretKey: SecretKey retrieved: $secretKey");
      return secretKey;
    } else {
      loggingService.log("StorageService.getSecretKey: SecretKey is null");
      return null;
    }
  }

  ///Not hashed and not encrypted secretKey (raw)
  Future<void> initSecretKey(String secretKey) async {
    await _flutterSecureStorage.write(key: _secretKey, value: secretKey);
    encryptionService.updateSecretKey(secretKey);

    loggingService.log("StorageService.initSecretKey: SecretKey init'd. $secretKey");
  }

  Future<void> resetStorage() async {
    await _flutterSecureStorage.deleteAll();
    encryptionService.updateSecretKey("");

    loggingService.log("StorageService.resetStorage: Storage reset");
  }
}
