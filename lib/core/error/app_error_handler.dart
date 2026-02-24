import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// User-facing message for uncaught errors when a generic message is shown.
const String kGenericErrorMessage =
    'Something went wrong. Please try again.';

/// Maps known exception types to short user-facing messages.
/// Returns [kGenericErrorMessage] for unknown exceptions.
String exceptionToUserMessage(Object error, StackTrace? stackTrace) {
  final message = error.toString().toLowerCase();
  if (message.contains('socket') ||
      message.contains('connection') ||
      message.contains('network') ||
      message.contains('timeout')) {
    return 'Connection issue. Check your network and try again.';
  }
  if (message.contains('permission') || message.contains('denied')) {
    return 'Permission is needed to complete this action.';
  }
  if (message.contains('not found') || message.contains('404')) {
    return 'The requested item was not found.';
  }
  return kGenericErrorMessage;
}

/// Sets up app-wide error handling: Flutter framework errors, zone async errors,
/// and a custom [ErrorWidget.builder] for build-time errors.
///
/// [scaffoldMessengerKey] is optional. When provided and the key has a
/// [ScaffoldMessengerState], uncaught errors are surfaced as a SnackBar
/// in addition to being logged.
void setupGlobalErrorHandling([
  GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey,
]) {
  void onError(Object error, StackTrace? stackTrace) {
    final userMessage = exceptionToUserMessage(error, stackTrace);
    if (kDebugMode) {
      debugPrint('Uncaught error: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
    final messenger = scaffoldMessengerKey?.currentState;
    if (messenger != null && messenger.mounted) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(userMessage),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  FlutterError.onError = (FlutterErrorDetails details) {
    if (kDebugMode) {
      FlutterError.dumpErrorToConsole(details);
    }
    onError(details.exception, details.stack);
  };

  PlatformDispatcher.instance.onError = (error, stackTrace) {
    onError(error, stackTrace);
    return true;
  };

  ErrorWidget.builder = (FlutterErrorDetails details) {
    final userMessage = kDebugMode
        ? (details.exception.toString())
        : exceptionToUserMessage(details.exception, details.stack);
    return Material(
      child: Container(
        color: Colors.grey.shade200,
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Text(
            userMessage,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black87, fontSize: 14),
          ),
        ),
      ),
    );
  };
}
