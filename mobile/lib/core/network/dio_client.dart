import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../errors/api_exception.dart';

const _baseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://localhost:8000',
);

Dio buildDioClient() {
  final dio = Dio(
    BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 10),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  );

  if (kDebugMode) {
    dio.interceptors.add(_LoggingInterceptor());
  }

  dio.interceptors.add(_ErrorInterceptor());

  return dio;
}

// ---------------------------------------------------------------------------
// Logging interceptor (debug only)
// ---------------------------------------------------------------------------

class _LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint('[DIO →] ${options.method} ${options.uri}');
    if (options.data != null) debugPrint('   body: ${options.data}');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint(
      '[DIO ←] ${response.statusCode} ${response.requestOptions.uri}',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    debugPrint(
      '[DIO ✗] ${err.response?.statusCode} ${err.requestOptions.uri} — ${err.message}',
    );
    handler.next(err);
  }
}

// ---------------------------------------------------------------------------
// Error interceptor — maps HTTP status codes to typed exceptions
// ---------------------------------------------------------------------------

class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final response = err.response;

    if (response == null) {
      // Network / timeout errors — pass through as-is
      handler.next(err);
      return;
    }

    final statusCode = response.statusCode ?? 0;
    final body = response.data;
    final message = _extractMessage(body);

    final exception = switch (statusCode) {
      400 => BadRequestException(message: message),
      404 => NotFoundException(message: message),
      422 => ValidationException(
          message: message,
          errors: _extractErrors(body),
        ),
      _ => ApiException(message: message, statusCode: statusCode),
    };

    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: response,
        error: exception,
        type: err.type,
      ),
    );
  }

  String _extractMessage(dynamic body) {
    if (body is Map<String, dynamic>) {
      return (body['message'] as String?) ??
          (body['error'] as String?) ??
          'Unknown error';
    }
    return body?.toString() ?? 'Unknown error';
  }

  Map<String, List<String>> _extractErrors(dynamic body) {
    if (body is! Map<String, dynamic>) return {};
    final raw = body['errors'];
    if (raw is! Map<String, dynamic>) return {};

    return raw.map((field, value) {
      final messages = switch (value) {
        List list => list.map((e) => e.toString()).toList(),
        String s => [s],
        _ => <String>[],
      };
      return MapEntry(field, messages);
    });
  }
}
