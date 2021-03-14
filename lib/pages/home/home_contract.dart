abstract class Presenter {
  void init();
  void updateData();
  void addNewSecret(String walletsName);
  bool isPasswordMatch(String password);
  void signOut();
  Future<void> exportSecrets(String fileName);
}

abstract class View {
  void updateView();
  void showMessage(String message, {bool isSuccess});
  void goToWelcomePage();
  void showMessageDialog(String fileLocation);
}
