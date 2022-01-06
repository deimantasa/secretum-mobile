import 'package:secretum/models/secret.dart';
import 'package:secretum/models/user.dart';
import 'package:secretum/models/users_sensitive_information.dart';
import 'package:secretum/utils/utils.dart';

class TestUtils {
  static const String kLateInitializationErrorCaught = 'LateInitializationError caught';
  static const String kEncryptionSecretKey = 'gHgAe/qddTarEgNFcknw3DETxDlYiSRX';

  /// 2020-01-01 00-00-00
  static final DateTime createdAtDate = DateTime(2000, 1, 1, 0, 0, 0, 0, 0);
  static const int kCreatedAtMillis = 946659600000;

  /// Secret
  static Secret getSecret(DateTime dateTime) {
    return Secret('addedBy1', dateTime, 'name1', 'note1', 'code1');
  }

  static Map<String, dynamic> getSecretEncryptedMap(DateTime dateTime) {
    return {
      'addedBy': 'EwXRom7htzdBRerdld7PAA==',
      'createdAt': Utils.dateTimeToInt(dateTime),
      'name': 'HADYojuoxQ1CRunelt3MAw==',
      'note': 'HA7BojuoxQ1CRunelt3MAw==',
      'code': 'EQ7RojuoxQ1CRunelt3MAw=='
    };
  }

  static Map<String, dynamic> getSecretDecryptedMap(DateTime dateTime) {
    return {'addedBy': 'addedBy1', 'createdAt': Utils.dateTimeToInt(dateTime), 'name': 'name1', 'note': 'note1', 'code': 'code1'};
  }

  /// User
  static User getUser() {
    return User(getUsersSensitiveInformation(), createdAtDate);
  }

  static Map<String, dynamic> getUserEncryptedMap() {
    return {
      'createdAt': kCreatedAtMillis,
      'sensitiveInformation': getUsersSensitiveInformationHashedMap(),
    };
  }

  static Map<String, dynamic> getUserDecryptedMap() {
    return {
      'createdAt': kCreatedAtMillis,
      'sensitiveInformation': getUsersSensitiveInformationHashedMap(),
    };
  }

  /// UsersSensitiveInformation
  static UsersSensitiveInformation getUsersSensitiveInformation() {
    return UsersSensitiveInformation('secretKey1', 'primaryPassword1');
  }

  static Map<String, dynamic> getUsersSensitiveInformationHashedMap() {
    return {
      'secretKey': 'fb575ab0dacff2d434656d88871a9991b13df170f052a4e3affd5812a305a2c7',
      'primaryPassword': '004c4ecec0ca4a52dbc7fa814f7e70f914b9f263a91b9fde6431798e38640ff7',
    };
  }

  static Map<String, dynamic> getUsersSensitiveInformationUnHashedMap() {
    return {
      'secretKey': 'secretKey1',
      'primaryPassword': 'primaryPassword1',
    };
  }
}
