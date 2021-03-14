abstract class Presenter {
  bool validatePrimaryPassword(String? password);
  bool validateSecondaryPassword(String? password);
}

abstract class View {
  void updateView();
  void showMessage(String message, {bool isSuccess});
}
