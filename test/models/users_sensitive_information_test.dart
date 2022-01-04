import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:secretum/models/users_sensitive_information.dart';
import 'package:secretum/services/encryption_service.dart';

import '../mocked_classes.mocks.dart';
import '../test_utils.dart';

void main() {
  final MockUsersSensitiveInformation mockUsersSensitiveInformation = MockUsersSensitiveInformation();

  setUp(() {
    GetIt.instance.registerSingleton(EncryptionService());
  });

  tearDown(() async {
    reset(mockUsersSensitiveInformation);
    await GetIt.instance.reset();
  });

  test('UsersSensitiveInformation', () {
    final UsersSensitiveInformation usersSensitiveInformation = UsersSensitiveInformation('a', 'b');

    expect(usersSensitiveInformation.secretKey, 'a');
    expect(usersSensitiveInformation.primaryPassword, 'b');
  });

  test('UsersSensitiveInformation.newUser', () {
    final UsersSensitiveInformation usersSensitiveInformation = UsersSensitiveInformation.newUser('a', 'b');

    expect(usersSensitiveInformation.secretKey, 'a');
    expect(usersSensitiveInformation.primaryPassword, 'b');
  });

  test('UsersSensitiveInformation.fromJson', () {
    final Map<String, dynamic> dataMap = {'secretKey': 'a', 'primaryPassword': 'b', 'secondaryPassword': 'c'};

    final UsersSensitiveInformation usersSensitiveInformation = UsersSensitiveInformation.fromJson(dataMap);

    expect(usersSensitiveInformation.secretKey, 'a');
    expect(usersSensitiveInformation.primaryPassword, 'b');
  });

  group('toJson', () {
    test('isHashed', () {
      final Map<String, dynamic> dataMap = TestUtils.getUsersSensitiveInformation().toJson();

      expect(dataMap, TestUtils.getUsersSensitiveInformationHashedMap());
    });
    test('!isHashed', () {
      final Map<String, dynamic> dataMap = TestUtils.getUsersSensitiveInformation().toJson(isHashed: false);

      expect(dataMap, TestUtils.getUsersSensitiveInformationUnHashedMap());
    });
  });
}
