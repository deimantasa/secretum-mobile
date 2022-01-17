import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:secretum/main.dart';
import 'package:secretum/models/user.dart';
import 'package:secretum/pages/edit_entry/edit_entry_model.dart';
import 'package:secretum/pages/edit_entry/edit_entry_presenter.dart';
import 'package:secretum/services/encryption_service.dart';
import 'package:secretum/stores/users_store.dart';
import '../../mocked_classes.mocks.dart';

void main() {
  loggingService = MockLoggingService();

  final mockView = MockEditEntryView();
  final mockEncryptionService = MockEncryptionService();
  final mockUsersStore = MockUsersStore();
  final mockUsersSensitiveInformation = MockUsersSensitiveInformation();

  late EditEntryModel model;
  late EditEntryPresenter presenter;

  setUp(() {
    GetIt.instance.registerSingleton<EncryptionService>(mockEncryptionService);
    GetIt.instance.registerSingleton<UsersStore>(mockUsersStore);

    model = EditEntryModel(
      'title',
      'description',
      'hintText',
      'entry',
      'buttonText',
      TextCapitalization.none,
      true,
      false,
    );
    presenter = EditEntryPresenter(mockView, model);
  });

  tearDown(() async {
    await GetIt.instance.reset();

    reset(mockUsersSensitiveInformation);
    reset(mockUsersStore);
  });

  group('validatePrimaryPassword', () {
    test('password is null', () {
      final result = presenter.validatePrimaryPassword(null);

      expect(result, isFalse);
    });

    test('success', () {
      final user = User(mockUsersSensitiveInformation);
      when(mockUsersSensitiveInformation.primaryPassword).thenReturn('primary');
      when(mockUsersStore.user).thenReturn(user);
      when(mockEncryptionService.getHashedText('password')).thenReturn('primary');

      final result = presenter.validatePrimaryPassword('password');

      expect(result, isTrue);
    });

    test('false', () {
      final user = User(mockUsersSensitiveInformation);
      when(mockUsersSensitiveInformation.primaryPassword).thenReturn('primary');
      when(mockUsersStore.user).thenReturn(user);
      when(mockEncryptionService.getHashedText('password')).thenReturn('not primary');

      final result = presenter.validatePrimaryPassword('password');

      expect(result, isFalse);
    });
  });
}
