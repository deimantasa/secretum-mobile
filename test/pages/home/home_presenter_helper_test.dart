import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:secretum/models/secret.dart';
import 'package:secretum/models/user.dart';
import 'package:secretum/models/users_sensitive_information.dart';
import 'package:secretum/pages/home/home_presenter.dart';

import '../../mocked_classes.mocks.dart';

void main() {
  final homePresenterHelper = HomePresenterHelper();

  test('exportSecretsLocally', () async {
    final dateTime = DateTime(2020);

    await withClock(Clock.fixed(dateTime), () async {
      final mockStorageService = MockStorageService();
      final mockSecretsStore = MockSecretsStore();
      final mockUsersStore = MockUsersStore();

      final secrets = [
        Secret('addedBy', DateTime(2020), 'name', 'note', 'code'),
        Secret('addedBy2', DateTime(2019), 'name2', 'note2', 'code2'),
      ];
      when(mockSecretsStore.getAllSecrets('userId')).thenAnswer((_) async => secrets);
      final mockDocumentSnapshot = MockDocumentSnapshot();
      when(mockDocumentSnapshot.id).thenReturn('userId');
      final user = User.newUser(UsersSensitiveInformation.test())..documentSnapshot = mockDocumentSnapshot;
      when(mockUsersStore.user).thenReturn(user);
      when(mockStorageService.exportBackup(secrets, 'secretum-backup-2020-01-01T00:00:00.000')).thenAnswer((_) async => 'path');

      final result = await homePresenterHelper.exportSecretsLocally(user, mockSecretsStore, mockStorageService);

      expect(result, 'path');
    });
  });
}
