import 'package:secretum/models/clickable.dart';

abstract class Presenter {
  Future<void> verifyClickThrough();
  void verifyPassword(String password);
  void updateClickable(Clickable clickable);
}

abstract class View {
  void updateView();
  void showMessage(String message, {bool isSuccess});
  void showPasswordInputDialog();
  void goToHomePage();
}
