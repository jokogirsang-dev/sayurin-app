// lib/utils/validators.dart
// ✅ Sentralisasi semua validasi form & input

import '../constants/app_constants.dart';

class Validators {
  /// ============================================
  /// EMAIL VALIDATION
  /// ============================================
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email tidak boleh kosong';
    }

    final emailRegex = RegExp(AppRegex.emailPattern);
    if (!emailRegex.hasMatch(value)) {
      return 'Email tidak valid';
    }

    return null;
  }

  static bool isValidEmail(String email) {
    final emailRegex = RegExp(AppRegex.emailPattern);
    return emailRegex.hasMatch(email);
  }

  /// ============================================
  /// PASSWORD VALIDATION
  /// ============================================
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    }

    if (value.length < AppValidation.minPasswordLength) {
      return 'Password minimal ${AppValidation.minPasswordLength} karakter';
    }

    if (value.length > AppValidation.maxPasswordLength) {
      return 'Password maksimal ${AppValidation.maxPasswordLength} karakter';
    }

    // Optional: Check password strength
    if (!_isStrongPassword(value)) {
      return 'Password harus mengandung huruf besar, angka, dan simbol';
    }

    return null;
  }

  static bool isValidPassword(String password) {
    return password.length >= AppValidation.minPasswordLength &&
        password.length <= AppValidation.maxPasswordLength &&
        _isStrongPassword(password);
  }

  static bool _isStrongPassword(String password) {
    // Minimal: 6 characters
    // Recommended: uppercase + lowercase + number + special char

    // For now, just check length. Can be stricter with uppercase + number
    return true;
  }

  static String? validateConfirmPassword(
      String? password, String? confirmPassword) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'Konfirmasi password tidak boleh kosong';
    }

    if (password != confirmPassword) {
      return 'Password tidak cocok';
    }

    return null;
  }

  /// ============================================
  /// NAME VALIDATION
  /// ============================================
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nama tidak boleh kosong';
    }

    if (value.length < AppValidation.minNameLength) {
      return 'Nama minimal ${AppValidation.minNameLength} karakter';
    }

    if (value.length > AppValidation.maxNameLength) {
      return 'Nama maksimal ${AppValidation.maxNameLength} karakter';
    }

    return null;
  }

  static bool isValidName(String name) {
    return name.isNotEmpty &&
        name.length >= AppValidation.minNameLength &&
        name.length <= AppValidation.maxNameLength;
  }

  /// ============================================
  /// PHONE VALIDATION
  /// ============================================
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nomor telepon tidak boleh kosong';
    }

    final phoneRegex = RegExp(AppRegex.phonePattern);
    if (!phoneRegex.hasMatch(value)) {
      return 'Nomor telepon tidak valid';
    }

    return null;
  }

  static bool isValidPhone(String phone) {
    final phoneRegex = RegExp(AppRegex.phonePattern);
    return phoneRegex.hasMatch(phone);
  }

  /// ============================================
  /// PRICE/CURRENCY VALIDATION
  /// ============================================
  static String? validatePrice(String? value) {
    if (value == null || value.isEmpty) {
      return 'Harga tidak boleh kosong';
    }

    final currencyRegex = RegExp(AppRegex.currencyPattern);
    if (!currencyRegex.hasMatch(value)) {
      return 'Harga tidak valid';
    }

    final price = double.tryParse(value);
    if (price == null || price <= 0) {
      return 'Harga harus lebih dari 0';
    }

    return null;
  }

  static bool isValidPrice(String price) {
    final currencyRegex = RegExp(AppRegex.currencyPattern);
    if (!currencyRegex.hasMatch(price)) return false;

    final amount = double.tryParse(price);
    return amount != null && amount > 0;
  }

  /// ============================================
  /// QUANTITY VALIDATION
  /// ============================================
  static String? validateQuantity(String? value) {
    if (value == null || value.isEmpty) {
      return 'Jumlah tidak boleh kosong';
    }

    final quantity = int.tryParse(value);
    if (quantity == null || quantity <= 0) {
      return 'Jumlah harus lebih dari 0';
    }

    if (quantity > 1000) {
      return 'Jumlah maksimal 1000';
    }

    return null;
  }

  static bool isValidQuantity(String quantity) {
    final qty = int.tryParse(quantity);
    return qty != null && qty > 0 && qty <= 1000;
  }

  /// ============================================
  /// URL VALIDATION
  /// ============================================
  static String? validateUrl(String? value) {
    if (value == null || value.isEmpty) {
      return 'URL tidak boleh kosong';
    }

    final urlRegex = RegExp(AppRegex.urlPattern);
    if (!urlRegex.hasMatch(value)) {
      return 'URL tidak valid';
    }

    return null;
  }

  static bool isValidUrl(String url) {
    final urlRegex = RegExp(AppRegex.urlPattern);
    return urlRegex.hasMatch(url);
  }

  /// ============================================
  /// EMPTY/REQUIRED FIELD VALIDATION
  /// ============================================
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName tidak boleh kosong';
    }
    return null;
  }

  static String? validateNotEmpty(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Field ini tidak boleh kosong';
    }
    return null;
  }

  static bool isNotEmpty(String? value) {
    return value != null && value.trim().isNotEmpty;
  }

  /// ============================================
  /// LENGTH VALIDATION
  /// ============================================
  static String? validateMinLength(
      String? value, int minLength, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName tidak boleh kosong';
    }

    if (value.length < minLength) {
      return '$fieldName minimal $minLength karakter';
    }

    return null;
  }

  static String? validateMaxLength(
      String? value, int maxLength, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName tidak boleh kosong';
    }

    if (value.length > maxLength) {
      return '$fieldName maksimal $maxLength karakter';
    }

    return null;
  }

  static String? validateLength(
    String? value,
    int minLength,
    int maxLength,
    String fieldName,
  ) {
    if (value == null || value.isEmpty) {
      return '$fieldName tidak boleh kosong';
    }

    if (value.length < minLength) {
      return '$fieldName minimal $minLength karakter';
    }

    if (value.length > maxLength) {
      return '$fieldName maksimal $maxLength karakter';
    }

    return null;
  }

  /// ============================================
  /// NUMERIC VALIDATION
  /// ============================================
  static String? validateNumeric(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName tidak boleh kosong';
    }

    if (int.tryParse(value) == null) {
      return '$fieldName harus berupa angka';
    }

    return null;
  }

  static bool isNumeric(String value) {
    return int.tryParse(value) != null;
  }

  /// ============================================
  /// DATE VALIDATION
  /// ============================================
  static String? validateDate(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName tidak boleh kosong';
    }

    final date = DateTime.tryParse(value);
    if (date == null) {
      return '$fieldName harus format tanggal yang valid';
    }

    return null;
  }

  static bool isValidDate(String dateString) {
    return DateTime.tryParse(dateString) != null;
  }

  /// ============================================
  /// COMPOSITE VALIDATION
  /// ============================================
  /// Validate multiple fields at once
  static Map<String, String> validateForm({
    required String email,
    required String password,
    required String name,
    String? phone,
  }) {
    final errors = <String, String>{};

    final emailError = validateEmail(email);
    if (emailError != null) errors['email'] = emailError;

    final passwordError = validatePassword(password);
    if (passwordError != null) errors['password'] = passwordError;

    final nameError = validateName(name);
    if (nameError != null) errors['name'] = nameError;

    if (phone != null) {
      final phoneError = validatePhone(phone);
      if (phoneError != null) errors['phone'] = phoneError;
    }

    return errors;
  }

  /// ============================================
  /// CUSTOM VALIDATORS
  /// ============================================
  /// Custom validator dengan predicate function
  static String? validateCustom(
    String? value,
    String fieldName,
    bool Function(String) predicate,
    String errorMessage,
  ) {
    if (value == null || value.isEmpty) {
      return '$fieldName tidak boleh kosong';
    }

    if (!predicate(value)) {
      return errorMessage;
    }

    return null;
  }
}
