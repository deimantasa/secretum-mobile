import 'package:flutter/foundation.dart';
import 'package:secretum/models/log_type.dart';
import 'package:logger/logger.dart';

class LoggingService {
  final Logger _logger;

  LoggingService({Logger? logger}) : this._logger = logger ?? Logger(printer: PrettyPrinter(methodCount: 2));

  void log(String message, {LogType logType = LogType.debug}) {
    if (!kReleaseMode) {
      switch (logType) {
        case LogType.debug:
          _logger.d(message);
          break;
        case LogType.warning:
          _logger.w(message);
          break;
        case LogType.error:
          _logger.e(message);
          break;
      }
    }
  }
}
