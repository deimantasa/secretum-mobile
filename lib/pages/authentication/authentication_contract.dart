abstract class Presenter {
  Future<void> authenticate();
}

abstract class View {
  void updateView();
  void showMessage(String message, {bool isSuccess});
  void closePage();
}
