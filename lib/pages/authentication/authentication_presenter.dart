import 'package:get_it/get_it.dart';
import 'package:secretum/services/authentication_service.dart';

import 'authentication_contract.dart';
import 'authentication_model.dart';

class AuthenticationPresenter implements Presenter {
  final View _view;
  // ignore: unused_field
  final AuthenticationModel _authenticationModel;
  final AuthenticationService _authenticationService;

  AuthenticationPresenter(
    this._view,
    this._authenticationModel, {
    AuthenticationService? authenticationService,
  }) : this._authenticationService = authenticationService ?? GetIt.instance<AuthenticationService>();

  @override
  Future<void> authenticate() async {
    final bool isSuccess = await _authenticationService.authViaBiometric();

    if (isSuccess) {
      _view.closePage();
    }
  }
}
