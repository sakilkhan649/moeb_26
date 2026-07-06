import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// ===================== APP LOGGER =====================
/// Centralized logging utility for API requests, responses, and errors.
/// Only logs in debug mode to avoid leaking sensitive data in production.

class AppLogger {
  AppLogger._();

  static const String _divider = '══════════════════════════════════════';

  /// Log outgoing API request
  static void request(RequestOptions options) {
    if (!kDebugMode) return;

    debugPrint('');
    debugPrint('┌ ➡️➡️➡️➡️ REQUEST $_divider ➡️➡️➡️➡️');
    debugPrint('│ ${options.method} ${options.uri}');
    debugPrint('│ Headers: ${_sanitizeHeaders(options.headers)}');
    if (options.queryParameters.isNotEmpty) {
      debugPrint('│ Query: ${options.queryParameters}');
    }
    if (options.data != null) {
      final data = options.data;
      if (data is Map || data is List) {
        final formatted = _prettyJson(data);
        final lines = formatted.split('\n');
        for (final line in lines) {
          debugPrint('│ Body: $line');
        }
      } else if (data is FormData) {
        debugPrint('│ Body: [FormData]');
        for (final field in data.fields) {
          debugPrint('│   ${field.key}: ${field.value}');
        }
        for (final file in data.files) {
          debugPrint(
            '│   ${file.key}: File (name: ${file.value.filename}, size: ${file.value.length} bytes)',
          );
        }
      } else {
        debugPrint('│ Body: ${data.toString()}');
      }
    }
    debugPrint('└ ➡️➡️➡️➡️ REQUEST $_divider ➡️➡️➡️➡️');
    debugPrint('');
  }

  /// Log incoming API response
  static void response(Response response) {
    if (!kDebugMode) return;

    debugPrint('');
    debugPrint('┌ ✅✅✅✅ RESPONSE $_divider ✅✅✅✅');
    debugPrint(
      '│ [ ${response.requestOptions.method} ${response.statusCode}] ${response.requestOptions.uri}',
    );

    final data = response.data;
    if (data != null) {
      final formatted = _prettyJson(data);
      final lines = formatted.split('\n');
      for (final line in lines) {
        debugPrint('│ $line');
      }
    } else {
      debugPrint('│ Data: null');
    }

    debugPrint('└ ✅✅✅✅ RESPONSE $_divider ✅✅✅│');
    debugPrint('');
  }

  /// Log API error
  static void error(DioException e) {
    if (!kDebugMode) return;

    debugPrint('');
    debugPrint('┌ ❌❌❌❌ ERROR $_divider ❌❌❌❌ ');
    debugPrint('│ ${e.type.name}: ${e.message}');
    debugPrint('│  ${e.requestOptions.method} : ${e.requestOptions.uri}');
    if (e.response != null) {
      debugPrint('│ Status: ${e.response?.statusCode}');
      final data = e.response?.data;
      if (data != null) {
        final formatted = _prettyJson(data);
        final lines = formatted.split('\n');
        for (final line in lines) {
          debugPrint('│ $line');
        }
      } else {
        debugPrint('│ Data: null');
      }
    }
    debugPrint('└ ❌❌❌❌ ERROR $_divider ❌❌❌❌ ');
    debugPrint('');
  }

  // ──────────────────── PRIVATE HELPERS ────────────────────

  /// Remove Authorization header value for safe logging
  static Map<String, dynamic> _sanitizeHeaders(Map<String, dynamic> headers) {
    final sanitized = Map<String, dynamic>.from(headers);
    if (sanitized.containsKey('Authorization')) {
      sanitized['Authorization'] = '***';
    }
    return sanitized;
  }

  /// Pretty print JSON objects
  static String _prettyJson(dynamic data) {
    if (data == null) return 'null';
    try {
      const encoder = JsonEncoder.withIndent('  ');
      return encoder.convert(data);
    } catch (_) {
      return data.toString();
    }
  }
}
