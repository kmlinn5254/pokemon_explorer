import 'dart:convert';
import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class LoggingInterceptor extends Interceptor {
  final bool logRequest;
  final bool logResponse;
  final bool logError;
  final bool logHeaders;
  final bool logBody;
  final bool compactJson;
  final int maxBodyLength;
  final String loggerName;

  LoggingInterceptor({
    this.logRequest = true,
    this.logResponse = true,
    this.logError = true,
    this.logHeaders = true,
    this.logBody = true,
    this.compactJson = false,
    this.maxBodyLength = 1000,
    this.loggerName = 'HTTP',
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (logRequest) {
      _logRequest(options);
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (logResponse) {
      _logResponse(response);
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (logError) {
      _logError(err);
    }
    handler.next(err);
  }

  void _logRequest(RequestOptions options) {
    final uri = options.uri;
    final method = options.method.toUpperCase();

    _printBox([
      '📤 REQUEST',
      '$method $uri',
      if (logHeaders && options.headers.isNotEmpty)
        _formatHeaders(options.headers),
      if (logBody && options.data != null)
        _formatBody(options.data, 'Request Body'),
    ]);
  }

  void _logResponse(Response response) {
    final uri = response.requestOptions.uri;
    final method = response.requestOptions.method.toUpperCase();
    final statusCode = response.statusCode;
    final statusMessage = response.statusMessage ?? '';

    final emoji = _getStatusEmoji(statusCode);

    _printBox([
      '$emoji RESPONSE',
      '$method $uri',
      'Status: $statusCode $statusMessage',
      if (logHeaders && response.headers.map.isNotEmpty)
        _formatHeaders(response.headers.map),
      if (logBody && response.data != null)
        _formatBody(response.data, 'Response Body'),
    ]);
  }

  void _logError(DioException error) {
    final uri = error.requestOptions.uri;
    final method = error.requestOptions.method.toUpperCase();
    final type = error.type.name;

    final details = <String>[
      '❌ ERROR',
      '$method $uri',
      'Type: $type',
      'Message: ${error.message ?? 'Unknown error'}',
    ];

    if (error.response != null) {
      final response = error.response!;
      details.addAll([
        'Status: ${response.statusCode} ${response.statusMessage ?? ''}',
        if (logHeaders && response.headers.map.isNotEmpty)
          _formatHeaders(response.headers.map),
        if (logBody && response.data != null)
          _formatBody(response.data, 'Error Response Body'),
      ]);
    }

    if (kDebugMode) {
      details.add('Stack Trace:\n${error.stackTrace}');
    }

    _printBox(details);
  }

  String _formatHeaders(Map<String, dynamic> headers) {
    if (headers.isEmpty) return '';

    final buffer = StringBuffer('Headers:\n');
    headers.forEach((key, value) {
      final valueStr = value is List ? value.join(', ') : value.toString();
      buffer.writeln('  $key: $valueStr');
    });
    return buffer.toString().trim();
  }

  String _formatBody(dynamic body, String title) {
    if (body == null) return '';

    String bodyStr;

    try {
      if (body is String) {
        // Try to parse as JSON for pretty printing
        try {
          final jsonObj = json.decode(body);
          bodyStr = _formatJson(jsonObj);
        } catch (e) {
          bodyStr = body;
        }
      } else if (body is Map || body is List) {
        bodyStr = _formatJson(body);
      } else if (body is FormData) {
        bodyStr = _formatFormData(body);
      } else {
        bodyStr = body.toString();
      }
    } catch (e) {
      bodyStr = body.toString();
    }

    // Truncate if too long
    if (bodyStr.length > maxBodyLength) {
      bodyStr =
          '${bodyStr.substring(0, maxBodyLength)}...\n[Content truncated - ${bodyStr.length} total characters]';
    }

    return '$title:\n$bodyStr';
  }

  String _formatJson(dynamic json) {
    try {
      final encoder =
          compactJson
              ? const JsonEncoder()
              : const JsonEncoder.withIndent('  ');
      return encoder.convert(json);
    } catch (e) {
      return json.toString();
    }
  }

  String _formatFormData(FormData formData) {
    final buffer = StringBuffer('FormData:\n');

    for (final field in formData.fields) {
      buffer.writeln('  ${field.key}: ${field.value}');
    }

    for (final file in formData.files) {
      final mapFile = file.value;
      buffer.writeln(
        '  ${file.key}: ${mapFile.filename} (${mapFile.length} bytes)',
      );
    }

    return buffer.toString().trim();
  }

  String _getStatusEmoji(int? statusCode) {
    if (statusCode == null) return '❓';
    if (statusCode >= 200 && statusCode < 300) return '✅';
    if (statusCode >= 300 && statusCode < 400) return '↩️';
    if (statusCode >= 400 && statusCode < 500) return '❌';
    if (statusCode >= 500) return '💥';
    return '❓';
  }

  void _printBox(List<String> content) {
    final filteredContent = content.where((line) => line.isNotEmpty).toList();

    if (filteredContent.isEmpty) return;

    const border = '═';
    const corner = '╔╗╚╝';
    const vertical = '║';

    // Calculate max width
    int maxWidth = 0;
    for (final line in filteredContent) {
      final lines = line.split('\n');
      for (final l in lines) {
        maxWidth = maxWidth < l.length ? l.length : maxWidth;
      }
    }

    maxWidth = maxWidth < 50 ? 50 : maxWidth;
    maxWidth = maxWidth > 120 ? 120 : maxWidth;

    final topBorder = '${corner[0]}${border * (maxWidth + 2)}${corner[1]}';
    final bottomBorder = '${corner[2]}${border * (maxWidth + 2)}${corner[3]}';

    // Print the box
    _log(topBorder);

    for (final content in filteredContent) {
      final lines = content.split('\n');
      for (final line in lines) {
        final padding = maxWidth - line.length;
        final paddedLine = line + (' ' * (padding > 0 ? padding : 0));
        _log('$vertical $paddedLine $vertical');
      }

      // Add separator between sections
      if (content != filteredContent.last && filteredContent.length > 2) {
        final separator = '╟${'─' * (maxWidth + 2)}╢';
        _log(separator);
      }
    }

    _log(bottomBorder);
    _log(''); // Empty line for separation
  }

  void _log(String message) {
    if (kDebugMode) {
      // Use developer.log for better performance and filtering
      developer.log(message, name: loggerName);
    }
  }
}