import 'package:flutter/foundation.dart';

class Logger {
  static final Map<Type, bool> _blackList = Map();

  static bool enabled = true;

  Logger._();

  static void blacklist(Type t) {
    _blackList[t] = true;
  }

  static void blacklistAll(Iterable<Type> t) {
    t.forEach((element) => blacklist(element));
  }

  static void log<T>(String message, {Object instance}) {
    if (!kDebugMode) return;
    if (!enabled) return;
    if (_blackList[T] ?? false) return;

    if (instance != null) {
      print("[$T] [$instance] $message");
      return;
    }

    print("[$T] $message");
  }
}
