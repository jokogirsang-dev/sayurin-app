import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/cart_provider.dart';
import 'providers/user_provider.dart';
import 'providers/produk_provider.dart';
import 'providers/pesanan_provider.dart';

import 'ui/splash_screen.dart';
import 'ui/login_page.dart';
import 'ui/register_page.dart';
import 'ui/home_page.dart';
import 'ui/pesanan_page.dart';
import 'ui/produk_page.dart';
import 'ui/profile_page.dart';
import 'ui/about_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ProdukProvider()),
        ChangeNotifierProvider(create: (_) => PesananProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Sayur.in',
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.green,
        ),
        initialRoute: '/splash',
        routes: {
          '/splash': (_) => const SplashScreen(),
          '/login': (_) => const LoginPage(),
          '/register': (_) => const RegisterPage(),
          '/home': (_) => const HomePage(),
          '/produk': (_) => const ProdukPage(),
          '/pesanan': (_) => const PesananPage(),
          '/profil': (_) => const ProfilePage(),
          '/about': (_) => const AboutPage(),
        },
      ),
    );
  }
}
