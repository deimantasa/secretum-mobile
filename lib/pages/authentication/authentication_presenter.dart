import 'package:get_it/get_it.dart';
import 'package:secretum/services/authentication_service.dart';

import 'authentication_contract.dart';
import 'authentication_model.dart';

class AuthenticationPresenter {
  final AuthenticationView _view;
  // ignore: unused_field
  final AuthenticationModel _model;
  final AuthenticationService _authenticationService;

  AuthenticationPresenter(this._view, this._model) : this._authenticationService = GetIt.instance<AuthenticationService>();

  Future<void> authenticate() async {
    final bool isSuccess = await _authenticationService.authViaBiometric();

    if (isSuccess) {
      _view.closePage();
    }
  }
}
