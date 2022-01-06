import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:secretum/main.dart';
import 'package:secretum/models/secret.dart';
import 'package:secretum/services/encryption_service.dart';

import '../mocked_classes.mocks.dart';
import '../test_utils.dart';

void main() {
  loggingService = MockLoggingService();

  final MockDocumentSnapshot mockDocumentSnapshot = MockDocumentSnapshot();
  final MockDocumentChange mockDocumentChange = MockDocumentChange();

  late EncryptionService encryptionService;

  setUp(() {
    GetIt.instance.registerSingleton(EncryptionService());
    encryptionService = GetIt.instance<EncryptionService>();
  });

  tearDown(() async {
    reset(mockDocumentSnapshot);
    reset(mockDocumentChange);
    await GetIt.instance.reset();
  });

  test('Secret', () {
    final DateTime dateTime = DateTime.now();
    final Secret secret = Secret('addedBy', dateTime, 'name', 'note', 'code');

    expect(secret.addedBy, 'addedBy');
    expect(secret.createdAt, dateTime);
    expect(secret.name, 'name');
    expect(secret.note, 'note');
    expect(secret.code, 'code');
  });

  test('Secret.newSecret', () {
    final DateTime dateTime = DateTime.now();
    final Secret secret = Secret.newSecret(addedBy: 'addedBy', createdAt: dateTime, name: 'name');

    expect(secret.addedBy, 'addedBy');
    expect(secret.createdAt, dateTime);
    expect(secret.name, 'name');
    expect(secret.note, '');
    expect(secret.code, '');
  });

  test('Secret.fromFirestore', () {
    final DateTime dateTime = DateTime(2020);
    encryptionService.updateSecretKey(TestUtils.kEncryptionSecretKey);

    when(mockDocumentSnapshot.data()).thenReturn(TestUtils.getSecretEncryptedMap(dateTime));
    when(mockDocumentSnapshot.id).thenReturn('1');

    final Secret secret = Secret.fromFirestore(mockDocumentSnapshot);

    expect(secret.documentSnapshot, mockDocumentSnapshot);
    expect(secret.documentChangeType, isNull);
    expect(secret.id, '1');
    expect(secret.addedBy, 'addedBy1');
    expect(secret.createdAt, dateTime);
    expect(secret.name, 'name1');
    expect(secret.note, 'note1');
    expect(secret.code, 'code1');
  });

  test('Secret.fromFirestoreChanged', () {
    final DateTime dateTime = DateTime(2020);
    encryptionService.updateSecretKey(TestUtils.kEncryptionSecretKey);

    when(mockDocumentChange.doc).thenReturn(mockDocumentSnapshot);
    when(mockDocumentChange.type).thenReturn(DocumentChangeType.added);
    when(mockDocumentSnapshot.data()).thenReturn(TestUtils.getSecretEncryptedMap(dateTime));
    when(mockDocumentSnapshot.id).thenReturn('1');

    final Secret secret = Secret.fromFirestoreChanged(mockDocumentChange);

    expect(secret.documentSnapshot, mockDocumentSnapshot);
    expect(secret.documentChangeType, DocumentChangeType.added);
    expect(secret.id, '1');
    expect(secret.addedBy, 'addedBy1');
    expect(secret.createdAt, dateTime);
    expect(secret.name, 'name1');
    expect(secret.note, 'note1');
    expect(secret.code, 'code1');
  });

  group('Secret.fromJson', () {
    test('isEncrypted', () {
      final DateTime dateTime = DateTime(2020);
      final Secret secret = Secret.fromJson(TestUtils.getSecretEncryptedMap(dateTime));

      expect(secret.addedBy, 'addedBy1');
      expect(secret.createdAt, dateTime);
      expect(secret.name, 'name1');
      expect(secret.note, 'note1');
      expect(secret.code, 'code1');
    });

    test('!isEncrypted', () {
      final DateTime dateTime = DateTime(2020);
      final Secret secret = Secret.fromJson(TestUtils.getSecretDecryptedMap(dateTime), isEncrypted: false);

      expect(secret.addedBy, 'addedBy1');
      expect(secret.createdAt, dateTime);
      expect(secret.name, 'name1');
      expect(secret.note, 'note1');
      expect(secret.code, 'code1');
    });
  });

  group('toJson', () {
    test('isEncrypted', () {
      final DateTime dateTime = DateTime(2020);
      final Map<String, dynamic> secretMap = TestUtils.getSecret(dateTime).toJson();

      expect(secretMap, TestUtils.getSecretEncryptedMap(dateTime));
    });

    test('!isEncrypted', () {
      final DateTime dateTime = DateTime(2020);
      final Map<String, dynamic> secretMap = TestUtils.getSecret(dateTime).toJson(isEncrypted: false);

      expect(secretMap, TestUtils.getSecretDecryptedMap(dateTime));
    });
  });
}
