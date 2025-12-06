// Pertemuan 10 - Profile Page
import 'package:flutter/material.dart';
import '../providers/user_provider.dart';
import 'package:provider/provider.dart';
import '../model/user.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) {
    final userProv = Provider.of<UserProvider>(context);
    final User? user = userProv.currentUser;
    return Scaffold(
      appBar: AppBar(title: const Text('Profil Saya')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: user == null
            ? const Center(child: Text('Belum login'))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nama: \${user.name}',
                      style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 8),
                  Text('Email: \${user.email}'),
                  const SizedBox(height: 12),
                  ElevatedButton(
                      onPressed: () => userProv.logout(),
                      child: const Text('Logout'))
                ],
              ),
      ),
    );
  }
}
