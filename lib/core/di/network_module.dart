import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../core/logging.dart';
import '../../domain/sync/google_auth_service.dart';

/// Injectable module that provides a ready-to-use [Dio] instance for the
/// entire application. The client is pre‑configured with timeouts, an
/// authentication interceptor (which pulls headers from
/// [GoogleAuthService]) and, in debug builds, the
/// [PrettyDioLogger] interceptor which prints nicely formatted network
/// traffic to the console.
@module
abstract class NetworkModule {
  /// Provides a [Dio] instance.  No manual instantiation of the module is
  /// necessary when using dependency injection; however, in background
  /// isolates or unit tests the DI container may not be available.  In those
  /// cases use [NetworkModuleImpl] directly.

  @lazySingleton
  Dio provideDio(GoogleAuthService authService) {
    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        // A baseUrl is not specified because callers use full URLs. If a
        // shared base is added later it can go here.
      ),
    );

    // Interceptor that attaches authentication headers obtained from the
    // Google sign‑in service.  It is intentionally inserted first so that
    // other interceptors (including the logger) see the headers.
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest:
            (RequestOptions options, RequestInterceptorHandler handler) async {
              try {
                appLogger.d('NetworkInterceptor: Fetching auth headers...');
                final headers = await authService.getAuthHeaders();
                appLogger.d(
                  'NetworkInterceptor: Adding ${headers.length} headers',
                );
                options.headers.addAll(headers);
              } catch (e, st) {
                appLogger.w(
                  'NetworkInterceptor: Failed to add auth headers',
                  error: e,
                  stackTrace: st,
                );
                // Swallow; the request may still succeed if auth is not required.
              }
              handler.next(options);
            },
      ),
    );

    if (kDebugMode) {
      // PrettyDioLogger is added only in debug builds so that release
      // output remains clean.  Fields are enabled to provide rich
      // information for troubleshooting network issues.
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          compact: true,
        ),
      );
    }

    return dio;
  }
}

/// Simple concrete implementation used when dependency injection isn't
/// available. It inherits the behavior defined on [NetworkModule] without
/// modification.
class NetworkModuleImpl extends NetworkModule {}
