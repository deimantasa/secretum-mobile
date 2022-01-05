import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Utils {
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
      return '';
    } else {
      final String formattedDate = DateFormat('dd-MMM-yy HH:mm:ss').format(dateTime);
      return formattedDate;
    }
  }
}
