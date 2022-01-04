import 'package:flutter/services.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';
import 'package:secretum/main.dart';
import 'package:secretum/models/enums/log_type.dart';

class AuthenticationService {
  final LocalAuthentication _localAuthentication;

  AuthenticationService({LocalAuthentication? localAuthentication})
      : this._localAuthentication = localAuthentication ?? LocalAuthentication();

  bool _areBiometricsAvailable = false;

  // TODO: implement code for devices which does not have biometrics enabled
  bool get areBiometricsAvailable => _areBiometricsAvailable;

  Future<void> init() async {
    _areBiometricsAvailable = await _localAuthentication.canCheckBiometrics;
  }

  /// Launches biometrics screen to authenticate user.
  ///
  /// [reason] is the String which will be shown to user upon biometrics dialog.
  Future<bool> authViaBiometric({String reason = 'Verify'}) async {
    try {
      // Can customize each message for Android and iOS
      const IOSAuthMessages iOSAuthStrings = IOSAuthMessages();
      const AndroidAuthMessages androidAuthMessages = AndroidAuthMessages();

      final bool isSuccess = await _localAuthentication.authenticate(
        // localizedReason must be provided when running on iOS device
        // Android device doesn't complain, if there is no localizedReason.
        localizedReason: reason,
        biometricOnly: false,
        iOSAuthStrings: iOSAuthStrings,
        androidAuthStrings: androidAuthMessages,
      );

      return isSuccess;
    }
    // For now just handle it as true_only for testing.
    on PlatformException catch (e) {
      loggingService.log('AuthenticationService.authViaBiometric: PlatformException: $e', logType: LogType.error);
      return false;
    } catch (e) {
      loggingService.log('AuthenticationService.authViaBiometric: Exception: $e', logType: LogType.error);
      return false;
    }
  }
}
