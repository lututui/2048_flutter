import 'package:flutter/foundation.dart';

/// Static class for standardizing console logging
class Logger {
  Logger._();

  /// Writes a message to console
  static void log<T>(String message, {Object instance}) {
    if (!kDebugMode) return;

    if (instance != null) {
      debugPrint('[$T] [0x${instance.hashCode.toRadixString(16)}] $message');
      return;
    }

    debugPrint('[$T] $message');
  }
}
