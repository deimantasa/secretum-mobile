abstract class Presenter {
  bool validatePrimaryPassword(String? password);
  bool validateSecondaryPassword(String? password);
  Future<bool> authenticate();
}

abstract class View {
  void updateView();
  void showMessage(String message, {bool isSuccess});
}
