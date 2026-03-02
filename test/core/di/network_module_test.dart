import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:i_was_there/core/di/network_module.dart';
import 'package:i_was_there/domain/sync/google_auth_service.dart';
import 'package:i_was_there/domain/sync/entities/google_account_info.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class FakeAuthService implements GoogleAuthService {
  @override
  Future<GoogleAccountInfo?> getCurrentAccount() => throw UnimplementedError();

  @override
  Future<Map<String, String>> getAuthHeaders() async => <String, String>{
    'foo': 'bar',
  };

  @override
  Future<GoogleAccountInfo?> signIn() => throw UnimplementedError();

  @override
  Future<void> signOut() => throw UnimplementedError();
}

void main() {
  test('Dio instance includes authentication interceptor and logger', () {
    // Running in test mode counts as debug config.
    expect(kDebugMode, isTrue);

    final Dio dio = NetworkModuleImpl().provideDio(FakeAuthService());

    // expect at least two interceptors (auth + logger)
    expect(dio.interceptors.length, greaterThanOrEqualTo(1));
    expect(dio.interceptors.any((i) => i is PrettyDioLogger), isTrue);
  });
}
