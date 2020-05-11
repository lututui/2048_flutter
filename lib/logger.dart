import 'package:flutter/foundation.dart';

class Logger {
  Logger._();

  static final Map<Type, bool> _blackList = {};

  static void blacklist(Type t) {
    _blackList[t] = true;
  }

  static void blacklistAll(Iterable<Type> types) {
    for (final type in types) {
      blacklist(type);
    }
  }

  static void log<T>(String message, {Object instance}) {
    if (!kDebugMode) return;
    if (_blackList[T] ?? false) return;

    if (instance != null) {
      debugPrint('[$T] [0x${instance.hashCode.toRadixString(16)}] $message');
      return;
    }

    debugPrint('[$T] $message');
  }
}
