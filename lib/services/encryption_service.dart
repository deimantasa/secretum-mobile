import 'dart:convert';

import 'package:crypto/crypto.dart' as crypto;
import 'package:encrypt/encrypt.dart';
import 'package:secretum/main.dart';

class EncryptionService {
  String _key = '';

  String generateSecretKey() {
    final String secretKey = Key.fromSecureRandom(24).base64;
    loggingService.log('EncryptionService.generateSecretKey: SecretKey: $secretKey');
    return secretKey;
  }

  void updateSecretKey(String secretKey) {
    loggingService.log('EncryptionService.updateSecretKey: SecretKey: $secretKey');
    _key = secretKey;
  }

  void resetSecretKey() {
    _key = '';
  }

  String getEncryptedText(String text) {
    final Key key = Key.fromUtf8(_key);
    final IV iv = IV.fromLength(16);
    final Encrypter encrypter = Encrypter(AES(key));
    final Encrypted encrypted = encrypter.encrypt(text, iv: iv);

    return encrypted.base64;
  }

  String getDecryptedText(String text) {
    final Key key = Key.fromUtf8(_key);
    final IV iv = IV.fromLength(16);
    final Encrypter encrypter = Encrypter(AES(key));

    return encrypter.decrypt64(text, iv: iv);
  }

  String getHashedText(String text) {
    final List<int> bytes = utf8.encode(text);
    final crypto.Digest digest = crypto.sha256.convert(bytes);
    return digest.toString();
  }
}
