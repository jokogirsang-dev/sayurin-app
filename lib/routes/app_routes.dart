// Routing Utama Aplikasi Sayur.in
// Pertemuan 2 - Mengatur navigasi halaman secara terpusat

import 'package:flutter/material.dart';
import '../ui/splash_screen.dart';
import '../ui/home_page.dart';
import '../ui/login_page.dart';
import '../ui/register_page.dart';
import '../ui/produk_page.dart';
import '../ui/cart_page.dart';
import '../ui/checkout_page.dart';
import '../ui/pesanan_page.dart';
import '../ui/profile_page.dart';
import '../ui/admin_dashboard.dart';
import '../ui/laporan_page.dart';
import '../ui/about_page.dart';

class AppRoutes {
  static const String splash = '/';
  static const String home = '/home';
  static const String login = '/login';
  static const String register = '/register';
  static const String produk = '/produk';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String pesanan = '/pesanan';
  static const String profile = '/profile';
  static const String admin = '/admin';
  static const String laporan = '/laporan';
  static const String about = '/about';

  static Map<String, WidgetBuilder> routes = {
    splash: (_) => const SplashScreen(),
    home: (_) => const HomePage(),
    login: (_) => const LoginPage(),
    register: (_) => const RegisterPage(),
    produk: (_) => const ProdukPage(),
    cart: (_) => const CartPage(),
    checkout: (_) => const CheckoutPage(),
    pesanan: (_) => const PesananPage(),
    profile: (_) => const ProfilePage(),
    admin: (_) => const AdminDashboard(),
    laporan: (_) => const LaporanPage(),
    about: (_) => const AboutPage(),
  };
}
