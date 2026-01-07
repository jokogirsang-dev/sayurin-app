import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../model/user.dart';
import '../widget/custom_app_bar.dart';
import '../widget/custom_buttons.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final userProv = Provider.of<UserProvider>(context);
    final User? user = userProv.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: CustomAppBar(
        title: 'Profil Saya',
        showBackButton: true,
      ),
      body: user == null
          ? _buildNotLoggedIn(context)
          : _buildProfileContent(context, user, userProv),
    );
  }

  Widget _buildNotLoggedIn(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: const Color(0xFFFFEBEE),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.lock_outline_rounded,
              size: 50,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Belum Login',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Silakan login untuk melihat profil Anda',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF999999),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: PrimaryButton(
              text: 'Ke Halaman Login',
              onPressed: () => Navigator.pushNamed(context, '/login'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileContent(
    BuildContext context,
    User user,
    UserProvider userProv,
  ) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          // Profile Header Section
          _buildProfileHeader(user, context),

          const SizedBox(height: 24),

          // Profile Info Cards
          _buildProfileInfoSection(user),

          const SizedBox(height: 24),

          // Account Settings
          _buildAccountSettings(context),

          const SizedBox(height: 24),

          // Help & Support
          _buildHelpSupport(context),

          const SizedBox(height: 24),

          // Logout Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SecondaryButton(
              text: 'Logout',
              onPressed: () {
                _showLogoutDialog(context, userProv);
              },
              borderColor: Colors.red,
              textColor: Colors.red,
              icon: Icons.logout_rounded,
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(User user, BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF2E7D32),
            Color(0xFF43A047),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Column(
          children: [
            // Avatar
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.person_rounded,
                size: 50,
                color: Color(0xFF2E7D32),
              ),
            ),
            const SizedBox(height: 16),

            // Name
            Text(
              user.name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),

            // Email
            Text(
              user.email,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),

            // User Badge
            if (user.isAdmin)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.amber[400],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.verified_user_rounded,
                        size: 16,
                        color: Colors.white,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Admin',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileInfoSection(User user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Informasi Akun',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 12),
          _buildInfoCard(
            icon: Icons.mail_outline_rounded,
            label: 'Email',
            value: user.email,
            iconBgColor: const Color(0xFFE3F2FD),
            iconColor: const Color(0xFF2196F3),
          ),
          const SizedBox(height: 12),
          _buildInfoCard(
            icon: Icons.location_on_outlined,
            label: 'Alamat',
            value: user.alamat.isNotEmpty ? user.alamat : 'Belum diatur',
            iconBgColor: const Color(0xFFFFF3E0),
            iconColor: const Color(0xFFFF9800),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
    required Color iconBgColor,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF999999),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSettings(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pengaturan Akun',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 12),
          _buildMenuOption(
            icon: Icons.person_outline_rounded,
            label: 'Edit Profil',
            onTap: () async {
              final updated = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EditProfilePage()),
              );
              if (updated == true) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Profil diperbarui'),
                  backgroundColor: Color.fromARGB(255, 255, 255, 255),
                ));
              }
            },
          ),
          const SizedBox(height: 8),
          _buildMenuOption(
            icon: Icons.lock_outline_rounded,
            label: 'Ubah Password',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Fitur ubah password akan segera tersedia'),
                  backgroundColor: Color(0xFF2E7D32),
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          _buildMenuOption(
            icon: Icons.notifications_none_rounded,
            label: 'Notifikasi',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Fitur notifikasi akan segera tersedia'),
                  backgroundColor: Color(0xFF2E7D32),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHelpSupport(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Bantuan & Dukungan',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 12),
          _buildMenuOption(
            icon: Icons.help_outline_rounded,
            label: 'Pusat Bantuan',
            onTap: () {
              Navigator.pushNamed(context, '/about');
            },
          ),
          const SizedBox(height: 8),
          _buildMenuOption(
            icon: Icons.info_outline_rounded,
            label: 'Tentang Aplikasi',
            onTap: () {
              Navigator.pushNamed(context, '/about');
            },
          ),
          const SizedBox(height: 8),
          _buildMenuOption(
            icon: Icons.rate_review_rounded,
            label: 'Kirim Feedback',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Feedback akan dikirim ke tim kami'),
                  backgroundColor: Color(0xFF2E7D32),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: const Color(0xFF2E7D32),
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: Color(0xFFCCCCCC),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, UserProvider userProv) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Apakah Anda yakin ingin logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              userProv.logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
