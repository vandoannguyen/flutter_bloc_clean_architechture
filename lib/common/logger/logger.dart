import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

@singleton
class LogUtils {
  /// methodCount:2 , // number of method calls to be displayed
  /// errorMethodCount: 8, // number of method calls if stacktrace is provided
  /// lineLength: 120, // width of the output
  /// colors: true, // Colorful log messages
  /// printEmojis: true, // Print an emoji for each log message
  /// printTime: false, // Should each log print contain a timestamp
  static const bool showLog = kDebugMode;

  // final bool showLog = kDebugMode && kReleaseMode; //For test notification

  static final _logger = Logger(
    printer: PrettyPrinter(),
  );

  static void debugNormal(String text) {
    if (showLog) {
      // ignore: avoid_print
      print("==========================================================");
      // ignore: avoid_print
      print("Logs Debug: $text");
      // ignore: avoid_print
      print("==========================================================");
    }
  }

  static void t(String text) {
    if (showLog) _logger.t(text);
  }

  static void d(String text) {
    if (showLog) _logger.d(text);
  }

  static void i(String text) {
    if (showLog) _logger.i(text);
  }

  static void w(String text) {
    if (showLog) _logger.w(text);
  }

  static void e(String text) {
    if (showLog) _logger.e(text);
  }

  static void f(String text) {
    if (showLog) _logger.f(text);
  }
}
