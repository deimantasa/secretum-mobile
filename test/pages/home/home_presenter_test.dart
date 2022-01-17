import 'dart:io';

import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:secretum/main.dart';
import 'package:secretum/models/enums/export_from_type.dart';
import 'package:secretum/models/secret.dart';
import 'package:secretum/models/user.dart';
import 'package:secretum/models/users_sensitive_information.dart';
import 'package:secretum/pages/home/home_model.dart';
import 'package:secretum/pages/home/home_presenter.dart';
import 'package:secretum/services/storage_service.dart';
import 'package:secretum/stores/secrets_store.dart';
import 'package:secretum/stores/users_store.dart';
import '../../mocked_classes.mocks.dart';

void main() {
  loggingService = MockLoggingService();

  final mockView = MockHomeView();
  final mockHomePresenterHelper = MockHomePresenterHelper();
  final mockStorageService = MockStorageService();
  final mockSecretsStore = MockSecretsStore();
  final mockUsersStore = MockUsersStore();

  late HomeModel model;
  late HomePresenter presenter;

  setUp(() {
    GetIt.instance.registerSingleton<StorageService>(mockStorageService);
    GetIt.instance.registerSingleton<SecretsStore>(mockSecretsStore);
    GetIt.instance.registerSingleton<UsersStore>(mockUsersStore);

    model = HomeModel();
    presenter = HomePresenter(mockView, model, helper: mockHomePresenterHelper);
  });

  tearDown(() async {
    await GetIt.instance.reset();

    reset(mockHomePresenterHelper);
    reset(mockStorageService);
    reset(mockSecretsStore);
    reset(mockUsersStore);
  });

  test('init', () async {
    final secrets = [
      Secret('addedBy', DateTime(2020), 'name', 'note', 'code'),
      Secret('addedBy2', DateTime(2019), 'name2', 'note2', 'code2'),
    ];
    when(mockSecretsStore.secrets).thenReturn(secrets);
    final user = User.newUser(UsersSensitiveInformation.test());
    when(mockUsersStore.user).thenReturn(user);
    when(mockHomePresenterHelper.exportSecretsLocally(user, mockSecretsStore, mockStorageService))
        .thenAnswer((_) async => 'path');

    presenter.init();
    await Future.delayed(Duration(milliseconds: 100));

    verify(mockHomePresenterHelper.exportSecretsLocally(user, mockSecretsStore, mockStorageService)).called(1);
    expect(model.user, user);
    expect(model.secrets, secrets);
    verify(mockView.updateView()).called(2);
  });

  test('updateData', () {
    final secrets = [
      Secret('addedBy', DateTime(2020), 'name', 'note', 'code'),
      Secret('addedBy2', DateTime(2019), 'name2', 'note2', 'code2'),
    ];
    when(mockSecretsStore.secrets).thenReturn(secrets);
    final user = User.newUser(UsersSensitiveInformation.test());
    when(mockUsersStore.user).thenReturn(user);

    presenter.updateData();

    expect(model.user, user);
    expect(model.secrets, secrets);
    verify(mockView.updateView()).called(1);
  });

  test('signOut', () {
    presenter.signOut();

    verify(mockUsersStore.resetStore()).called(1);
    verify(mockSecretsStore.resetStore()).called(1);
    verify(mockStorageService.resetStorage()).called(1);
    verify(mockView.goToWelcomePage()).called(1);
  });

  group('addNewSecret', () {
    test('failed', () async {
      final dateTime = DateTime(2020);
      await withClock(Clock.fixed(dateTime), () async {
        final mockDocumentSnapshot = MockDocumentSnapshot();
        when(mockDocumentSnapshot.id).thenReturn('userId');
        final user = User.newUser(UsersSensitiveInformation.test())..documentSnapshot = mockDocumentSnapshot;
        model.user = user;
        when(mockSecretsStore.addNewSecret('userId', any)).thenAnswer((_) async => false);

        await presenter.addNewSecret('secretName');

        expect(model.loadingState.isLoading, isFalse);
        final secret = verify(mockSecretsStore.addNewSecret('userId', captureAny)).captured.single as Secret;
        expect(secret.toJson(isEncrypted: false), {
          'createdAt': '2020-01-01T00:00:00.000',
          'addedBy': 'userId',
          'updatedAt': '2020-01-01T00:00:00.000',
          'name': 'secretName',
          'note': '',
          'code': ''
        });
        verify(mockView.showMessage('Cannot add secretName, something went wrong', isSuccess: false)).called(1);
      });
    });

    test('success', () async {
      final dateTime = DateTime(2020);
      await withClock(Clock.fixed(dateTime), () async {
        final mockDocumentSnapshot = MockDocumentSnapshot();
        when(mockDocumentSnapshot.id).thenReturn('userId');
        final user = User.newUser(UsersSensitiveInformation.test())..documentSnapshot = mockDocumentSnapshot;
        model.user = user;
        when(mockSecretsStore.addNewSecret('userId', any)).thenAnswer((_) async => true);

        await presenter.addNewSecret('secretName');

        expect(model.loadingState.isLoading, isFalse);
        final secret = verify(mockSecretsStore.addNewSecret('userId', captureAny)).captured.single as Secret;
        expect(secret.toJson(isEncrypted: false), {
          'createdAt': '2020-01-01T00:00:00.000',
          'addedBy': 'userId',
          'updatedAt': '2020-01-01T00:00:00.000',
          'name': 'secretName',
          'note': '',
          'code': ''
        });
        verify(mockView.showMessage('secretName added')).called(1);
      });
    });
  });

  group('exportSecrets', () {
    group('filename is empty', () {
      void executeTest(ExportFromType exportFromType) {
        test('$exportFromType', () async {
          await presenter.exportSecrets(exportFromType, '');

          verify(mockView.showMessage('File name cannot be empty', isSuccess: false));
          verifyNever(mockStorageService.exportBackup(any, any));
        });
      }

      ExportFromType.values.forEach((exportFromType) {
        executeTest(exportFromType);
      });
    });

    test('database', () async {
      final secrets = [
        Secret('addedBy', DateTime(2020), 'name', 'note', 'code'),
        Secret('addedBy2', DateTime(2019), 'name2', 'note2', 'code2'),
      ];
      model.secrets = secrets;
      when(mockStorageService.exportBackup(secrets, 'filename')).thenAnswer((_) async => 'path');

      await presenter.exportSecrets(ExportFromType.database, 'filename');

      verifyNever(mockView.showMessage(any, isSuccess: false));
      verify(mockView.showMessageDialog('path')).called(1);
    });

    test('unknown', () async {
      final secrets = [
        Secret('addedBy', DateTime(2020), 'name', 'note', 'code'),
        Secret('addedBy2', DateTime(2019), 'name2', 'note2', 'code2'),
      ];
      model.secrets = secrets;
      when(mockStorageService.exportBackup(secrets, 'filename')).thenAnswer((_) async => 'path');

      await presenter.exportSecrets(ExportFromType.unknown, 'filename');

      verifyNever(mockView.showMessage(any, isSuccess: false));
      verify(mockView.showMessageDialog('null')).called(1);
    });
  });

  group('deleteBackups', () {
    test('failed', () async {
      when(mockStorageService.deleteBackupFiles()).thenAnswer((_) async => false);

      await presenter.deleteBackups();

      verify(mockStorageService.deleteBackupFiles()).called(1);
      verify(mockView.showMessage('Cannot delete backups, something went wrong', isSuccess: false)).called(1);
    });

    test('success', () async {
      when(mockStorageService.deleteBackupFiles()).thenAnswer((_) async => true);

      await presenter.deleteBackups();

      verify(mockStorageService.deleteBackupFiles()).called(1);
      verify(mockView.showMessage('Backups were deleted')).called(1);
    });
  });

  test('getBackupsDirectory', () async {
    final directory = Directory('path');
    when(mockStorageService.getBackupsDirectory()).thenAnswer((_) async => directory);

    final result = await presenter.getBackupsDirectory();

    expect(result, directory);
  });
}
