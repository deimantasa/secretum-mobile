import 'package:secretum/models/secret.dart';

abstract class Presenter {
  void init();
  void dispose();
  Future<void> updateSecret(Secret secret);
  void deleteSecret(String primaryPassword);
}

abstract class View {
  void updateView();
  void showMessage(String message, {bool isSuccess});
  void closePage();
}
