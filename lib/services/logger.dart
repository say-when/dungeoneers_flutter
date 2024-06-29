import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

void debugLog(String message, {Object? error, StackTrace? stackTrace}) {
  if (!kReleaseMode) {
    developer.log(
      message,
      name: 'com.fanfare.recode1',
      error: error,
      stackTrace: stackTrace,
    );
  }
}

void log(String message, {Object? error, StackTrace? stackTrace}) {
  developer.log(
    message,
    level: 0,
    name: 'com.fanfare.recode1',
    error: error,
    stackTrace: stackTrace,
  );
}
