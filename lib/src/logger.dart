final class Logger {
  static const String _debug = '\x1B[35m';
  static const String _ok = '\x1B[32m';
  static const String _error = '\x1B[31m';
  static const String _reset = '\x1B[0m';

  static void debug(String message) {
    print('$_debug$message$_reset');
  }

  static void success(String message) {
    print('$_ok$message$_reset');
  }

  static void error(String message) {
    print('$_error$message$_reset');
  }

  const Logger._();
}
