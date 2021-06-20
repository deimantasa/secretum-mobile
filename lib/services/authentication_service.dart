import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:secretum/main.dart';
import 'package:secretum/models/enums/log_type.dart';

class AuthenticationService {
  /// [isBiometricAuthShowing] is introduced to tackle different Biometrics behaviour within Android and iOS devices.
  /// Android shows Fragment, and activity is not paused, while iOS pauses the app and shows Biometrics screen
  /// triggering AppLifecycleState to change. After iOS auth is success, AppLifecycleState becomes resume thus
  /// we are in the loop.
  /// Current way simply ensures that if Biometrics screen is shown, other won't be shown.
  /// It still seems to fail sometimes (on iOS), but fairly rarely.
  bool isBiometricAuthShowing = false;

  Future<bool> authViaBiometric({String reason = 'Verify'}) async {
    final LocalAuthentication localAuthentication = LocalAuthentication();
    final bool areBiometricsAvailable = await localAuthentication.canCheckBiometrics;

    // If there are no biometrics - skip this step
    if (!areBiometricsAvailable) {
      return true;
    } else {
      try {
        isBiometricAuthShowing = true;

        final bool didAuthenticate = await localAuthentication.authenticate(
          // localizedReason must be provided when running on iOS device
          // Android device doesn't complain, if there is no localizedReason.
          localizedReason: reason,
          biometricOnly: false,
        );

        isBiometricAuthShowing = false;
        return didAuthenticate;
      }
      //For now just handle it as true - only for testing
      on PlatformException catch (e) {
        isBiometricAuthShowing = false;
        loggingService.log('AuthenticationService.authViaBiometric: Exception: $e', logType: LogType.error);
        return true;
      }
    }
  }
}
