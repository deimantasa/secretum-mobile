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

  final mockDocumentSnapshot = MockDocumentSnapshot();
  final mockDocumentChange = MockDocumentChange();

  late EncryptionService encryptionService;

  setUp(() {
    GetIt.instance.registerSingleton(EncryptionService());

    encryptionService = GetIt.instance<EncryptionService>();
    encryptionService.updateSecretKey(TestUtils.kEncryptionSecretKey);
  });

  tearDown(() async {
    await GetIt.instance.reset();

    reset(mockDocumentSnapshot);
    reset(mockDocumentChange);
  });

  test('Secret', () {
    final dateTime = DateTime.now();
    final secret = Secret('addedBy', dateTime, 'name', 'note', 'code');

    expect(secret.addedBy, 'addedBy');
    expect(secret.createdAt, dateTime);
    expect(secret.updatedAt, dateTime);
    expect(secret.name, 'name');
    expect(secret.note, 'note');
    expect(secret.code, 'code');
  });

  test('Secret.newSecret', () {
    final dateTime = DateTime.now();
    final secret = Secret.newSecret(dateTime, addedBy: 'addedBy', name: 'name');

    expect(secret.addedBy, 'addedBy');
    expect(secret.createdAt, dateTime);
    expect(secret.updatedAt, dateTime);
    expect(secret.name, 'name');
    expect(secret.note, '');
    expect(secret.code, '');
  });

  test('Secret.fromFirestore', () {
    when(mockDocumentSnapshot.data()).thenReturn(TestUtils.getSecretEncryptedMap());
    when(mockDocumentSnapshot.id).thenReturn('1');

    final secret = Secret.fromFirestore(mockDocumentSnapshot);

    expect(secret.documentSnapshot, mockDocumentSnapshot);
    expect(secret.documentChangeType, isNull);
    expect(secret.id, '1');
    expect(secret.addedBy, 'addedBy1');
    expect(secret.createdAt, TestUtils.createdAtDate);
    expect(secret.updatedAt, TestUtils.createdAtDate);
    expect(secret.name, 'name1');
    expect(secret.note, 'note1');
    expect(secret.code, 'code1');
  });

  test('Secret.fromFirestoreChanged', () {
    when(mockDocumentChange.doc).thenReturn(mockDocumentSnapshot);
    when(mockDocumentChange.type).thenReturn(DocumentChangeType.added);
    when(mockDocumentSnapshot.data()).thenReturn(TestUtils.getSecretEncryptedMap());
    when(mockDocumentSnapshot.id).thenReturn('1');

    final secret = Secret.fromFirestoreChanged(mockDocumentChange);

    expect(secret.documentSnapshot, mockDocumentSnapshot);
    expect(secret.documentChangeType, DocumentChangeType.added);
    expect(secret.id, '1');
    expect(secret.addedBy, 'addedBy1');
    expect(secret.createdAt, TestUtils.createdAtDate);
    expect(secret.updatedAt, TestUtils.createdAtDate);
    expect(secret.name, 'name1');
    expect(secret.note, 'note1');
    expect(secret.code, 'code1');
  });

  group('Secret.fromJson', () {
    test('isEncrypted', () {
      final secret = Secret.fromJson(TestUtils.getSecretEncryptedMap());

      expect(secret.addedBy, 'addedBy1');
      expect(secret.createdAt, TestUtils.createdAtDate);
      expect(secret.updatedAt, TestUtils.createdAtDate);
      expect(secret.name, 'name1');
      expect(secret.note, 'note1');
      expect(secret.code, 'code1');
    });

    test('!isEncrypted', () {
      final dateTime = TestUtils.createdAtDate;
      final secret = Secret.fromJson(TestUtils.getSecretDecryptedMap(dateTime), isEncrypted: false);

      expect(secret.addedBy, 'addedBy1');
      expect(secret.createdAt, dateTime);
      expect(secret.updatedAt, dateTime);
      expect(secret.name, 'name1');
      expect(secret.note, 'note1');
      expect(secret.code, 'code1');
    });
  });

  group('toJson', () {
    test('isEncrypted', () {
      final dateTime = TestUtils.createdAtDate;
      final secretMap = TestUtils.getSecret(dateTime).toJson();

      expect(secretMap, TestUtils.getSecretEncryptedMap());
    });

    test('!isEncrypted', () {
      final dateTime = TestUtils.createdAtDate;
      final secretMap = TestUtils.getSecret(dateTime).toJson(isEncrypted: false);

      expect(secretMap, TestUtils.getSecretDecryptedMap(dateTime));
    });
  });
}
