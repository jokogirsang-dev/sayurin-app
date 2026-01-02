import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../widget/custom_buttons.dart';
import '../widget/custom_text_fields.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameC = TextEditingController();
  final _emailC = TextEditingController();
  final _phoneC = TextEditingController();
  final _passwordC = TextEditingController();
  final _confirmPasswordC = TextEditingController();

  bool _loading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeTerms = false;
  String? _error;

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 1);
  }

  @override
  void dispose() {
    _nameC.dispose();
    _emailC.dispose();
    _phoneC.dispose();
    _passwordC.dispose();
    _confirmPasswordC.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _doRegister() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_agreeTerms) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Anda harus menyetujui Syarat & Ketentuan'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final userProv = Provider.of<UserProvider>(context, listen: false);
      final ok = await userProv.register(
        name: _nameC.text.trim(),
        email: _emailC.text.trim(),
        password: _passwordC.text,
      );

      if (!mounted) return;

      if (ok) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registrasi berhasil! Silakan login'),
            backgroundColor: Color(0xFF2E7D32),
          ),
        );
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        setState(() {
          _error = 'Registrasi gagal. Email mungkin sudah terdaftar';
          _loading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Terjadi kesalahan: $e';
        _loading = false;
      });
    }
  }

  void _registerWithGoogle() {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Daftar dengan Google akan segera tersedia'),
        backgroundColor: Color(0xFFDB4437),
      ),
    );
  }

  void _registerWithFacebook() {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Daftar dengan Facebook akan segera tersedia'),
        backgroundColor: Color(0xFF1877F2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Stack(
        children: [
          _buildHeader(),
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  _buildLogo(),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: _buildRegisterCard(),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 280,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF2E7D32),
            Color(0xFF43A047),
            Color(0xFFFF6F00),
          ],
        ),
      ),
      child: CustomPaint(
        painter: _WavePainter(),
      ),
    );
  }

  Widget _buildLogo() {
    return Column(
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
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipOval(
            child: Image.asset(
              'assets/images/Dolokfresh.png',
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.shopping_basket_rounded,
                  size: 50,
                  color: Color(0xFF2E7D32),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'HORTASIMA FRESH',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildTabBar(),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: _buildRegisterForm(),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF5F5F5),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        indicatorColor: const Color(0xFF2E7D32),
        indicatorWeight: 3,
        labelColor: const Color(0xFF2E7D32),
        unselectedLabelColor: Colors.grey,
        labelStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/login');
          }
        },
        tabs: const [
          Tab(text: 'Masuk'),
          Tab(text: 'Daftar'),
        ],
      ),
    );
  }

  Widget _buildRegisterForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),
          const Text(
            'Daftar Akun',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1B5E20),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Buat akun baru untuk mulai belanja sayur segar',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          CustomTextField(
            label: 'Nama Lengkap',
            hintText: 'Masukkan nama lengkap Anda',
            controller: _nameC,
            prefixIcon: Icons.person_outline,
            textInputAction: TextInputAction.next,
            validator: (v) {
              if (v == null || v.trim().isEmpty)
                return 'Nama lengkap wajib diisi';
              if (v.trim().length < 3) return 'Nama minimal 3 karakter';
              return null;
            },
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: 'Email',
            hintText: 'Masukkan email Anda',
            controller: _emailC,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icons.email_outlined,
            textInputAction: TextInputAction.next,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Email wajib diisi';
              if (!v.contains('@')) return 'Format email tidak valid';
              return null;
            },
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: 'Nomor HP / WhatsApp',
            hintText: 'Masukkan nomor HP Anda',
            controller: _phoneC,
            keyboardType: TextInputType.phone,
            prefixIcon: Icons.phone_outlined,
            textInputAction: TextInputAction.next,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Nomor HP wajib diisi';
              if (v.trim().length < 10) return 'Nomor HP minimal 10 digit';
              return null;
            },
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: 'Password',
            hintText: 'Masukkan password Anda',
            controller: _passwordC,
            obscureText: _obscurePassword,
            prefixIcon: Icons.lock_outline,
            suffixIcon: _obscurePassword
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            onSuffixIconTapped: () =>
                setState(() => _obscurePassword = !_obscurePassword),
            textInputAction: TextInputAction.next,
            validator: (v) {
              if (v == null || v.isEmpty) return 'Password wajib diisi';
              if (v.length < 6) return 'Password minimal 6 karakter';
              return null;
            },
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: 'Konfirmasi Password',
            hintText: 'Konfirmasi password Anda',
            controller: _confirmPasswordC,
            obscureText: _obscureConfirmPassword,
            prefixIcon: Icons.lock_outline,
            suffixIcon: _obscureConfirmPassword
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            onSuffixIconTapped: () => setState(
                () => _obscureConfirmPassword = !_obscureConfirmPassword),
            textInputAction: TextInputAction.done,
            validator: (v) {
              if (v == null || v.isEmpty)
                return 'Konfirmasi password wajib diisi';
              if (v != _passwordC.text) return 'Password tidak cocok';
              return null;
            },
          ),
          const SizedBox(height: 16),
          _buildTermsCheckbox(),
          if (_error != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red[200]!),
              ),
              child: Text(
                _error!,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
          const SizedBox(height: 24),
          PrimaryButton(
            text: 'Daftar',
            onPressed: _doRegister,
            isLoading: _loading,
            height: 52,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Sudah punya akun? ',
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
              GestureDetector(
                onTap: () => Navigator.pushReplacementNamed(context, '/login'),
                child: const Text(
                  'Masuk',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2E7D32),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildDivider(),
          const SizedBox(height: 16),
          _buildSocialButtons(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildTermsCheckbox() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: _agreeTerms,
            onChanged: (value) => setState(() => _agreeTerms = value ?? false),
            activeColor: const Color(0xFF2E7D32),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _agreeTerms = !_agreeTerms),
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                    fontSize: 12, color: Colors.grey[700], height: 1.4),
                children: const [
                  TextSpan(text: 'Dengan mendaftar, Anda menyetujui '),
                  TextSpan(
                    text: 'Syarat & Ketentuan',
                    style: TextStyle(
                        color: Color(0xFF2E7D32), fontWeight: FontWeight.w700),
                  ),
                  TextSpan(text: ' serta '),
                  TextSpan(
                    text: 'Kebijakan Privasi',
                    style: TextStyle(
                        color: Color(0xFF2E7D32), fontWeight: FontWeight.w700),
                  ),
                  TextSpan(text: ' HORTASIMA FRESH'),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey[300], thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Text(
            'atau daftar dengan',
            style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500),
          ),
        ),
        Expanded(child: Divider(color: Colors.grey[300], thickness: 1)),
      ],
    );
  }

  Widget _buildSocialButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSocialButton(
          onTap: _registerWithGoogle,
          icon: 'G',
          backgroundColor: Colors.white,
          borderColor: const Color(0xFFDB4437),
          textColor: const Color(0xFFDB4437),
        ),
        const SizedBox(width: 16),
        _buildSocialButton(
          onTap: _registerWithFacebook,
          icon: 'f',
          backgroundColor: const Color(0xFF1877F2),
          borderColor: const Color(0xFF1877F2),
          textColor: Colors.white,
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required VoidCallback onTap,
    required String icon,
    required Color backgroundColor,
    required Color borderColor,
    required Color textColor,
  }) {
    return InkWell(
      onTap: _loading ? null : onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
          border: Border.all(color: borderColor, width: 2),
          boxShadow: [
            BoxShadow(
              color: borderColor.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            icon,
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.w700, color: textColor),
          ),
        ),
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height * 0.7);
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.85,
      size.width * 0.5,
      size.height * 0.75,
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.65,
      size.width,
      size.height * 0.8,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
