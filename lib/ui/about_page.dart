// lib/ui/about_page.dart

import 'package:flutter/material.dart';
import '../widget/custom_app_bar.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: CustomAppBar(
        title: 'Tentang Aplikasi',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Header Section
            Container(
              width: double.infinity,
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
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.shopping_basket_rounded,
                        color: Color(0xFF2E7D32),
                        size: 50,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'HORTASIMA FRESH',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Segar dari Petani Lokal',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // About Section
                  _buildSectionCard(
                    title: 'Tentang HORTASIMA FRESH',
                    icon: Icons.info_outline_rounded,
                    iconColor: const Color(0xFF2E7D32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'HORTASIMA FRESH adalah aplikasi marketplace yang menghubungkan petani lokal dengan konsumen di seluruh wilayah.',
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.6,
                            color: Color(0xFF666666),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Kami berkomitmen untuk menyediakan produk sayur dan buah segar berkualitas tinggi langsung dari petani dengan harga yang terjangkau.',
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.6,
                            color: Color(0xFF666666),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Features Section
                  _buildSectionCard(
                    title: 'Fitur Unggulan',
                    icon: Icons.stars_rounded,
                    iconColor: const Color(0xFFFFB400),
                    child: Column(
                      children: [
                        _buildFeatureItem(
                          icon: Icons.eco_rounded,
                          title: 'Produk Segar',
                          subtitle: 'Langsung dari petani lokal',
                        ),
                        const SizedBox(height: 12),
                        _buildFeatureItem(
                          icon: Icons.local_offer_rounded,
                          title: 'Harga Terjangkau',
                          subtitle: 'Kompetitif dan bersaing',
                        ),
                        const SizedBox(height: 12),
                        _buildFeatureItem(
                          icon: Icons.local_shipping_rounded,
                          title: 'Pengiriman Cepat',
                          subtitle: 'Ke seluruh wilayah',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // App Version
                  _buildSectionCard(
                    title: 'Informasi Aplikasi',
                    icon: Icons.app_shortcut_rounded,
                    iconColor: const Color(0xFF2196F3),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow(
                            label: 'Nama Aplikasi', value: 'HORTASIMA FRESH'),
                        const SizedBox(height: 12),
                        _buildInfoRow(label: 'Versi', value: '1.0.0'),
                        const SizedBox(height: 12),
                        _buildInfoRow(label: 'Platform', value: 'Flutter'),
                        const SizedBox(height: 12),
                        _buildInfoRow(label: 'Tahun Rilis', value: '2024'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Contact Section
                  _buildSectionCard(
                    title: 'Hubungi Kami',
                    icon: Icons.contact_mail_rounded,
                    iconColor: const Color(0xFFE91E63),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildContactItem(
                          icon: Icons.email_rounded,
                          label: 'Email',
                          value: 'info@hortasima.com',
                        ),
                        const SizedBox(height: 12),
                        _buildContactItem(
                          icon: Icons.phone_rounded,
                          label: 'Telepon',
                          value: '+62 812-3456-7890',
                        ),
                        const SizedBox(height: 12),
                        _buildContactItem(
                          icon: Icons.location_on_rounded,
                          label: 'Alamat',
                          value: 'Jl. Segar No. 123, Jakarta',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Developer Info
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue[200]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.code_rounded,
                              color: Colors.blue[700],
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Informasi Developer',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.blue[700],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'HORTASIMA FRESH dikembangkan sebagai project akademis untuk mata kuliah Mobile Programming 2 di UBSI.',
                          style: TextStyle(
                            fontSize: 13,
                            height: 1.6,
                            color: Colors.blue[900],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required Widget child,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF333333),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFFFFF3E0),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: const Color(0xFFFF9800),
            size: 22,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF999999),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow({
    required String label,
    required String value,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF999999),
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF333333),
          ),
        ),
      ],
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: const Color(0xFF2E7D32),
          size: 20,
        ),
        const SizedBox(width: 12),
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
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF333333),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
