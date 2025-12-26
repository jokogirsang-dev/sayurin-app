// lib/utils/error_handler.dart
// 🚨 Centralized error handling dengan mapping ke error codes & user-friendly messages

import 'package:dio/dio.dart';
import 'dart:async';

/// Custom exception class untuk consistent error handling di seluruh app
class AppException implements Exception {
  final String code;
  final String message;
  final String? userMessage;
  final dynamic originalError;
  final StackTrace? stackTrace;

  AppException({
    required this.code,
    required this.message,
    this.userMessage,
    this.originalError,
    this.stackTrace,
  });

  @override
  String toString() => 'AppException: $code - $message';
}

/// Main error handler class
class ErrorHandler {
  /// ============================================
  /// ERROR PARSING
  /// ============================================

  /// Parse berbagai jenis error dan convert ke AppException
  static AppException handleError(dynamic error, {StackTrace? stackTrace}) {
    if (error is AppException) {
      return error;
    }

    if (error is DioException) {
      return _handleDioError(error, stackTrace);
    }

    if (error is FormatException) {
      return AppException(
        code: 'INVALID_FORMAT',
        message: 'Format data tidak valid',
        userMessage: 'Data yang diterima tidak valid. Coba lagi.',
        originalError: error,
        stackTrace: stackTrace,
      );
    }

    if (error is TimeoutException) {
      return AppException(
        code: '',
        message: 'Request timeout',
        userMessage: 'Permintaan memakan waktu terlalu lama. Coba lagi.',
        originalError: error,
        stackTrace: stackTrace,
      );
    }

    // Generic unknown error
    return AppException(
      code: '',
      message: error.toString(),
      userMessage: 'Terjadi kesalahan. Coba lagi nanti.',
      originalError: error,
      stackTrace: stackTrace,
    );
  }

  /// Handle Dio (HTTP) specific errors
  static AppException _handleDioError(
      DioException error, StackTrace? stackTrace) {
    String code = '';
    String message = 'Unknown error';
    String userMessage = 'Terjadi kesalahan. Coba lagi nanti.';

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        code = '';
        message = 'Connection timeout';
        userMessage = 'Koneksi timeout. Pastikan internet stabil.';
        break;

      case DioExceptionType.sendTimeout:
        code = '';
        message = 'Send timeout';
        userMessage = 'Pengiriman data timeout. Coba lagi.';
        break;

      case DioExceptionType.receiveTimeout:
        code = '';
        message = 'Receive timeout';
        userMessage = 'Penerimaan data timeout. Coba lagi.';
        break;

      case DioExceptionType.badResponse:
        // Handle HTTP status codes
        final statusCode = error.response?.statusCode ?? 0;
        final responseData = error.response?.data;

        code = _mapStatusCodeToErrorCode(statusCode);
        message = 'HTTP Error: $statusCode';
        userMessage = _getErrorMessageFromResponse(statusCode, responseData);
        break;

      case DioExceptionType.cancel:
        code = '';
        message = 'Request cancelled';
        userMessage = 'Permintaan dibatalkan.';
        break;

      case DioExceptionType.connectionError:
        code = '';
        message = 'Connection error';
        userMessage = 'Tidak ada koneksi internet. Periksa koneksi Anda.';
        break;

      case DioExceptionType.unknown:
        code = '';
        message = error.message ?? 'Unknown error';
        userMessage = 'Terjadi kesalahan yang tidak diketahui.';
        break;

      case DioExceptionType.badCertificate:
        code = '';
        message = 'Bad certificate';
        userMessage = 'Sertifikat server tidak valid. Hubungi administrator.';
        break;
    }

