// Mocks generated by Mockito 5.0.17 from annotations
// in secretum/test/mocked_classes.dart.
// Do not manually edit this file.

import 'dart:async' as _i8;
import 'dart:typed_data' as _i9;

import 'package:cloud_firestore/cloud_firestore.dart' as _i2;
import 'package:firebase_core/firebase_core.dart' as _i3;
import 'package:mockito/mockito.dart' as _i1;
import 'package:secretum/models/enums/log_type.dart' as _i5;
import 'package:secretum/models/secret.dart' as _i6;
import 'package:secretum/models/users_sensitive_information.dart' as _i7;
import 'package:secretum/pages/authentication/authentication_contract.dart'
    as _i10;
import 'package:secretum/services/authentication_service.dart' as _i11;
import 'package:secretum/services/logging_service.dart' as _i4;

import 'mock_function.dart' as _i12;

// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types

class _FakeDateTime_0 extends _i1.Fake implements DateTime {}

class _FakeDocumentSnapshot_1<T extends Object?> extends _i1.Fake
    implements _i2.DocumentSnapshot<T> {}

class _FakeDocumentReference_2<T extends Object?> extends _i1.Fake
    implements _i2.DocumentReference<T> {}

class _FakeSnapshotMetadata_3 extends _i1.Fake implements _i2.SnapshotMetadata {
}

class _FakeFirebaseApp_4 extends _i1.Fake implements _i3.FirebaseApp {}

class _FakeSettings_5 extends _i1.Fake implements _i2.Settings {}

class _FakeCollectionReference_6<T extends Object?> extends _i1.Fake
    implements _i2.CollectionReference<T> {}

class _FakeWriteBatch_7 extends _i1.Fake implements _i2.WriteBatch {}

class _FakeLoadBundleTask_8 extends _i1.Fake implements _i2.LoadBundleTask {}

class _FakeQuerySnapshot_9<T extends Object?> extends _i1.Fake
    implements _i2.QuerySnapshot<T> {}

class _FakeQuery_10<T extends Object?> extends _i1.Fake
    implements _i2.Query<T> {}

class _FakeFirebaseFirestore_11 extends _i1.Fake
    implements _i2.FirebaseFirestore {}

/// A class which mocks [LoggingService].
///
/// See the documentation for Mockito's code generation for more information.
class MockLoggingService extends _i1.Mock implements _i4.LoggingService {
  MockLoggingService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  void log(String? message, {_i5.LogType? logType = _i5.LogType.debug}) => super
      .noSuchMethod(Invocation.method(#log, [message], {#logType: logType}),
          returnValueForMissingStub: null);
}

/// A class which mocks [Secret].
///
/// See the documentation for Mockito's code generation for more information.
class MockSecret extends _i1.Mock implements _i6.Secret {
  MockSecret() {
    _i1.throwOnMissingStub(this);
  }

