import 'dart:io';

import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:secretum/main.dart';

class Utils {
  static Future<bool> authViaBiometric({String reason = "Verify"}) async {
    isBiometricAuthShowing = true;
    final LocalAuthentication localAuthentication = LocalAuthentication();

    bool didAuthenticate = await localAuthentication.authenticate(
      //localizedReason must be provided when running on iOS device
      //Android device doesn't complain, if there is no localizedReason.
      localizedReason: reason,
      biometricOnly: true,
      // stickyAuth: true,
    );

    isBiometricAuthShowing = false;
    return didAuthenticate;
  }

  ///[SystemNavigator.pop] doesn't work on iOS, therefore quit the app hard way.
  static void closeApp() {
    if (Platform.isIOS) {
      exit(0);
    } else {
      SystemNavigator.pop();
    }
  }
}
