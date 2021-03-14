abstract class Presenter {}

abstract class View {
  void updateView();
  void showMessage(String message, {bool isSuccess});
  void goToHomePage();
}