  @override
  String get addedBy =>
      (super.noSuchMethod(Invocation.getter(#addedBy), returnValue: '')
          as String);
  @override
  DateTime get updatedAt => (super.noSuchMethod(Invocation.getter(#updatedAt),
      returnValue: _FakeDateTime_0()) as DateTime);
  @override
  set updatedAt(DateTime? _updatedAt) =>
      super.noSuchMethod(Invocation.setter(#updatedAt, _updatedAt),
          returnValueForMissingStub: null);
  @override
  String get name =>
      (super.noSuchMethod(Invocation.getter(#name), returnValue: '') as String);
  @override
  set name(String? _name) => super.noSuchMethod(Invocation.setter(#name, _name),
      returnValueForMissingStub: null);
  @override
  String get note =>
      (super.noSuchMethod(Invocation.getter(#note), returnValue: '') as String);
  @override
  set note(String? _note) => super.noSuchMethod(Invocation.setter(#note, _note),
      returnValueForMissingStub: null);
  @override
  String get code =>
      (super.noSuchMethod(Invocation.getter(#code), returnValue: '') as String);
  @override
  set code(String? _code) => super.noSuchMethod(Invocation.setter(#code, _code),
      returnValueForMissingStub: null);
  @override
  String get id =>
      (super.noSuchMethod(Invocation.getter(#id), returnValue: '') as String);
  @override
  _i2.DocumentSnapshot<Object?> get documentSnapshot =>
      (super.noSuchMethod(Invocation.getter(#documentSnapshot),
              returnValue: _FakeDocumentSnapshot_1<Object?>())
          as _i2.DocumentSnapshot<Object?>);
  @override
  set documentSnapshot(_i2.DocumentSnapshot<Object?>? _documentSnapshot) =>
      super.noSuchMethod(
          Invocation.setter(#documentSnapshot, _documentSnapshot),
          returnValueForMissingStub: null);
  @override
  set documentChangeType(_i2.DocumentChangeType? _documentChangeType) => super
      .noSuchMethod(Invocation.setter(#documentChangeType, _documentChangeType),
          returnValueForMissingStub: null);
  @override
  DateTime get createdAt => (super.noSuchMethod(Invocation.getter(#createdAt),
      returnValue: _FakeDateTime_0()) as DateTime);
  @override
  set createdAt(DateTime? _createdAt) =>
      super.noSuchMethod(Invocation.setter(#createdAt, _createdAt),
          returnValueForMissingStub: null);
  @override
  Map<String, dynamic> toJson({bool? isEncrypted = true}) => (super
      .noSuchMethod(Invocation.method(#toJson, [], {#isEncrypted: isEncrypted}),
          returnValue: <String, dynamic>{}) as Map<String, dynamic>);
}

/// A class which mocks [DocumentSnapshot].
///
/// See the documentation for Mockito's code generation for more information.
class MockDocumentSnapshot<T extends Object?> extends _i1.Mock
    implements _i2.DocumentSnapshot<T> {
  MockDocumentSnapshot() {
    _i1.throwOnMissingStub(this);
  }

  @override
  String get id =>
      (super.noSuchMethod(Invocation.getter(#id), returnValue: '') as String);
  @override
  _i2.DocumentReference<T> get reference => (super.noSuchMethod(
      Invocation.getter(#reference),
      returnValue: _FakeDocumentReference_2<T>()) as _i2.DocumentReference<T>);
  @override
  _i2.SnapshotMetadata get metadata =>
      (super.noSuchMethod(Invocation.getter(#metadata),
          returnValue: _FakeSnapshotMetadata_3()) as _i2.SnapshotMetadata);
  @override
  bool get exists =>
      (super.noSuchMethod(Invocation.getter(#exists), returnValue: false)
          as bool);
  @override
  dynamic get(Object? field) =>
      super.noSuchMethod(Invocation.method(#get, [field]));
  @override
  dynamic operator [](Object? field) =>
      super.noSuchMethod(Invocation.method(#[], [field]));
}

/// A class which mocks [DocumentChange].
///
/// See the documentation for Mockito's code generation for more information.
class MockDocumentChange<T extends Object?> extends _i1.Mock
    implements _i2.DocumentChange<T> {
  MockDocumentChange() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.DocumentChangeType get type =>
      (super.noSuchMethod(Invocation.getter(#type),
          returnValue: _i2.DocumentChangeType.added) as _i2.DocumentChangeType);
  @override
  int get oldIndex =>
      (super.noSuchMethod(Invocation.getter(#oldIndex), returnValue: 0) as int);
  @override
  int get newIndex =>
      (super.noSuchMethod(Invocation.getter(#newIndex), returnValue: 0) as int);
  @override
  _i2.DocumentSnapshot<T> get doc => (super.noSuchMethod(
      Invocation.getter(#doc),
      returnValue: _FakeDocumentSnapshot_1<T>()) as _i2.DocumentSnapshot<T>);
}

/// A class which mocks [UsersSensitiveInformation].
///
/// See the documentation for Mockito's code generation for more information.
class MockUsersSensitiveInformation extends _i1.Mock
    implements _i7.UsersSensitiveInformation {
  MockUsersSensitiveInformation() {
    _i1.throwOnMissingStub(this);
  }

  @override
  String get secretKey =>
      (super.noSuchMethod(Invocation.getter(#secretKey), returnValue: '')
          as String);
  @override
  String get primaryPassword =>
      (super.noSuchMethod(Invocation.getter(#primaryPassword), returnValue: '')
          as String);
  @override
  Map<String, dynamic> toJson({bool? isHashed = true}) =>
      (super.noSuchMethod(Invocation.method(#toJson, [], {#isHashed: isHashed}),
          returnValue: <String, dynamic>{}) as Map<String, dynamic>);
  @override
  Map<String, dynamic> getJson(Map<String, dynamic>? sensitiveDataMap,
          {bool? isHashed = true}) =>
      (super.noSuchMethod(
          Invocation.method(
              #getJson, [sensitiveDataMap], {#isHashed: isHashed}),
          returnValue: <String, dynamic>{}) as Map<String, dynamic>);
}

/// A class which mocks [FirebaseFirestore].
///
/// See the documentation for Mockito's code generation for more information.
class MockFirebaseFirestore extends _i1.Mock implements _i2.FirebaseFirestore {
  MockFirebaseFirestore() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.FirebaseApp get app => (super.noSuchMethod(Invocation.getter(#app),
      returnValue: _FakeFirebaseApp_4()) as _i3.FirebaseApp);
  @override
  set app(_i3.FirebaseApp? _app) =>
      super.noSuchMethod(Invocation.setter(#app, _app),
          returnValueForMissingStub: null);
  @override
  set settings(_i2.Settings? settings) =>
      super.noSuchMethod(Invocation.setter(#settings, settings),
          returnValueForMissingStub: null);
  @override
  _i2.Settings get settings => (super.noSuchMethod(Invocation.getter(#settings),
      returnValue: _FakeSettings_5()) as _i2.Settings);
  @override
  Map<dynamic, dynamic> get pluginConstants =>
      (super.noSuchMethod(Invocation.getter(#pluginConstants),
          returnValue: <dynamic, dynamic>{}) as Map<dynamic, dynamic>);
  @override
  _i2.CollectionReference<Map<String, dynamic>> collection(
          String? collectionPath) =>
      (super.noSuchMethod(Invocation.method(#collection, [collectionPath]),
              returnValue: _FakeCollectionReference_6<Map<String, dynamic>>())
          as _i2.CollectionReference<Map<String, dynamic>>);
  @override
  _i2.WriteBatch batch() => (super.noSuchMethod(Invocation.method(#batch, []),
      returnValue: _FakeWriteBatch_7()) as _i2.WriteBatch);
  @override
  _i8.Future<void> clearPersistence() =>
      (super.noSuchMethod(Invocation.method(#clearPersistence, []),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i8.Future<void>);
  @override
  _i8.Future<void> enablePersistence(
          [_i2.PersistenceSettings? persistenceSettings]) =>
      (super.noSuchMethod(
          Invocation.method(#enablePersistence, [persistenceSettings]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i8.Future<void>);
  @override
  _i2.LoadBundleTask loadBundle(_i9.Uint8List? bundle) =>
      (super.noSuchMethod(Invocation.method(#loadBundle, [bundle]),
          returnValue: _FakeLoadBundleTask_8()) as _i2.LoadBundleTask);
  @override
  void useFirestoreEmulator(String? host, int? port,
          {bool? sslEnabled = false}) =>
      super.noSuchMethod(
          Invocation.method(
              #useFirestoreEmulator, [host, port], {#sslEnabled: sslEnabled}),
          returnValueForMissingStub: null);
  @override
  _i8.Future<_i2.QuerySnapshot<Map<String, dynamic>>> namedQueryGet(
          String? name,
          {_i2.GetOptions? options = const _i2.GetOptions()}) =>
      (super.noSuchMethod(
          Invocation.method(#namedQueryGet, [name], {#options: options}),
          returnValue: Future<_i2.QuerySnapshot<Map<String, dynamic>>>.value(
              _FakeQuerySnapshot_9<Map<String, dynamic>>())) as _i8
          .Future<_i2.QuerySnapshot<Map<String, dynamic>>>);
  @override
  _i2.Query<Map<String, dynamic>> collectionGroup(String? collectionPath) =>
      (super.noSuchMethod(Invocation.method(#collectionGroup, [collectionPath]),
              returnValue: _FakeQuery_10<Map<String, dynamic>>())
          as _i2.Query<Map<String, dynamic>>);
  @override
  _i8.Future<void> disableNetwork() =>
      (super.noSuchMethod(Invocation.method(#disableNetwork, []),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i8.Future<void>);
  @override
  _i2.DocumentReference<Map<String, dynamic>> doc(String? documentPath) =>
      (super.noSuchMethod(Invocation.method(#doc, [documentPath]),
              returnValue: _FakeDocumentReference_2<Map<String, dynamic>>())
          as _i2.DocumentReference<Map<String, dynamic>>);
  @override
  _i8.Future<void> enableNetwork() =>
      (super.noSuchMethod(Invocation.method(#enableNetwork, []),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i8.Future<void>);
  @override
  _i8.Stream<void> snapshotsInSync() =>
      (super.noSuchMethod(Invocation.method(#snapshotsInSync, []),
          returnValue: Stream<void>.empty()) as _i8.Stream<void>);
  @override
  _i8.Future<T> runTransaction<T>(_i2.TransactionHandler<T>? transactionHandler,
          {Duration? timeout = const Duration(seconds: 30)}) =>
      (super.noSuchMethod(
          Invocation.method(
              #runTransaction, [transactionHandler], {#timeout: timeout}),
          returnValue: Future<T>.value(null)) as _i8.Future<T>);
  @override
  _i8.Future<void> terminate() =>
      (super.noSuchMethod(Invocation.method(#terminate, []),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i8.Future<void>);
  @override
  _i8.Future<void> waitForPendingWrites() =>
      (super.noSuchMethod(Invocation.method(#waitForPendingWrites, []),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i8.Future<void>);
}

/// A class which mocks [CollectionReference].
///
/// See the documentation for Mockito's code generation for more information.
// ignore: must_be_immutable
class MockCollectionReference<T extends Object?> extends _i1.Mock
    implements _i2.CollectionReference<T> {
  MockCollectionReference() {
    _i1.throwOnMissingStub(this);
  }

  @override
  String get id =>
      (super.noSuchMethod(Invocation.getter(#id), returnValue: '') as String);
  @override
  String get path =>
      (super.noSuchMethod(Invocation.getter(#path), returnValue: '') as String);
  @override
  _i2.FirebaseFirestore get firestore =>
      (super.noSuchMethod(Invocation.getter(#firestore),
          returnValue: _FakeFirebaseFirestore_11()) as _i2.FirebaseFirestore);
  @override
  Map<String, dynamic> get parameters =>
      (super.noSuchMethod(Invocation.getter(#parameters),
          returnValue: <String, dynamic>{}) as Map<String, dynamic>);
  @override
  _i8.Future<_i2.DocumentReference<T>> add(T? data) =>
      (super.noSuchMethod(Invocation.method(#add, [data]),
              returnValue: Future<_i2.DocumentReference<T>>.value(
                  _FakeDocumentReference_2<T>()))
          as _i8.Future<_i2.DocumentReference<T>>);
  @override
  _i2.DocumentReference<T> doc([String? path]) => (super.noSuchMethod(
      Invocation.method(#doc, [path]),
      returnValue: _FakeDocumentReference_2<T>()) as _i2.DocumentReference<T>);
  @override
  _i2.CollectionReference<R> withConverter<R extends Object?>(
          {_i2.FromFirestore<R>? fromFirestore,
          _i2.ToFirestore<R>? toFirestore}) =>
      (super.noSuchMethod(
              Invocation.method(#withConverter, [],
                  {#fromFirestore: fromFirestore, #toFirestore: toFirestore}),
              returnValue: _FakeCollectionReference_6<R>())
          as _i2.CollectionReference<R>);
  @override
  _i2.Query<T> endAtDocument(_i2.DocumentSnapshot<Object?>? documentSnapshot) =>
      (super.noSuchMethod(Invocation.method(#endAtDocument, [documentSnapshot]),
          returnValue: _FakeQuery_10<T>()) as _i2.Query<T>);
  @override
  _i2.Query<T> endAt(List<Object?>? values) =>
      (super.noSuchMethod(Invocation.method(#endAt, [values]),
          returnValue: _FakeQuery_10<T>()) as _i2.Query<T>);
  @override
  _i2.Query<T> endBeforeDocument(
          _i2.DocumentSnapshot<Object?>? documentSnapshot) =>
      (super.noSuchMethod(
          Invocation.method(#endBeforeDocument, [documentSnapshot]),
          returnValue: _FakeQuery_10<T>()) as _i2.Query<T>);
  @override
  _i2.Query<T> endBefore(List<Object?>? values) =>
      (super.noSuchMethod(Invocation.method(#endBefore, [values]),
          returnValue: _FakeQuery_10<T>()) as _i2.Query<T>);
  @override
  _i8.Future<_i2.QuerySnapshot<T>> get([_i2.GetOptions? options]) =>
      (super.noSuchMethod(Invocation.method(#get, [options]),
              returnValue:
                  Future<_i2.QuerySnapshot<T>>.value(_FakeQuerySnapshot_9<T>()))
          as _i8.Future<_i2.QuerySnapshot<T>>);
  @override
  _i2.Query<T> limit(int? limit) =>
      (super.noSuchMethod(Invocation.method(#limit, [limit]),
          returnValue: _FakeQuery_10<T>()) as _i2.Query<T>);
  @override
  _i2.Query<T> limitToLast(int? limit) =>
      (super.noSuchMethod(Invocation.method(#limitToLast, [limit]),
          returnValue: _FakeQuery_10<T>()) as _i2.Query<T>);
  @override
  _i8.Stream<_i2.QuerySnapshot<T>> snapshots(
          {bool? includeMetadataChanges = false}) =>
      (super.noSuchMethod(
              Invocation.method(#snapshots, [],
                  {#includeMetadataChanges: includeMetadataChanges}),
              returnValue: Stream<_i2.QuerySnapshot<T>>.empty())
          as _i8.Stream<_i2.QuerySnapshot<T>>);
  @override
  _i2.Query<T> orderBy(Object? field, {bool? descending = false}) =>
      (super.noSuchMethod(
          Invocation.method(#orderBy, [field], {#descending: descending}),
          returnValue: _FakeQuery_10<T>()) as _i2.Query<T>);
  @override
  _i2.Query<T> startAfterDocument(
          _i2.DocumentSnapshot<Object?>? documentSnapshot) =>
      (super.noSuchMethod(
          Invocation.method(#startAfterDocument, [documentSnapshot]),
          returnValue: _FakeQuery_10<T>()) as _i2.Query<T>);
  @override
  _i2.Query<T> startAfter(List<Object?>? values) =>
      (super.noSuchMethod(Invocation.method(#startAfter, [values]),
          returnValue: _FakeQuery_10<T>()) as _i2.Query<T>);
  @override
  _i2.Query<T> startAtDocument(
          _i2.DocumentSnapshot<Object?>? documentSnapshot) =>
      (super.noSuchMethod(
          Invocation.method(#startAtDocument, [documentSnapshot]),
          returnValue: _FakeQuery_10<T>()) as _i2.Query<T>);
  @override
  _i2.Query<T> startAt(List<Object?>? values) =>
      (super.noSuchMethod(Invocation.method(#startAt, [values]),
          returnValue: _FakeQuery_10<T>()) as _i2.Query<T>);
  @override
  _i2.Query<T> where(Object? field,
          {Object? isEqualTo,
          Object? isNotEqualTo,
          Object? isLessThan,
          Object? isLessThanOrEqualTo,
          Object? isGreaterThan,
          Object? isGreaterThanOrEqualTo,
          Object? arrayContains,
          List<Object?>? arrayContainsAny,
          List<Object?>? whereIn,
          List<Object?>? whereNotIn,
          bool? isNull}) =>
      (super.noSuchMethod(
          Invocation.method(#where, [
            field
          ], {
            #isEqualTo: isEqualTo,
            #isNotEqualTo: isNotEqualTo,
            #isLessThan: isLessThan,
            #isLessThanOrEqualTo: isLessThanOrEqualTo,
            #isGreaterThan: isGreaterThan,
            #isGreaterThanOrEqualTo: isGreaterThanOrEqualTo,
            #arrayContains: arrayContains,
            #arrayContainsAny: arrayContainsAny,
            #whereIn: whereIn,
            #whereNotIn: whereNotIn,
            #isNull: isNull
          }),
          returnValue: _FakeQuery_10<T>()) as _i2.Query<T>);
}

/// A class which mocks [DocumentReference].
///
/// See the documentation for Mockito's code generation for more information.
// ignore: must_be_immutable
class MockDocumentReference<T extends Object?> extends _i1.Mock
    implements _i2.DocumentReference<T> {
  MockDocumentReference() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.FirebaseFirestore get firestore =>
      (super.noSuchMethod(Invocation.getter(#firestore),
          returnValue: _FakeFirebaseFirestore_11()) as _i2.FirebaseFirestore);
  @override
  String get id =>
      (super.noSuchMethod(Invocation.getter(#id), returnValue: '') as String);
  @override
  _i2.CollectionReference<T> get parent =>
      (super.noSuchMethod(Invocation.getter(#parent),
              returnValue: _FakeCollectionReference_6<T>())
          as _i2.CollectionReference<T>);
  @override
  String get path =>
      (super.noSuchMethod(Invocation.getter(#path), returnValue: '') as String);
  @override
  _i2.CollectionReference<Map<String, dynamic>> collection(
          String? collectionPath) =>
      (super.noSuchMethod(Invocation.method(#collection, [collectionPath]),
              returnValue: _FakeCollectionReference_6<Map<String, dynamic>>())
          as _i2.CollectionReference<Map<String, dynamic>>);
  @override
  _i8.Future<void> delete() =>
      (super.noSuchMethod(Invocation.method(#delete, []),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i8.Future<void>);
  @override
  _i8.Future<void> update(Map<String, Object?>? data) =>
      (super.noSuchMethod(Invocation.method(#update, [data]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i8.Future<void>);
  @override
  _i8.Future<_i2.DocumentSnapshot<T>> get([_i2.GetOptions? options]) =>
      (super.noSuchMethod(Invocation.method(#get, [options]),
              returnValue: Future<_i2.DocumentSnapshot<T>>.value(
                  _FakeDocumentSnapshot_1<T>()))
          as _i8.Future<_i2.DocumentSnapshot<T>>);
  @override
  _i8.Stream<_i2.DocumentSnapshot<T>> snapshots(
          {bool? includeMetadataChanges = false}) =>
      (super.noSuchMethod(
              Invocation.method(#snapshots, [],
                  {#includeMetadataChanges: includeMetadataChanges}),
              returnValue: Stream<_i2.DocumentSnapshot<T>>.empty())
          as _i8.Stream<_i2.DocumentSnapshot<T>>);
  @override
  _i8.Future<void> set(T? data, [_i2.SetOptions? options]) =>
      (super.noSuchMethod(Invocation.method(#set, [data, options]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i8.Future<void>);
  @override
  _i2.DocumentReference<R> withConverter<R>(
          {_i2.FromFirestore<R>? fromFirestore,
          _i2.ToFirestore<R>? toFirestore}) =>
      (super.noSuchMethod(
              Invocation.method(#withConverter, [],
                  {#fromFirestore: fromFirestore, #toFirestore: toFirestore}),
              returnValue: _FakeDocumentReference_2<R>())
          as _i2.DocumentReference<R>);
}

/// A class which mocks [Query].
///
/// See the documentation for Mockito's code generation for more information.
// ignore: must_be_immutable
class MockQuery<T extends Object?> extends _i1.Mock implements _i2.Query<T> {
  MockQuery() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.FirebaseFirestore get firestore =>
      (super.noSuchMethod(Invocation.getter(#firestore),
          returnValue: _FakeFirebaseFirestore_11()) as _i2.FirebaseFirestore);
  @override
  Map<String, dynamic> get parameters =>
      (super.noSuchMethod(Invocation.getter(#parameters),
          returnValue: <String, dynamic>{}) as Map<String, dynamic>);
  @override
  _i2.Query<T> endAtDocument(_i2.DocumentSnapshot<Object?>? documentSnapshot) =>
      (super.noSuchMethod(Invocation.method(#endAtDocument, [documentSnapshot]),
          returnValue: _FakeQuery_10<T>()) as _i2.Query<T>);
  @override
  _i2.Query<T> endAt(List<Object?>? values) =>
      (super.noSuchMethod(Invocation.method(#endAt, [values]),
          returnValue: _FakeQuery_10<T>()) as _i2.Query<T>);
  @override
  _i2.Query<T> endBeforeDocument(
          _i2.DocumentSnapshot<Object?>? documentSnapshot) =>
      (super.noSuchMethod(
          Invocation.method(#endBeforeDocument, [documentSnapshot]),
          returnValue: _FakeQuery_10<T>()) as _i2.Query<T>);
  @override
  _i2.Query<T> endBefore(List<Object?>? values) =>
      (super.noSuchMethod(Invocation.method(#endBefore, [values]),
          returnValue: _FakeQuery_10<T>()) as _i2.Query<T>);
  @override
  _i8.Future<_i2.QuerySnapshot<T>> get([_i2.GetOptions? options]) =>
      (super.noSuchMethod(Invocation.method(#get, [options]),
              returnValue:
                  Future<_i2.QuerySnapshot<T>>.value(_FakeQuerySnapshot_9<T>()))
          as _i8.Future<_i2.QuerySnapshot<T>>);
  @override
  _i2.Query<T> limit(int? limit) =>
      (super.noSuchMethod(Invocation.method(#limit, [limit]),
          returnValue: _FakeQuery_10<T>()) as _i2.Query<T>);
  @override
  _i2.Query<T> limitToLast(int? limit) =>
      (super.noSuchMethod(Invocation.method(#limitToLast, [limit]),
          returnValue: _FakeQuery_10<T>()) as _i2.Query<T>);
  @override
  _i8.Stream<_i2.QuerySnapshot<T>> snapshots(
          {bool? includeMetadataChanges = false}) =>
      (super.noSuchMethod(
              Invocation.method(#snapshots, [],
                  {#includeMetadataChanges: includeMetadataChanges}),
              returnValue: Stream<_i2.QuerySnapshot<T>>.empty())
          as _i8.Stream<_i2.QuerySnapshot<T>>);
  @override
  _i2.Query<T> orderBy(Object? field, {bool? descending = false}) =>
      (super.noSuchMethod(
          Invocation.method(#orderBy, [field], {#descending: descending}),
          returnValue: _FakeQuery_10<T>()) as _i2.Query<T>);
  @override
  _i2.Query<T> startAfterDocument(
          _i2.DocumentSnapshot<Object?>? documentSnapshot) =>
      (super.noSuchMethod(
          Invocation.method(#startAfterDocument, [documentSnapshot]),
          returnValue: _FakeQuery_10<T>()) as _i2.Query<T>);
  @override
  _i2.Query<T> startAfter(List<Object?>? values) =>
      (super.noSuchMethod(Invocation.method(#startAfter, [values]),
          returnValue: _FakeQuery_10<T>()) as _i2.Query<T>);
  @override
  _i2.Query<T> startAtDocument(
          _i2.DocumentSnapshot<Object?>? documentSnapshot) =>
      (super.noSuchMethod(
          Invocation.method(#startAtDocument, [documentSnapshot]),
          returnValue: _FakeQuery_10<T>()) as _i2.Query<T>);
  @override
  _i2.Query<T> startAt(List<Object?>? values) =>
      (super.noSuchMethod(Invocation.method(#startAt, [values]),
          returnValue: _FakeQuery_10<T>()) as _i2.Query<T>);
  @override
  _i2.Query<T> where(Object? field,
          {Object? isEqualTo,
          Object? isNotEqualTo,
          Object? isLessThan,
          Object? isLessThanOrEqualTo,
          Object? isGreaterThan,
          Object? isGreaterThanOrEqualTo,
          Object? arrayContains,
          List<Object?>? arrayContainsAny,
          List<Object?>? whereIn,
          List<Object?>? whereNotIn,
          bool? isNull}) =>
      (super.noSuchMethod(
          Invocation.method(#where, [
            field
          ], {
            #isEqualTo: isEqualTo,
            #isNotEqualTo: isNotEqualTo,
            #isLessThan: isLessThan,
            #isLessThanOrEqualTo: isLessThanOrEqualTo,
            #isGreaterThan: isGreaterThan,
            #isGreaterThanOrEqualTo: isGreaterThanOrEqualTo,
            #arrayContains: arrayContains,
            #arrayContainsAny: arrayContainsAny,
            #whereIn: whereIn,
            #whereNotIn: whereNotIn,
            #isNull: isNull
          }),
          returnValue: _FakeQuery_10<T>()) as _i2.Query<T>);
  @override
  _i2.Query<R> withConverter<R>(
          {_i2.FromFirestore<R>? fromFirestore,
          _i2.ToFirestore<R>? toFirestore}) =>
      (super.noSuchMethod(
          Invocation.method(#withConverter, [],
              {#fromFirestore: fromFirestore, #toFirestore: toFirestore}),
          returnValue: _FakeQuery_10<R>()) as _i2.Query<R>);
}

/// A class which mocks [QuerySnapshot].
///
/// See the documentation for Mockito's code generation for more information.
class MockQuerySnapshot<T extends Object?> extends _i1.Mock
    implements _i2.QuerySnapshot<T> {
  MockQuerySnapshot() {
    _i1.throwOnMissingStub(this);
  }

  @override
  List<_i2.QueryDocumentSnapshot<T>> get docs =>
      (super.noSuchMethod(Invocation.getter(#docs),
              returnValue: <_i2.QueryDocumentSnapshot<T>>[])
          as List<_i2.QueryDocumentSnapshot<T>>);
  @override
  List<_i2.DocumentChange<T>> get docChanges => (super.noSuchMethod(
      Invocation.getter(#docChanges),
      returnValue: <_i2.DocumentChange<T>>[]) as List<_i2.DocumentChange<T>>);
  @override
  _i2.SnapshotMetadata get metadata =>
      (super.noSuchMethod(Invocation.getter(#metadata),
          returnValue: _FakeSnapshotMetadata_3()) as _i2.SnapshotMetadata);
  @override
  int get size =>
      (super.noSuchMethod(Invocation.getter(#size), returnValue: 0) as int);
}

/// A class which mocks [StreamSubscription].
///
/// See the documentation for Mockito's code generation for more information.
class MockStreamSubscription<T> extends _i1.Mock
    implements _i8.StreamSubscription<T> {
  MockStreamSubscription() {
    _i1.throwOnMissingStub(this);
  }

  @override
  bool get isPaused =>
      (super.noSuchMethod(Invocation.getter(#isPaused), returnValue: false)
          as bool);
  @override
  _i8.Future<void> cancel() =>
      (super.noSuchMethod(Invocation.method(#cancel, []),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i8.Future<void>);
  @override
  void onData(void Function(T)? handleData) =>
      super.noSuchMethod(Invocation.method(#onData, [handleData]),
          returnValueForMissingStub: null);
  @override
  void onError(Function? handleError) =>
      super.noSuchMethod(Invocation.method(#onError, [handleError]),
          returnValueForMissingStub: null);
  @override
  void onDone(void Function()? handleDone) =>
      super.noSuchMethod(Invocation.method(#onDone, [handleDone]),
          returnValueForMissingStub: null);
  @override
  void pause([_i8.Future<void>? resumeSignal]) =>
      super.noSuchMethod(Invocation.method(#pause, [resumeSignal]),
          returnValueForMissingStub: null);
  @override
  void resume() => super.noSuchMethod(Invocation.method(#resume, []),
      returnValueForMissingStub: null);
  @override
  _i8.Future<E> asFuture<E>([E? futureValue]) =>
      (super.noSuchMethod(Invocation.method(#asFuture, [futureValue]),
          returnValue: Future<E>.value(null)) as _i8.Future<E>);
}

/// A class which mocks [AuthenticationView].
///
/// See the documentation for Mockito's code generation for more information.
class MockAuthenticationView extends _i1.Mock
    implements _i10.AuthenticationView {
  MockAuthenticationView() {
    _i1.throwOnMissingStub(this);
  }

  @override
  void updateView() => super.noSuchMethod(Invocation.method(#updateView, []),
      returnValueForMissingStub: null);
  @override
  void showMessage(String? message, {bool? isSuccess}) => super.noSuchMethod(
      Invocation.method(#showMessage, [message], {#isSuccess: isSuccess}),
      returnValueForMissingStub: null);
  @override
  void closePage() => super.noSuchMethod(Invocation.method(#closePage, []),
      returnValueForMissingStub: null);
}

/// A class which mocks [AuthenticationService].
///
/// See the documentation for Mockito's code generation for more information.
class MockAuthenticationService extends _i1.Mock
    implements _i11.AuthenticationService {
  MockAuthenticationService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  bool get areBiometricsAvailable =>
      (super.noSuchMethod(Invocation.getter(#areBiometricsAvailable),
          returnValue: false) as bool);
  @override
  _i8.Future<void> init() => (super.noSuchMethod(Invocation.method(#init, []),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value()) as _i8.Future<void>);
  @override
  _i8.Future<bool> authViaBiometric({String? reason = r'Verify'}) => (super
      .noSuchMethod(Invocation.method(#authViaBiometric, [], {#reason: reason}),
          returnValue: Future<bool>.value(false)) as _i8.Future<bool>);
}

/// A class which mocks [FunctionMock].
///
/// See the documentation for Mockito's code generation for more information.
class MockFunction<T> extends _i1.Mock implements _i12.FunctionMock<T> {
  MockFunction() {
    _i1.throwOnMissingStub(this);
  }

  @override
  void call([T? object]) =>
      super.noSuchMethod(Invocation.method(#call, [object]),
          returnValueForMissingStub: null);
}
