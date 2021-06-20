import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:secretum/main.dart';
import 'package:secretum/models/user.dart';
import 'package:secretum/services/encryption_service.dart';

import '../mocked_classes.mocks.dart';
import '../test_utils.dart';

void main() {
  loggingService = MockLoggingService();

  final MockUsersSensitiveInformation mockUsersSensitiveInformation = MockUsersSensitiveInformation();
  final MockDocumentSnapshot mockDocumentSnapshot = MockDocumentSnapshot();
  final MockDocumentChange mockDocumentChange = MockDocumentChange();

  late EncryptionService encryptionService;

  setUp(() {
    GetIt.instance.registerSingleton(EncryptionService());
    encryptionService = GetIt.instance<EncryptionService>();
  });

  tearDown(() async {
    reset(mockUsersSensitiveInformation);
    reset(mockDocumentSnapshot);
    reset(mockDocumentChange);
    await GetIt.instance.reset();
  });

  test('User', () {
    final User user = User(mockUsersSensitiveInformation);

    expect(user.sensitiveInformation, mockUsersSensitiveInformation);
  });

  test('User.newUser', () {
    final User user = User.newUser(mockUsersSensitiveInformation);

    expect(user.sensitiveInformation, mockUsersSensitiveInformation);
  });

  test('User.fromFirestore', () {
    encryptionService.updateSecretKey(TestUtils.kEncryptionSecretKey);

    when(mockDocumentSnapshot.data()).thenReturn(TestUtils.getUserEncryptedMap());
    when(mockDocumentSnapshot.id).thenReturn('1');

    final User user = User.fromFirestore(mockDocumentSnapshot);

    expect(user.documentSnapshot, mockDocumentSnapshot);
    expect(user.documentChangeType, isNull);
    expect(user.id, '1');
    expect(user.sensitiveInformation.secretKey, 'fb575ab0dacff2d434656d88871a9991b13df170f052a4e3affd5812a305a2c7');
    expect(user.sensitiveInformation.primaryPassword, '004c4ecec0ca4a52dbc7fa814f7e70f914b9f263a91b9fde6431798e38640ff7');
    expect(user.sensitiveInformation.secondaryPassword, 'b58791e1c591b5debacfad1a10613335335174ca27c68effaf34995e74db0ef3');
  });

  test('User.fromFirestoreChanged', () {
    encryptionService.updateSecretKey(TestUtils.kEncryptionSecretKey);

    when(mockDocumentChange.doc).thenReturn(mockDocumentSnapshot);
    when(mockDocumentChange.type).thenReturn(DocumentChangeType.added);
    when(mockDocumentSnapshot.data()).thenReturn(TestUtils.getUserEncryptedMap());
    when(mockDocumentSnapshot.id).thenReturn('1');

    final User user = User.fromFirestoreChanged(mockDocumentChange);

    expect(user.documentSnapshot, mockDocumentSnapshot);
    expect(user.documentChangeType, DocumentChangeType.added);
    expect(user.id, '1');
    expect(user.sensitiveInformation.secretKey, 'fb575ab0dacff2d434656d88871a9991b13df170f052a4e3affd5812a305a2c7');
    expect(user.sensitiveInformation.primaryPassword, '004c4ecec0ca4a52dbc7fa814f7e70f914b9f263a91b9fde6431798e38640ff7');
    expect(user.sensitiveInformation.secondaryPassword, 'b58791e1c591b5debacfad1a10613335335174ca27c68effaf34995e74db0ef3');
  });

  group('User.fromJson', () {
    test('isEncrypted', () {
      final User user = User.fromJson(TestUtils.getUserEncryptedMap());

      expect(user.sensitiveInformation.secretKey, 'fb575ab0dacff2d434656d88871a9991b13df170f052a4e3affd5812a305a2c7');
      expect(user.sensitiveInformation.primaryPassword, '004c4ecec0ca4a52dbc7fa814f7e70f914b9f263a91b9fde6431798e38640ff7');
      expect(user.sensitiveInformation.secondaryPassword, 'b58791e1c591b5debacfad1a10613335335174ca27c68effaf34995e74db0ef3');
    });
    test('!isEncrypted', () {
      final User user = User.fromJson(TestUtils.getUserEncryptedMap(), isEncrypted: false);

      expect(user.sensitiveInformation.secretKey, 'fb575ab0dacff2d434656d88871a9991b13df170f052a4e3affd5812a305a2c7');
      expect(user.sensitiveInformation.primaryPassword, '004c4ecec0ca4a52dbc7fa814f7e70f914b9f263a91b9fde6431798e38640ff7');
      expect(user.sensitiveInformation.secondaryPassword, 'b58791e1c591b5debacfad1a10613335335174ca27c68effaf34995e74db0ef3');
    });
  });

  group('toJson', () {
    test('isEncrypted', () {
      final Map<String, dynamic> userMap = TestUtils.getUser().toJson();

      expect(userMap, TestUtils.getUserEncryptedMap());
    });
    test('!isEncrypted', () {
      final Map<String, dynamic> userMap = TestUtils.getUser().toJson(isEncrypted: false);

      expect(userMap, TestUtils.getUserDecryptedMap());
    });
  });
}
