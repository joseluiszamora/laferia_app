import 'dart:developer' as developer;

enum LogLevel { debug, info, warning, error }

class Logger {
  static LogLevel level = LogLevel.info;

  final String? tag;

  Logger([this.tag]);

  void debug(String message, [Object? error, StackTrace? stackTrace]) {
    if (level.index <= LogLevel.debug.index) {
      _log('DEBUG', message, error, stackTrace);
    }
  }

  void info(String message, [Object? error, StackTrace? stackTrace]) {
    if (level.index <= LogLevel.info.index) {
      _log('INFO', message, error, stackTrace);
    }
  }

  void warning(String message, [Object? error, StackTrace? stackTrace]) {
    if (level.index <= LogLevel.warning.index) {
      _log('WARNING', message, error, stackTrace);
    }
  }

  void error(String message, [Object? error, StackTrace? stackTrace]) {
    if (level.index <= LogLevel.error.index) {
      _log('ERROR', message, error, stackTrace);
    }
  }

  void _log(
    String levelName,
    String message,
    Object? error,
    StackTrace? stackTrace,
  ) {
    final tagStr = tag != null ? '[$tag] ' : '';
    final errorStr = error != null ? ' | Error: $error' : '';
    final fullMessage = '$tagStr$message$errorStr';

    developer.log(
      fullMessage,
      name: 'LaFeria',
      level: _getLogLevel(levelName),
      error: error,
      stackTrace: stackTrace,
    );
  }

  int _getLogLevel(String levelName) {
    switch (levelName) {
      case 'DEBUG':
        return 500;
      case 'INFO':
        return 800;
      case 'WARNING':
        return 900;
      case 'ERROR':
        return 1000;
      default:
        return 800;
    }
  }
}
