import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:secretum/pages/authentication/authentication_model.dart';
import 'package:secretum/pages/authentication/authentication_presenter.dart';
import 'package:secretum/services/authentication_service.dart';
import '../../mocked_classes.mocks.dart';

void main() {
  final mockView = MockAuthenticationView();
  final mockAuthenticationService = MockAuthenticationService();

  late AuthenticationModel model;
  late AuthenticationPresenter presenter;

  setUp(() {
    GetIt.instance.registerSingleton<AuthenticationService>(mockAuthenticationService);

    model = AuthenticationModel();
    presenter = AuthenticationPresenter(mockView, model);
  });

  tearDown(() async {
    await GetIt.instance.reset();
  });

  group('authenticate', () {
    test('failed', () async {
      when(mockAuthenticationService.authViaBiometric()).thenAnswer((_) async => false);

      await presenter.authenticate();

      verify(mockAuthenticationService.authViaBiometric()).called(1);
      verifyNever(mockView.closePage());
    });

    test('success', () async {
      when(mockAuthenticationService.authViaBiometric()).thenAnswer((_) async => true);

      await presenter.authenticate();

      verify(mockAuthenticationService.authViaBiometric()).called(1);
      verify(mockView.closePage()).called(1);
    });
  });
}
