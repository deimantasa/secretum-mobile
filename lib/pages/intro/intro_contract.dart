import 'package:flutter/material.dart';

abstract class Presenter {
  Future<void> init();
  void finishInit();
}

abstract class View {
  void updateView();
  void showMessage(String message, {bool isSuccess});
  void goToWelcomePage();
  void goToAuthenticationPage();
}
