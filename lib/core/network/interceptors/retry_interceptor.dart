import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class RetryInterceptor extends Interceptor {
  final Dio dio;
  final int maxRetries = 3;
  final Duration retryInterval = const Duration(seconds: 2);

  RetryInterceptor({required this.dio});

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final options = err.requestOptions;
    final retries = options.extra['retries'] ?? 0;

    // Check if the error is a timeout error and we haven't exceeded max retries
    if (_shouldRetry(err) && retries < maxRetries) {
      if (kDebugMode) {
        debugPrint('Retry attempt ${retries + 1} for ${options.path}');
      }
      options.extra['retries'] = retries + 1;

      // Add a delay before retrying
      await Future<void>.delayed(retryInterval);

      try {
        // Repeat the request with the updated options
        final cloneReq = await dio.request(
          options.path,
          options: Options(
            method: options.method,
            headers: options.headers,
            sendTimeout: options.sendTimeout,
            receiveTimeout: options.receiveTimeout,
            extra: options.extra,
            // Add other options as needed
          ),
          data: options.data,
          queryParameters: options.queryParameters,
        );
        return handler.resolve(cloneReq);
      } on DioException catch (e) {
        // If the retry itself fails, handle the error again (which might trigger another retry if applicable)
        return handler.next(e);
      }
    }

    // If not a retryable error or max retries exceeded, pass the error along
    return handler.next(err);
  }

  bool _shouldRetry(DioException err) {
    // Only retry on timeout errors
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout;
  }
}
