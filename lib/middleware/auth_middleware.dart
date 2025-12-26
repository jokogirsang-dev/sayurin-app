// lib/middleware/auth_middleware.dart
// 🔐 JWT Token verification dan authentication middleware
// Berdasarkan flowchart "4. CHECK ROUTE PROTECTION" dan "3. EXTRACT USER INFO FROM JWT"

import 'package:jwt_decoder/jwt_decoder.dart';
import '../constants/app_constants.dart';
import '../utils/error_handler.dart';

/// Middleware untuk handle authentication
class AuthMiddleware {
  /// ============================================
  /// TOKEN MANAGEMENT
  /// ============================================

  /// Verify token validity dan extract user info
  /// Returns: Map dengan user info atau null jika invalid
  static Map<String, dynamic>? verifyToken(String token) {
    try {
      // Check if token is expired
      if (JwtDecoder.isExpired(token)) {
        throw AppException(
          code: ErrorCodes.tokenExpired,
          message: 'Token has expired',
          userMessage: 'Sesi Anda telah berakhir. Silakan login kembali.',
        );
      }

      // Decode token dan extract payload
      final decodedToken = JwtDecoder.decode(token);

      // Validate required fields
      if (!_validateTokenPayload(decodedToken)) {
        throw AppException(
          code: ErrorCodes.invalidToken,
          message: 'Token payload is invalid',
          userMessage: 'Token tidak valid. Silakan login kembali.',
        );
      }

      return decodedToken;
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }
      throw AppException(
        code: ErrorCodes.invalidToken,
        message: 'Failed to verify token: $e',
        userMessage: 'Token tidak valid. Silakan login kembali.',
        originalError: e,
      );
    }
  }

  /// Validate token payload contains required fields
  static bool _validateTokenPayload(Map<String, dynamic> payload) {
    // Required fields dalam JWT token
    final requiredFields = ['userId', 'email', 'role', 'iat', 'exp'];

    for (final field in requiredFields) {
      if (!payload.containsKey(field)) {
        return false;
      }
    }

    return true;
  }

  /// Extract user ID dari token
  static String? extractUserId(String token) {
    try {
      final decodedToken = JwtDecoder.decode(token);
      return decodedToken['userId']?.toString();
    } catch (e) {
      return null;
    }
  }

  /// Extract email dari token
  static String? extractEmail(String token) {
    try {
      final decodedToken = JwtDecoder.decode(token);
      return decodedToken['email']?.toString();
    } catch (e) {
      return null;
    }
  }

  /// Extract user role dari token
  static String? extractRole(String token) {
    try {
      final decodedToken = JwtDecoder.decode(token);
      return decodedToken['role']?.toString();
    } catch (e) {
      return null;
    }
  }

  /// Extract custom claims dari token
  static dynamic extractClaim(String token, String claimName) {
    try {
      final decodedToken = JwtDecoder.decode(token);
      return decodedToken[claimName];
    } catch (e) {
      return null;
    }
  }

  /// ============================================
  /// TOKEN VALIDATION
  /// ============================================

  /// Check if token exists dan valid
  static bool isTokenValid(String? token) {
    if (token == null || token.isEmpty) {
      return false;
    }

    try {
      if (JwtDecoder.isExpired(token)) {
        return false;
      }

      final payload = JwtDecoder.decode(token);
      return _validateTokenPayload(payload);
    } catch (e) {
      return false;
    }
  }

  /// Check if token is expired
  static bool isTokenExpired(String token) {
    try {
      return JwtDecoder.isExpired(token);
    } catch (e) {
      return true;
    }
  }

  /// Get token expiration time
  static DateTime? getTokenExpirationTime(String token) {
    try {
      return JwtDecoder.getExpirationDate(token);
    } catch (e) {
      return null;
    }
  }

  /// Get remaining time until token expires
  static Duration? getTokenRemainingTime(String token) {
    try {
      final expirationTime = JwtDecoder.getExpirationDate(token);
      final now = DateTime.now();

      if (expirationTime.isBefore(now)) {
        return null; // Token sudah expired
      }

      return expirationTime.difference(now);
    } catch (e) {
      return null;
    }
  }

  /// ============================================
  /// TOKEN REFRESH LOGIC
  /// ============================================

  /// Check if token perlu refresh (misalnya 5 menit sebelum expiry)
  static bool shouldRefreshToken(String token) {
    final remainingTime = getTokenRemainingTime(token);

    if (remainingTime == null) {
      return false; // Token already expired
    }

    // Refresh jika kurang dari 5 menit sampai expired
    return remainingTime.inMinutes < 5;
  }

  /// ============================================
  /// TOKEN PAYLOAD EXTRACTION
  /// ============================================

  /// Extract seluruh user info dari token
  static Map<String, dynamic>? extractUserInfo(String token) {
    try {
      final payload = verifyToken(token);

      return {
        'userId': payload?['userId'],
        'email': payload?['email'],
        'role': payload?['role'],
        'name': payload?['name'],
        'avatar': payload?['avatar'],
        'isVerified': payload?['isVerified'] ?? false,
        'customClaims': _extractCustomClaims(payload ?? {}),
      };
    } catch (e) {
      return null;
    }
  }

  /// Extract custom claims dari token (selain standard ones)
  static Map<String, dynamic> _extractCustomClaims(
      Map<String, dynamic> payload) {
    final standardClaims = [
      'userId',
      'email',
      'role',
      'name',
      'avatar',
      'isVerified',
      'iat',
      'exp',
      'sub',
      'iss',
      'aud',
    ];

    return Map<String, dynamic>.from(
      payload..removeWhere((key, value) => standardClaims.contains(key)),
    );
  }

  /// ============================================
  /// LOGGING & DEBUGGING
  /// ============================================

  /// Log token info untuk debugging
  static void logTokenInfo(String token) {
    try {
      final payload = JwtDecoder.decode(token);
      final expirationTime = JwtDecoder.getExpirationDate(token);
      final isExpired = JwtDecoder.isExpired(token);

      print(
          '╔════════════════════════════════════════════════════════════════╗');
      print('║ 🔐 TOKEN INFO');
      print(
          '╠════════════════════════════════════════════════════════════════╣');
      print('║ User ID: ${payload['userId']}');
      print('║ Email: ${payload['email']}');
      print('║ Role: ${payload['role']}');
      print('║ Expires At: $expirationTime');
      print('║ Is Expired: $isExpired');
      print('║ Remaining Time: ${getTokenRemainingTime(token)}');
      print('║ Payload: $payload');
      print(
          '╚════════════════════════════════════════════════════════════════╝');
    } catch (e) {
      print('Failed to log token info: $e');
    }
  }
}

/// Extension untuk easier token handling
extension TokenExtension on String {
  /// Verify this token
  bool get isValidToken => AuthMiddleware.isTokenValid(this);

  /// Check if this token is expired
  bool get isExpired => AuthMiddleware.isTokenExpired(this);

  /// Extract user ID
  String? get userId => AuthMiddleware.extractUserId(this);

  /// Extract email
  String? get email => AuthMiddleware.extractEmail(this);

  /// Extract role
  String? get role => AuthMiddleware.extractRole(this);

  /// Get remaining time
  Duration? get remainingTime => AuthMiddleware.getTokenRemainingTime(this);

  /// Extract all user info
  Map<String, dynamic>? get userInfo => AuthMiddleware.extractUserInfo(this);
}
