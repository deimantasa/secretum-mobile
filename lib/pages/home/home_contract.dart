import 'package:secretum/models/enums/export_from_type.dart';

abstract class Presenter {
  void init();
  void updateData();
  void addNewSecret(String walletsName);
  bool isPasswordMatch(String password);
  void signOut();
  Future<void> exportSecrets(ExportFromType exportFromType, String fileName);
  Future<void> saveDbLocally();
}

abstract class View {
  void updateView();
  void showMessage(String message, {bool isSuccess});
  void goToWelcomePage();
  void showMessageDialog(String fileLocation);
}
