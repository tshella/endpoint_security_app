import 'dart:developer' as developer;

class LoggingHelper {
  static void log(String message, {String tag = 'APP'}) {
    final timestamp = DateTime.now().toIso8601String();
    developer.log('[$timestamp] [$tag] $message');
  }

  static void logError(String message, {String tag = 'ERROR'}) {
    final timestamp = DateTime.now().toIso8601String();
    developer.log('[$timestamp] [$tag] $message', level: 1000);
  }
}
