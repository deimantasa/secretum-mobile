import 'package:local_auth/local_auth.dart';

class Utils {
  static Future<bool> authViaBiometric(String reason) async {
    final LocalAuthentication localAuthentication = LocalAuthentication();
    bool didAuthenticate = await localAuthentication.authenticate(
      localizedReason: reason,
      biometricOnly: true,
    );

    return didAuthenticate;
  }
}
