// sidebar.dart
import 'package:flutter/material.dart';

class AppSidebar extends StatelessWidget {
  const AppSidebar({super.key});

  void _go(BuildContext context, String routeName) {
    Navigator.pop(context); // tutup drawer dulu
    Navigator.pushReplacementNamed(context, routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.green.shade50,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.green.shade600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/images/sayurin.png'),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Sayur.in',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Segar dari Petani Lokal',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),

          ListTile(
            leading: Icon(Icons.home, color: Colors.green.shade700),
            title: const Text('Beranda'),
            onTap: () => _go(context, '/home'),
          ),
          ListTile(
            leading: Icon(Icons.shopping_basket, color: Colors.green.shade700),
            title: const Text('Produk'),
            onTap: () => _go(context, '/produk'),
          ),
          ListTile(
            leading: Icon(Icons.list_alt, color: Colors.green.shade700),
            title: const Text('Pesanan'),
            onTap: () => _go(context, '/pesanan'),
          ),
          ListTile(
            leading: Icon(Icons.person, color: Colors.green.shade700),
            title: const Text('Profil'),
            onTap: () => _go(context, '/profil'),
          ),
          ListTile(
            leading: Icon(Icons.info, color: Colors.green.shade700),
            title: const Text('Tentang'),
            onTap: () => _go(context, '/about'),
          ),
        ],
      ),
    );
  }
}
