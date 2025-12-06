// Konfigurasi Utama Aplikasi Sayur.in
// Pertemuan 1 dan 7 - Untuk pengaturan global (API, warna, nama app)

import 'package:flutter/material.dart';

class AppConfig {
  // Base URL untuk API produk (bisa diganti ke MockAPI / Midtrans nanti)
  static const String baseUrl = 'https://dummyjson.com/';

  // Endpoint produk groceries default
  static const String groceriesEndpoint = 'products/category/groceries';

  // Nama aplikasi
  static const String appName = 'Sayur.in';

  // Warna utama aplikasi
  static const MaterialColor primaryColor = Colors.green;

  // Tema aplikasi
  static ThemeData themeData = ThemeData(
    useMaterial3: true,
    colorSchemeSeed: Colors.green,
    scaffoldBackgroundColor: Colors.green.shade50,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.green.shade700,
      foregroundColor: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green.shade600,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
  );
}
