import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:secretum/main.dart';
import 'package:secretum/services/firestore/generic/firestore_generic_service.dart';

import '../../mocked_classes.mocks.dart';

// ignore: subtype_of_sealed_class
class MockQueryDocumentSnapshot extends Mock implements QueryDocumentSnapshot {
  @override
  String get id {
    return 'itemId';
  }
}

void main() {
  loggingService = MockLoggingService();

  final MockFirebaseFirestore mockFirebaseFirestore = MockFirebaseFirestore();
  final MockCollectionReference<Map<String, dynamic>> mockCollectionReference = MockCollectionReference();
  final MockDocumentReference<Map<String, dynamic>> mockDocumentReference = MockDocumentReference();
  final MockCollectionReference<Map<String, dynamic>> mockSubCollectionReference = MockCollectionReference();
  final MockDocumentReference<Map<String, dynamic>> mockSubCollectionDocumentReference = MockDocumentReference();
  final MockQuery mockQuery = MockQuery();
  final MockQuerySnapshot mockQuerySnapshot = MockQuerySnapshot();
  final MockQueryDocumentSnapshot mockQueryDocumentSnapshot = MockQueryDocumentSnapshot();
  final MockDocumentSnapshot mockDocumentSnapshot = MockDocumentSnapshot();

  late FireGenericService fireGenericService;

  setUp(() {
    fireGenericService = FireGenericService(firebaseFirestore: mockFirebaseFirestore);
  });

  tearDown(() {
    reset(mockFirebaseFirestore);
    reset(mockCollectionReference);
    reset(mockDocumentReference);
    reset(mockSubCollectionReference);
    reset(mockSubCollectionDocumentReference);
    reset(mockQuery);
    reset(mockQuerySnapshot);
    reset(mockQueryDocumentSnapshot);
    reset(mockDocumentSnapshot);
  });

  group('addDocument', () {
    group('success', () {
      test('documentId is null', () async {
        final void Function() onCollection = () => mockFirebaseFirestore.collection('collection');
        final void Function() onDocument = () => mockCollectionReference.doc(null);

        when(onCollection()).thenReturn(mockCollectionReference);
        when(onDocument()).thenReturn(mockDocumentReference);
        when(mockDocumentReference.id).thenReturn('docId');

        final String? documentId = await fireGenericService.addDocument('collection', {'key': 'value'});

        verify(onCollection()).called(1);
        verify(onDocument()).called(1);
        verify(mockDocumentReference.set({'key': 'value'})).called(1);
        expect(documentId, 'docId');
      });
      test('documentId is not null', () async {
        final void Function() onCollection = () => mockFirebaseFirestore.collection('collection');
        final void Function() onDocument = () => mockCollectionReference.doc('docId');

        when(onCollection()).thenReturn(mockCollectionReference);
        when(onDocument()).thenReturn(mockDocumentReference);
        when(mockDocumentReference.id).thenReturn('docId');

        final String? documentId = await fireGenericService.addDocument('collection', {'key': 'value'}, documentId: 'docId');

        verify(onCollection()).called(1);
        verify(onDocument()).called(1);
        verify(mockDocumentReference.set({'key': 'value'})).called(1);
        expect(documentId, 'docId');
      });
    });
    test('failure', () async {
      final void Function() onCollection = () => mockFirebaseFirestore.collection('collection');
      final void Function() onDocument = () => mockCollectionReference.doc(any);

      when(mockFirebaseFirestore.collection('collection')).thenThrow(Exception('error'));

      final String? documentId = await fireGenericService.addDocument('collection', {'key': 'value'}, documentId: 'docId');

      verify(onCollection()).called(1);
      verifyNever(onDocument());
      verifyNever(mockDocumentReference.set(any));
      expect(documentId, isNull);
    });
  });

  group('addSubCollectionDocument', () {
    group('success', () {
      test('subCollectionDocumentId is null', () async {
        final void Function() onCollection = () => mockFirebaseFirestore.collection('collection');
        final void Function() onDocument = () => mockCollectionReference.doc('documentId');
        final void Function() onSubCollection = () => mockDocumentReference.collection('subCollection');
        final void Function() onSubCollectionDocument = () => mockSubCollectionReference.doc(null);

        when(onCollection()).thenReturn(mockCollectionReference);
        when(onDocument()).thenReturn(mockDocumentReference);
        when(onSubCollection()).thenReturn(mockSubCollectionReference);
        when(onSubCollectionDocument()).thenReturn(mockSubCollectionDocumentReference);
        when(mockSubCollectionDocumentReference.id).thenReturn('docId');

        final String? documentId = await fireGenericService.addSubCollectionDocument(
          collection: 'collection',
          documentId: 'documentId',
          subCollection: 'subCollection',
          update: {'key': 'value'},
        );

        verify(onCollection()).called(1);
        verify(onDocument()).called(1);
        verify(onSubCollection()).called(1);
        verify(onSubCollectionDocument()).called(1);
        verify(mockSubCollectionDocumentReference.set({'key': 'value'})).called(1);
        expect(documentId, 'docId');
      });
      test('subCollectionDocumentId is not null', () async {
        final void Function() onCollection = () => mockFirebaseFirestore.collection('collection');
        final void Function() onDocument = () => mockCollectionReference.doc('documentId');
        final void Function() onSubCollection = () => mockDocumentReference.collection('subCollection');
        final void Function() onSubCollectionDocument = () => mockSubCollectionReference.doc('docId');

        when(onCollection()).thenReturn(mockCollectionReference);
        when(onDocument()).thenReturn(mockDocumentReference);
        when(onSubCollection()).thenReturn(mockSubCollectionReference);
        when(onSubCollectionDocument()).thenReturn(mockSubCollectionDocumentReference);
        when(mockSubCollectionDocumentReference.id).thenReturn('docId');

        final String? documentId = await fireGenericService.addSubCollectionDocument(
            collection: 'collection',
            documentId: 'documentId',
            subCollection: 'subCollection',
            update: {'key': 'value'},
            subCollectionDocumentId: 'docId');

        verify(onCollection()).called(1);
        verify(onDocument()).called(1);
        verify(onSubCollection()).called(1);
        verify(onSubCollectionDocument()).called(1);
        verify(mockSubCollectionDocumentReference.set({'key': 'value'})).called(1);
        expect(documentId, 'docId');
      });
    });
    test('failure', () async {
      final void Function() onCollection = () => mockFirebaseFirestore.collection('collection');
      final void Function() onDocument = () => mockCollectionReference.doc(any);
      final void Function() onSubCollection = () => mockDocumentReference.collection(any);
      final void Function() onSubCollectionDocument = () => mockSubCollectionReference.doc(any);

      when(onCollection()).thenThrow(Exception('error'));

      final String? documentId = await fireGenericService.addSubCollectionDocument(
          collection: 'collection',
          documentId: 'documentId',
          subCollection: 'subCollection',
          update: {'key': 'value'},
          subCollectionDocumentId: 'docId');

      verify(onCollection()).called(1);
      verifyNever(onDocument());
      verifyNever(onSubCollection());
      verifyNever(onSubCollectionDocument());
      verifyNever(mockDocumentReference.set({'key': 'value'}));
      expect(documentId, isNull);
    });
  });

  group('updateDocument', () {
    test('success', () async {
      final void Function() onCollection = () => mockFirebaseFirestore.collection('collection');
      final void Function() onDocument = () => mockCollectionReference.doc('docId');

      when(onCollection()).thenReturn(mockCollectionReference);
      when(onDocument()).thenReturn(mockDocumentReference);

      final bool isSuccess = await fireGenericService.updateDocument('collection', 'docId', {'key': 'value'});

      verify(onCollection()).called(1);
      verify(onDocument()).called(1);
      verify(mockDocumentReference.update({'key': 'value'})).called(1);
      expect(isSuccess, isTrue);
    });
    test('failure', () async {
      final void Function() onCollection = () => mockFirebaseFirestore.collection('collection');
      final void Function() onDocument = () => mockCollectionReference.doc(any);

      when(onCollection()).thenThrow(Exception('error'));

      final bool isSuccess = await fireGenericService.updateDocument('collection', 'docId', {'key': 'value'});

      verify(onCollection()).called(1);
      verifyNever(onDocument());
      verifyNever(mockDocumentReference.update(any));
      expect(isSuccess, isFalse);
    });
  });

  group('updateSubCollectionsDocument', () {
    test('success', () async {
      final void Function() onCollection = () => mockFirebaseFirestore.collection('collection');
      final void Function() onDocument = () => mockCollectionReference.doc('docId');
      final void Function() onSubCollection = () => mockDocumentReference.collection('subCollection');
      final void Function() onSubCollectionDocument = () => mockSubCollectionReference.doc('subCollectionDocId');

      when(onCollection()).thenReturn(mockCollectionReference);
      when(onDocument()).thenReturn(mockDocumentReference);
      when(onSubCollection()).thenReturn(mockSubCollectionReference);
      when(onSubCollectionDocument()).thenReturn(mockSubCollectionDocumentReference);

      final bool isSuccess = await fireGenericService.updateSubCollectionsDocument(
        collection: 'collection',
        documentId: 'docId',
        subCollection: 'subCollection',
        subCollectionDocumentId: 'subCollectionDocId',
        update: {'key': 'value'},
      );

      verify(onCollection()).called(1);
      verify(onDocument()).called(1);
      verify(onSubCollection()).called(1);
      verify(onSubCollectionDocument()).called(1);
      verify(mockSubCollectionDocumentReference.update({'key': 'value'})).called(1);
      expect(isSuccess, isTrue);
    });
    test('failure', () async {
      final void Function() onCollection = () => mockFirebaseFirestore.collection('collection');
      final void Function() onDocument = () => mockCollectionReference.doc('docId');
      final void Function() onSubCollection = () => mockDocumentReference.collection('subCollection');
      final void Function() onSubCollectionDocument = () => mockSubCollectionReference.doc('subCollectionDocId');

      when(onCollection()).thenThrow(Exception('error'));

      final bool isSuccess = await fireGenericService.updateSubCollectionsDocument(
        collection: 'collection',
        documentId: 'docId',
        subCollection: 'subCollection',
        subCollectionDocumentId: 'subCollectionDocId',
        update: {'key': 'value'},
      );

      verify(onCollection()).called(1);
      verifyNever(onDocument());
      verifyNever(onSubCollection());
      verifyNever(onSubCollectionDocument());
      verifyNever(mockSubCollectionDocumentReference.update(any));
      expect(isSuccess, isFalse);
    });
  });

  group('deleteDocument', () {
    test('success', () async {
      final void Function() onCollection = () => mockFirebaseFirestore.collection('collection');
      final void Function() onDocument = () => mockCollectionReference.doc('docId');

      when(onCollection()).thenReturn(mockCollectionReference);
      when(onDocument()).thenReturn(mockDocumentReference);

      final bool isSuccess = await fireGenericService.deleteDocument('collection', 'docId');

      verify(onCollection()).called(1);
      verify(onDocument()).called(1);
      verify(mockDocumentReference.delete()).called(1);
      expect(isSuccess, isTrue);
    });
    test('failure', () async {
      final void Function() onCollection = () => mockFirebaseFirestore.collection('collection');
      final void Function() onDocument = () => mockCollectionReference.doc(any);

      when(onCollection()).thenThrow(Exception('error'));

      final bool isSuccess = await fireGenericService.deleteDocument('collection', 'docId');

      verify(onCollection()).called(1);
      verifyNever(onDocument());
      verifyNever(mockDocumentReference.delete());
      expect(isSuccess, isFalse);
    });
  });

  group('deleteSubCollectionsDocument', () {
    test('success', () async {
      final void Function() onCollection = () => mockFirebaseFirestore.collection('collection');
      final void Function() onDocument = () => mockCollectionReference.doc('docId');
      final void Function() onSubCollection = () => mockDocumentReference.collection('subCollection');
      final void Function() onSubCollectionDocument = () => mockSubCollectionReference.doc('subCollectionDocId');

      when(onCollection()).thenReturn(mockCollectionReference);
      when(onDocument()).thenReturn(mockDocumentReference);
      when(onSubCollection()).thenReturn(mockSubCollectionReference);
      when(onSubCollectionDocument()).thenReturn(mockSubCollectionDocumentReference);

      final bool isSuccess = await fireGenericService.deleteSubCollectionDocument(
        collection: 'collection',
        documentId: 'docId',
        subCollection: 'subCollection',
        subCollectionDocumentId: 'subCollectionDocId',
      );

      verify(onCollection()).called(1);
      verify(onDocument()).called(1);
      verify(onSubCollection()).called(1);
      verify(onSubCollectionDocument()).called(1);
      verify(mockSubCollectionDocumentReference.delete()).called(1);
      expect(isSuccess, isTrue);
    });
    test('failure', () async {
      final void Function() onCollection = () => mockFirebaseFirestore.collection('collection');
      final void Function() onDocument = () => mockCollectionReference.doc('docId');
      final void Function() onSubCollection = () => mockDocumentReference.collection('subCollection');
      final void Function() onSubCollectionDocument = () => mockSubCollectionReference.doc('subCollectionDocId');

      when(onCollection()).thenThrow(Exception('error'));

      final bool isSuccess = await fireGenericService.deleteSubCollectionDocument(
        collection: 'collection',
        documentId: 'docId',
        subCollection: 'subCollection',
        subCollectionDocumentId: 'subCollectionDocId',
      );

      verify(onCollection()).called(1);
      verifyNever(onDocument());
      verifyNever(onSubCollection());
      verifyNever(onSubCollectionDocument());
      verifyNever(mockSubCollectionDocumentReference.delete());
      expect(isSuccess, isFalse);
    });
  });

  group('getElements', () {
    group('success', () {
      test('lastDocumentSnapshot is null', () async {
        final Function() onQueryGet = () => mockQuery.get();

        when(onQueryGet()).thenAnswer((_) async => mockQuerySnapshot);
        when(mockQuerySnapshot.docs).thenReturn([mockQueryDocumentSnapshot]);

        final List<String>? elements = await fireGenericService.getElements<String>(
          query: mockQuery,
          logReference: '',
          onDocumentSnapshot: (docSnapshot) => docSnapshot.id,
        );

        verifyNever(mockQuery.startAfterDocument(any));
        verify(onQueryGet()).called(1);
        expect(elements!.length, 1);
        expect(elements.first, 'itemId');
      });
      test('lastDocumentSnapshot is not null', () async {
        final MockQuery otherMockQuery = MockQuery();
        final Function() onStartAfterDocument = () => mockQuery.startAfterDocument(mockDocumentSnapshot);

        when(onStartAfterDocument()).thenReturn(otherMockQuery);
        when(otherMockQuery.get()).thenAnswer((_) async => mockQuerySnapshot);
        when(mockQuerySnapshot.docs).thenReturn([mockQueryDocumentSnapshot]);

        final List<String>? elements = await fireGenericService.getElements<String>(
          query: mockQuery,
          logReference: '',
          onDocumentSnapshot: (docSnapshot) => docSnapshot.id,
          lastDocumentSnapshot: mockDocumentSnapshot,
        );

        verify(onStartAfterDocument()).called(1);
        verify(otherMockQuery.get()).called(1);
        expect(elements!.length, 1);
        expect(elements.first, 'itemId');
      });
    });
    test('failed', () async {
      final Function() onStartAfterDocument = () => mockQuery.startAfterDocument(mockDocumentSnapshot);
      final Function() onQueryGet = () => mockQuery.get();

      when(onStartAfterDocument()).thenReturn(mockQuery);
      when(onQueryGet()).thenThrow(Exception('error'));

      final List<String>? elements = await fireGenericService.getElements<String>(
        query: mockQuery,
        logReference: '',
        onDocumentSnapshot: (docSnapshot) => docSnapshot.id,
        lastDocumentSnapshot: mockDocumentSnapshot,
      );

      verify(onStartAfterDocument()).called(1);
      verify(onQueryGet()).called(1);
      expect(elements, isNull);
    });
  });
}
