// lib/constants/app_constants.dart
// 🎯 Sentralisasi semua konstanta aplikasi

import 'package:flutter/material.dart';

/// Marker class - all constants are in separate top-level classes
class AppConstants {
  AppConstants._(); // Private constructor - prevents instantiation
}

/// Error code constants
class ErrorCodes {
  static const String invalidEmail = 'INVALID_EMAIL';
  static const String invalidPassword = 'INVALID_PASSWORD';
  static const String userNotFound = 'USER_NOT_FOUND';
  static const String userAlreadyExists = 'USER_ALREADY_EXISTS';
  static const String invalidToken = 'INVALID_TOKEN';
  static const String tokenExpired = 'TOKEN_EXPIRED';
  static const String validationFailed = 'VALIDATION_FAILED';
  static const String missingRequired = 'MISSING_REQUIRED';
  static const String invalidFormat = 'INVALID_FORMAT';
  static const String serverError = 'SERVER_ERROR';
  static const String badRequest = 'BAD_REQUEST';
  static const String unauthorized = 'UNAUTHORIZED';
  static const String forbidden = 'FORBIDDEN';
  static const String notFound = 'NOT_FOUND';
  static const String conflict = 'CONFLICT';
  static const String networkError = 'NETWORK_ERROR';
  static const String timeout = 'TIMEOUT';
  static const String connectionError = 'CONNECTION_ERROR';
  static const String noInternet = 'NO_INTERNET';
  static const String cancelled = 'CANCELLED';
  static const String validationError = 'VALIDATION_ERROR';
  static const String invalidRequest = 'INVALID_REQUEST';
  static const String rateLimit = 'RATE_LIMIT';
  static const String serviceUnavailable = 'SERVICE_UNAVAILABLE';
  static const String unknownError = 'UNKNOWN_ERROR';
  static const String securityError = 'SECURITY_ERROR';
}

/// User role constants
class UserRoles {
  static const String customer = 'CUSTOMER';
  static const String admin = 'ADMIN';
  static const String superAdmin = 'SUPER_ADMIN';
}

/// Permission type constants
class PermissionTypes {
  static const String viewHome = 'VIEW_HOME';
  static const String searchProducts = 'SEARCH_PRODUCTS';
  static const String viewProductDetail = 'VIEW_PRODUCT_DETAIL';
  static const String manageCart = 'MANAGE_CART';
  static const String createOrder = 'CREATE_ORDER';
  static const String viewOrder = 'VIEW_ORDER';
  static const String cancelOrder = 'CANCEL_ORDER';
  static const String reviewProduct = 'REVIEW_PRODUCT';
  static const String viewProfile = 'VIEW_PROFILE';
  static const String editProfile = 'EDIT_PROFILE';
  static const String adminDashboard = 'ADMIN_DASHBOARD';
  static const String adminProductCreate = 'ADMIN_PRODUCT_CREATE';
  static const String adminProductEdit = 'ADMIN_PRODUCT_EDIT';
  static const String adminProductDelete = 'ADMIN_PRODUCT_DELETE';
  static const String adminOrderManage = 'ADMIN_ORDER_MANAGE';
  static const String adminReportView = 'ADMIN_REPORT_VIEW';
  static const String adminSettingsManage = 'ADMIN_SETTINGS_MANAGE';
}

/// Color constants
class AppColors {
  static const Color primaryGreen = Color(0xFF2E7D32);
  static const Color primaryGreenLight = Color(0xFF43A047);
  static const Color primaryGreenDark = Color(0xFF1B5E20);
  static const Color secondaryOrange = Color(0xFFFF6F00);
  static const Color secondaryOrangeDark = Color(0xFFE65100);
  static const Color secondaryOrangeLight = Color(0xFFFF8F00);
  static const Color accentBlue = Color(0xFF1565C0);
  static const Color accentRed = Color(0xFFFF5252);
  static const Color accentYellow = Color(0xFFFFB300);
  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color backgroundWhite = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF212121);
  static const Color textGrey = Color(0xFF757575);
  static const Color textLightGrey = Color(0xFF999999);
  static const Color borderGrey = Color(0xFFE0E0E0);
  static const Color dividerGrey = Color(0xFFBDBDBD);
  static const Color statusSuccess = Color(0xFF4CAF50);
  static const Color statusWarning = Color(0xFFFFC107);
  static const Color statusError = Color(0xFFFF5252);
  static const Color statusInfo = Color(0xFF2196F3);
}

