import 'package:flutter/material.dart';

abstract class Presenter {
  Future<void> init(BuildContext context);
}

abstract class View {
  void updateView();
  void showMessage(String message, {bool isSuccess});
  void goToWelcomePage();
  void goToHomePage();
}
