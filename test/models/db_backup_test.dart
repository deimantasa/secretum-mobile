import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:secretum/main.dart';
import 'package:secretum/models/db_backup.dart';
import 'package:secretum/models/secret.dart';
import 'package:secretum/services/encryption_service.dart';

import '../mocked_classes.mocks.dart';
import '../test_utils.dart';

void main() {
  loggingService = MockLoggingService();
  final MockSecret mockSecret = MockSecret();

  late EncryptionService encryptionService;

  setUp(() {
    GetIt.instance.registerSingleton(EncryptionService());
    encryptionService = GetIt.instance<EncryptionService>();
  });

  tearDown(() async {
    reset(mockSecret);
    await GetIt.instance.reset();
  });

  test('DbBackup', () {
    final DateTime dateTime = DateTime(2020, 1, 2);
    final DbBackup dbBackup = DbBackup([mockSecret, mockSecret, mockSecret], dateTime);

    expect(dbBackup.secrets.length, 3);
    expect(dbBackup.backupDate, dateTime);
  });

  group('DbBackup.fromJson', () {
    test('defaults', () {
      final DateTime dateTime = DateTime.now();
      final Map<String, dynamic> dataMap = {'secrets': null, 'backupDate': dateTime.toIso8601String()};

      final DbBackup dbBackup = DbBackup.fromJson(dataMap);

      expect(dbBackup.secrets, isEmpty);
      expect(dbBackup.backupDate, dateTime);
    });
    test('regular', () {
      final DateTime dateTime = DateTime.now();
      final Map<String, dynamic> dataMap = {
        'secrets': [Secret(null, null, null, null, null).toJson(), Secret(null, null, null, null, null).toJson()],
        'backupDate': dateTime.toIso8601String()
      };

      final DbBackup dbBackup = DbBackup.fromJson(dataMap);

      expect(dbBackup.secrets.length, 2);
      expect(dbBackup.backupDate, dateTime);
    });
  });

  test('toJson', () {
    encryptionService.updateSecretKey(TestUtils.kEncryptionSecretKey);
    final Secret secretOne = Secret('addedBy1', DateTime.now(), 'name1', 'note1', 'code1');
    final Secret secretTwo = Secret('addedBy2', DateTime.now(), 'name2', 'note2', 'code2');
    final DateTime dateTime = DateTime(2020, 1, 2);
    final DbBackup dbBackup = DbBackup([secretOne, secretTwo], dateTime);

    final Map<String, dynamic> dataMap = dbBackup.toJson();

    expect(dataMap, {
      'secrets': [
        {
          'addedBy': 'EwXRom7htzdBRerdld7PAA==',
          'name': 'HADYojuoxQ1CRunelt3MAw==',
          'note': 'HA7BojuoxQ1CRunelt3MAw==',
          'code': 'EQ7RojuoxQ1CRunelt3MAw=='
        },
        {
          'addedBy': 'EwXRom7htzRBRerdld7PAA==',
          'name': 'HADYojioxQ1CRunelt3MAw==',
          'note': 'HA7BojioxQ1CRunelt3MAw==',
          'code': 'EQ7RojioxQ1CRunelt3MAw=='
        }
      ],
      'backupDate': '2020-01-02T00:00:00.000'
    });
  });
}
