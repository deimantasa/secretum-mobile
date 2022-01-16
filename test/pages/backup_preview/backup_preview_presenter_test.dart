import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:secretum/main.dart';
import 'package:secretum/models/secret.dart';
import 'package:secretum/pages/backup_preview/backup_preview_model.dart';
import 'package:secretum/pages/backup_preview/backup_preview_presenter.dart';
import 'package:secretum/services/encryption_service.dart';
import '../../mocked_classes.mocks.dart';
import '../../test_utils.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  const kFileName = 'filename.txt';

  loggingService = MockLoggingService();
  final mockView = MockBackupPreviewView();

  late EncryptionService encryptionService;
  late BackupPreviewModel model;
  late BackupPreviewPresenter presenter;

  setUp(() {
    GetIt.instance.registerSingleton<EncryptionService>(EncryptionService());
    encryptionService = GetIt.instance<EncryptionService>();
    encryptionService.updateSecretKey(TestUtils.kEncryptionSecretKey);

    model = BackupPreviewModel(kFileName);
    presenter = BackupPreviewPresenter(mockView, model);
  });

  tearDown(() async {
    await GetIt.instance.reset();
  });

  test('init', () async {
    final secrets = [
      Secret('addedBy', DateTime(2020), 'name', 'note', 'code'),
      Secret('addedBy2', DateTime(2019), 'name2', 'note2', 'code2'),
    ];
    final file = File(kFileName);
    final secretsJson = secrets.map((e) => e.toJson()).toList();
    final secretsJsonString = json.encode(secretsJson);
    await file.writeAsString(secretsJsonString);

    await presenter.init();

    expect(model.secrets.length, 2);
    expect(model.secrets[0].toJson(), secrets[0].toJson());
    expect(model.secrets[1].toJson(), secrets[1].toJson());
    verify(mockView.updateView()).called(1);

    await file.delete();
  });

  group('copyCode', () {
    test('code is empty', () async {
      await presenter.copyCode('');

      //TODO(aurimas): verification for clipboard
      verify(mockView.showMessage('Nothing to copy, code is empty', isSuccess: false)).called(1);
      verifyNever(mockView.showMessage(any));
    });

    test('success', () async {
      await presenter.copyCode('code');

      //TODO(aurimas): verification for clipboard
      verifyNever(mockView.showMessage(any, isSuccess: false));
      verify(
        mockView.showMessage('Code was copied to clipboard. Do not forget to clear your clipboard once you will use the code'),
      ).called(1);
    });
  });

  test('clearClipboard', () async {
    await presenter.clearClipboard();

    //TODO(aurimas): verification for clipboard
    verify(mockView.showMessage('Clipboard was cleared')).called(1);
  });
}
