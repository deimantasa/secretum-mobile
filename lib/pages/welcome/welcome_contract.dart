abstract class Presenter {
  Future<void> confirmSecretKey(String secretKey);
}

abstract class View {
  void updateView();
  void showMessage(String message, {bool isSuccess});
  void goToHomePage();
}
