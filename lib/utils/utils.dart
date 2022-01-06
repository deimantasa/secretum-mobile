import 'package:intl/intl.dart';

class Utils {
  static DateTime dateTimeFromInt(int millis) {
    return DateTime.fromMillisecondsSinceEpoch(millis);
  }

  static int dateTimeToInt(DateTime dateTime) {
    return dateTime.millisecondsSinceEpoch;
  }

  /// Custom Date Format.
  /// More references for date formats - https://www.journaldev.com/17899/java-simpledateformat-java-date-format
  static String getFormattedDate(DateTime? dateTime) {
    if (dateTime == null) {
      return '';
    } else {
      final String formattedDate = DateFormat('dd-MMM-yy HH:mm:ss').format(dateTime);
      return formattedDate;
    }
  }
}
