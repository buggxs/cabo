import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';

/// Routes uncaught Flutter and platform errors to Crashlytics and drops the
/// errors that are known plugin teardown noise instead of real defects.
class CrashReporting {
  static final Logger _logger = Logger('CrashReporting');

  /// Installs the error hooks. Call once, right after Firebase is initialized.
  static void register() {
    FlutterError.onError = _handleFlutterError;
    PlatformDispatcher.instance.onError = _handlePlatformError;
  }

  static void _handleFlutterError(FlutterErrorDetails details) {
    if (_isPluginTeardownNoise(details.exception)) {
      _logger.fine('Ignored plugin teardown error: ${details.exception}');
      return;
    }
    FirebaseCrashlytics.instance.recordFlutterFatalError(details);
  }

  static bool _handlePlatformError(Object error, StackTrace stack) {
    if (_isPluginTeardownNoise(error)) {
      _logger.fine('Ignored plugin teardown error: $error');
      return true;
    }
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  }

  /// cloud_firestore removes the native stream handler of a transaction before
  /// Dart cancels its subscription, so every completed transaction reports a
  /// MissingPluginException for `cancel` on that channel. It is harmless, but
  /// Flutter surfaces it through FlutterError.onError and it would land in
  /// Crashlytics as a fatal error.
  static bool _isPluginTeardownNoise(Object error) {
    if (error is! MissingPluginException) {
      return false;
    }
    final String message = error.message ?? '';
    return message.contains('plugins.flutter.io/firebase_firestore/');
  }
}
