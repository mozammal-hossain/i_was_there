import 'package:logger/logger.dart';

/// Application-wide logger instance.
///
/// The `Logger` package is lightweight and flexible; it can be replaced or
/// configured differently for web, tests, etc. We use a global instance so
/// that any part of the codebase can simply `import 'core/logging.dart'` and
/// log without worrying about initialization.
final Logger appLogger = Logger(
  printer: PrettyPrinter(
    methodCount: 0, // don't print method names by default
    errorMethodCount: 5,
    lineLength: 80,
    colors: true,
    printEmojis: true,
  ),
);
