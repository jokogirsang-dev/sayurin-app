import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';

// =======================
// PROVIDERS
// =======================
import 'providers/cart_provider.dart';
import 'providers/user_provider.dart';
import 'providers/produk_provider.dart';
import 'providers/pesanan_provider.dart';
import 'providers/admin_provider.dart';

// =======================
// UI PAGES
// =======================
import 'ui/welcome_page.dart';
import 'ui/splash_screen.dart';
import 'ui/login_page.dart';
import 'ui/register_page.dart';
import 'ui/home_page.dart';
import 'ui/produk_page.dart';
import 'ui/pesanan_page.dart';
import 'ui/profile_page.dart';
import 'ui/about_page.dart';
import 'ui/admin_dashboard.dart';

// Admin Pages
import 'ui/admin_pages/admin_analytics_page.dart';
import 'ui/admin_pages/admin_products_page.dart';
import 'ui/admin_pages/admin_stock_page.dart';
import 'ui/admin_pages/admin_orders_page.dart';
import 'ui/admin_pages/admin_reports_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // =======================
        // GLOBAL PROVIDERS - Urutkan dependencies dulu
        // =======================
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => ProdukProvider()),
        ChangeNotifierProvider(create: (_) => PesananProvider()),
        // AdminProvider depend pada Produk & Pesanan, jadi dibuat terakhir
        ChangeNotifierProvider<AdminProvider>(
          create: (context) => AdminProvider(
            produkProvider: Provider.of<ProdukProvider>(context, listen: false),
            pesananProvider:
                Provider.of<PesananProvider>(context, listen: false),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Sayur.in',

        // =======================
        // THEME
        // =======================
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.green,
          scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        ),

        // =======================
        // INITIAL ROUTE
        // =======================
        initialRoute: '/',

        // =======================
        // ROUTES
        // =======================
        routes: {
          '/': (context) => const WelcomePage(),
          '/splash': (context) => const SplashScreen(),
          '/login': (context) => const LoginPage(),
          '/register': (context) => const RegisterPage(),
          '/home': (context) => const HomePage(),
          '/produk': (context) => const ProdukPage(),
          '/pesanan': (context) => const PesananPage(),
          '/profil': (context) => const ProfilePage(),
          '/about': (context) => const AboutPage(),
          '/admin': (context) => const AdminDashboard(),
          '/admin/analytics': (context) => const AdminAnalyticsPage(),
          '/admin/products': (context) => const AdminProductsPage(),
          '/admin/stock': (context) => const AdminStockPage(),
          '/admin/orders': (context) => const AdminOrdersPage(),
          '/admin/reports': (context) => const AdminReportsPage(),
        },
      ),
    );
  }
}