    return AppException(
      code: code,
      message: message,
      userMessage: userMessage,
      originalError: error,
      stackTrace: stackTrace,
    );
  }

  /// ============================================
  /// HTTP STATUS CODE MAPPING
  /// ============================================

  static String _mapStatusCodeToErrorCode(int statusCode) {
    switch (statusCode) {
      case 400:
        return '';
      case 401:
        return '';
      case 403:
        return '';
      case 404:
        return '';
      case 409:
        return '';
      case 422:
        return '';
      case 429:
        return '';
      case 500:
        return '';
      case 502:
      case 503:
      case 504:
        return '';
      default:
        return '';
    }
  }

  /// Get user-friendly error message berdasarkan HTTP status code
  static String _getErrorMessageFromResponse(
      int statusCode, dynamic responseData) {
    // Try to extract error message dari response body
    if (responseData is Map<String, dynamic>) {
      final message = responseData['message'] ?? responseData['error'];
      if (message != null) {
        return message.toString();
      }
    }

    // Default messages
    switch (statusCode) {
      case 400:
        return 'Permintaan tidak valid. Periksa data Anda.';
      case 401:
        return 'Sesi Anda telah berakhir. Silakan login kembali.';
      case 403:
        return 'Anda tidak memiliki akses ke resource ini.';
      case 404:
        return 'Resource tidak ditemukan.';
      case 409:
        return 'Data yang Anda masukkan sudah ada.';
      case 422:
        return 'Data yang Anda masukkan tidak valid.';
      case 429:
        return 'Terlalu banyak permintaan. Coba lagi nanti.';
      case 500:
        return 'Server error. Coba lagi nanti.';
      case 502:
      case 503:
      case 504:
        return 'Server sedang dalam pemeliharaan. Coba lagi nanti.';
      default:
        return 'Terjadi kesalahan. Coba lagi nanti.';
    }
  }

  /// ============================================
  /// VALIDATION ERROR HANDLING
  /// ============================================

  /// Handle validation errors dari form
  static AppException handleValidationError(
      String fieldName, String validationRule) {
    final message = _getValidationErrorMessage(fieldName, validationRule);

    return AppException(
      code: '',
      message: 'Validation failed: $fieldName - $validationRule',
      userMessage: message,
    );
  }

  static String _getValidationErrorMessage(String field, String rule) {
    // Convert field name to user-friendly
    final fieldDisplay = _humanizeFieldName(field);

    switch (rule) {
      case 'required':
        return '$fieldDisplay tidak boleh kosong';
      case 'email':
        return '$fieldDisplay harus berupa email yang valid';
      case 'minLength':
        return '$fieldDisplay terlalu pendek';
      case 'maxLength':
        return '$fieldDisplay terlalu panjang';
      case 'numeric':
        return '$fieldDisplay harus berupa angka';
      case 'phone':
        return '$fieldDisplay harus berupa nomor telepon yang valid';
      case 'url':
        return '$fieldDisplay harus berupa URL yang valid';
      case 'password':
        return 'Password harus minimal 8 karakter dengan kombinasi huruf besar, kecil, angka, dan simbol';
      case 'match':
        return '$fieldDisplay tidak cocok';
      default:
        return 'Format $fieldDisplay tidak valid';
    }
  }

  static String _humanizeFieldName(String field) {
    // Convert camelCase atau snake_case ke human readable
    return field
        .replaceAllMapped(RegExp(r'([A-Z])'), (match) => ' ${match.group(1)}')
        .replaceAll('_', ' ')
        .split(' ')
        .map((word) =>
            word.isEmpty ? '' : word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  /// ============================================
  /// BUSINESS LOGIC ERRORS
  /// ============================================

  /// Handle business logic errors (e.g., insufficient balance)
  static AppException handleBusinessError(String code, String message,
      {String? userMessage}) {
    return AppException(
      code: code,
      message: message,
      userMessage: userMessage ?? message,
    );
  }

  /// ============================================
  /// ERROR LOGGING
  /// ============================================

  /// Log error untuk debugging
  static void logError(AppException error) {
    print('╔════════════════════════════════════════════════════════════════╗');
    print('║ 🚨 ERROR LOG');
    print('╠════════════════════════════════════════════════════════════════╣');
    print('║ Code: ${error.code}');
    print('║ Message: ${error.message}');
    print('║ User Message: ${error.userMessage ?? 'N/A'}');
    if (error.originalError != null) {
      print('║ Original Error: ${error.originalError}');
    }
    if (error.stackTrace != null) {
      print('║ Stack Trace: ${error.stackTrace}');
    }
    print('╚════════════════════════════════════════════════════════════════╝');
  }

  /// ============================================
  /// USER-FACING ERROR MESSAGES
  /// ============================================

  /// Get user-friendly message untuk display di UI
  static String getUserMessage(AppException error) {
    return error.userMessage ?? error.message;
  }

  /// Get error message untuk snackbar/toast
  static String getSnackbarMessage(dynamic error) {
    final appError = handleError(error);
    return appError.userMessage ?? appError.message;
  }

  /// Check if error is due to network issues
  static bool isNetworkError(AppException error) {
    return error.code == '' || error.code == '' || error.code == '';
  }

  /// Check if error is due to authentication
  static bool isAuthError(AppException error) {
    return error.code == '' || error.code == '';
  }

  /// Check if error is due to validation
  static bool isValidationError(AppException error) {
    return error.code == '' || error.code == '';
  }

  /// ============================================
  /// ERROR RECOVERY
  /// ============================================

  /// Check if error is retryable
  static bool isRetryable(AppException error) {
    final retryableErrors = [
      '',
      '',
      '',
    ];
    return retryableErrors.contains(error.code);
  }

  /// Get retry delay in milliseconds
  static int getRetryDelay(int attemptNumber) {
    // Exponential backoff: 1s, 2s, 4s, 8s, etc.
    return (1000 * (1 << (attemptNumber - 1))).clamp(1000, 30000);
  }
}

/// Extension untuk easier error handling
extension ErrorHandlingExtension on Exception {
  AppException toAppException({StackTrace? stackTrace}) {
    return ErrorHandler.handleError(this, stackTrace: stackTrace);
  }
}