/// Typography constants
class AppTypography {
  static const double fontSizeXXS = 10.0;
  static const double fontSizeXS = 11.0;
  static const double fontSizeSM = 12.0;
  static const double fontSizeBase = 13.0;
  static const double fontSizeLG = 14.0;
  static const double fontSizeXL = 16.0;
  static const double fontSizeXXL = 18.0;
  static const double fontSizeTitle = 20.0;
  static const double fontSizeHeading = 24.0;
  static const double fontSizeHero = 28.0;
  static const FontWeight fontWeightLight = FontWeight.w300;
  static const FontWeight fontWeightRegular = FontWeight.w400;
  static const FontWeight fontWeightMedium = FontWeight.w500;
  static const FontWeight fontWeightSemiBold = FontWeight.w600;
  static const FontWeight fontWeightBold = FontWeight.w700;
  static const FontWeight fontWeightExtraBold = FontWeight.w900;
}

/// Spacing constants
class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double xxxl = 32.0;
  static const double buttonHeight = 56.0;
  static const double buttonHeightSmall = 44.0;
  static const double appBarHeight = 56.0;
  static const double bottomNavHeight = 60.0;
  static const double cardBorderRadius = 12.0;
  static const double buttonBorderRadius = 12.0;
}

/// Animation constants
class AppAnimation {
  static const Duration durationXFast = Duration(milliseconds: 150);
  static const Duration durationFast = Duration(milliseconds: 300);
  static const Duration durationNormal = Duration(milliseconds: 500);
  static const Duration durationSlow = Duration(milliseconds: 800);
  static const Duration durationXSlow = Duration(milliseconds: 1200);
  static const Curve curveEaseIn = Curves.easeIn;
  static const Curve curveEaseOut = Curves.easeOut;
  static const Curve curveEaseInOut = Curves.easeInOut;
  static const Curve curveBounce = Curves.bounceIn;
}

/// API constants
class AppAPI {
  static const String baseUrl = 'https://api.hortasima.com';
  static const String apiVersion = '/v1';
}

/// Order status constants
class OrderStatus {
  static const String pending = 'Pending';
  static const String processing = 'Diproses';
  static const String packing = 'Dikemas';
  static const String shipped = 'Dikirim';
  static const String delivered = 'Selesai';
  static const String cancelled = 'Dibatalkan';
  static const String returned = 'Dikembalikan';
}

/// Payment method constants
class PaymentMethod {
  static const String bankTransfer = 'BANK_TRANSFER';
  static const String creditCard = 'CREDIT_CARD';
  static const String debitCard = 'DEBIT_CARD';
  static const String eWallet = 'E_WALLET';
  static const String cod = 'COD';
}

/// App links constants
class AppLinks {
  static const String privacyPolicy = 'https://hortasima.com/privacy';
  static const String termsOfService = 'https://hortasima.com/terms';
  static const String website = 'https://hortasima.com';
  static const String supportEmail = 'support@hortasima.com';
  static const String contactUs = 'https://hortasima.com/contact';
}

/// Default values
class DefaultValues {
  static const String defaultUserName = 'User';
  static const String defaultUserEmail = 'unknown@hortasima.com';
  static const String defaultUserAvatar = 'assets/images/default_avatar.png';
  static const String defaultProductImage = 'assets/images/default_product.png';
  static const double defaultRating = 0.0;
  static const int defaultPageNumber = 1;
}

/// Validation constants
class AppValidation {
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 50;
  static const int minNameLength = 3;
  static const int maxNameLength = 100;
  static const int minPhoneLength = 10;
  static const int maxPhoneLength = 15;
  static const int minBioLength = 0;
  static const int maxBioLength = 500;
}

/// Timeout constants
class AppTimeout {
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration connectionTimeout = Duration(seconds: 10);
  static const Duration shortWait = Duration(seconds: 2);
  static const Duration mediumWait = Duration(seconds: 5);
  static const Duration longWait = Duration(seconds: 10);
}

/// Pagination constants
class AppPagination {
  static const int defaultPageSize = 10;
  static const int defaultPageSizeSmall = 5;
  static const int defaultPageSizeLarge = 20;
  static const int maxItems = 1000;
}

/// Regex patterns
class AppRegex {
  static const String emailPattern =
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String passwordPattern =
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$';
  static const String phonePattern = r'^(\+62|0)[0-9]{9,12}$';
  static const String urlPattern =
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$';
  static const String currencyPattern = r'^[0-9]{1,15}(\.[0-9]{1,2})?$';
}

/// Feature flags
class AppFeatures {
  static const bool enableEmailVerification = true;
  static const bool enablePhoneVerification = false;
  static const bool enable2FA = true;
  static const bool enableBiometric = false;
  static const bool enableWishlist = true;
  static const bool enableReviews = true;
  static const bool enableSharing = true;
  static const bool enableGuestCheckout = false;
  static const bool enableBankTransfer = true;
  static const bool enableCreditCard = true;
  static const bool enableEWallet = true;
  static const bool enableCOD = true;
  static const bool enableAnalytics = true;
  static const bool enableReports = true;
  static const bool enablePromos = true;
  static const bool enableBulkActions = true;
  static const bool enableDebugLogging = false;
  static const bool showDebugInfo = false;
}
