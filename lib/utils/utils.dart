import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:local_auth/local_auth.dart';
import 'package:secretum/main.dart';

class Utils {
  static Future<bool> authViaBiometric({String reason = "Verify"}) async {
    return true;
    final LocalAuthentication localAuthentication = LocalAuthentication();
    bool areBiometricsAvailable = await localAuthentication.canCheckBiometrics;

    //If there are no biometrics - skip this step
    if (!areBiometricsAvailable) {
      return true;
    } else {
      try {
        isBiometricAuthShowing = true;

        bool didAuthenticate = await localAuthentication.authenticate(
          //localizedReason must be provided when running on iOS device
          //Android device doesn't complain, if there is no localizedReason.
          localizedReason: reason,
          biometricOnly: false,
        );

        isBiometricAuthShowing = false;
        return didAuthenticate;
      }
      //For now just handle it as true - only for testing
      on PlatformException catch (e) {
        isBiometricAuthShowing = false;
        return true;
      }
    }
  }

  ///[SystemNavigator.pop] doesn't work on iOS, therefore quit the app hard way.
  static void closeApp() {
    if (Platform.isIOS) {
      exit(0);
    } else {
      SystemNavigator.pop();
    }
  }

  // https://stackoverflow.com/questions/56627888/how-to-print-firestore-timestamp-as-formatted-date-and-time-in-flutter
  /// When we use firestore, we receive [Timestamp] object which we can parse to [DateTime] directly.
  static DateTime? dateTimeFromTimestamp(Timestamp? timestamp) {
    if (timestamp != null) {
      return DateTime.parse(timestamp.toDate().toString());
    } else {
      return null;
    }
  }

  ///Reverse of [dateTimeFromTimestamp]
  static Timestamp? dateTimeToTimestamp(DateTime? dateTime) {
    if (dateTime != null) {
      return Timestamp.fromDate(dateTime);
    } else {
      return null;
    }
  }

  ///Custom Date Format.
  ///More references for date formats - https://www.journaldev.com/17899/java-simpledateformat-java-date-format
  static String getFormattedDate(DateTime? dateTime) {
    if (dateTime == null) {
      return "";
    } else {
      String formattedDate = DateFormat("dd-MMM-yy HH:mm:ss").format(dateTime);
      return formattedDate;
    }
  }
}
