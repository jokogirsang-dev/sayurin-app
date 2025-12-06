import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailC = TextEditingController();
  final _passwordC = TextEditingController();

  bool _loading = false;
  bool _obscurePassword = true;
  String? _error;

  @override
  void dispose() {
    _emailC.dispose();
    _passwordC.dispose();
    super.dispose();
  }

  Future<void> _doLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    final userProv = Provider.of<UserProvider>(context, listen: false);
    final ok = await userProv.login(
      email: _emailC.text.trim(),
      password: _passwordC.text,
    );

    if (!mounted) return;

    if (ok) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      setState(() {
        _error = 'Email atau password salah';
        _loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email atau password salah'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF4CAF50);
    const lightBg = Color(0xFFF5F7F2);

    // === NEW: warna oranye sebagai aksen ===
    const accentOrange = Color(0xFFFFA726);

    return Scaffold(
      backgroundColor: lightBg,
      body: Stack(
        children: [
          // Wave hijau + oranye di atas
          // === MODIF: gradient sekarang hijau -> oranye ===
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: _TopWaveClipper(),
              child: Container(
                height: 260,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF43A047), // hijau
                      accentOrange, // oranye
                    ],
                  ),
                ),
              ),
            ),
          ),

          Center(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Card(
                  elevation: 10,
                  shadowColor: Colors.black.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 22, vertical: 24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // === MODIF: header pakai icon + nuansa hijau-oranye ===
                          Align(
                            alignment: Alignment.center,
                            child: CircleAvatar(
                              radius: 32,
                              backgroundColor: primaryGreen.withOpacity(0.08),
                              child: const Icon(
                                Icons.lock_outline,
                                size: 30,
                                color: primaryGreen,
                              ),
                            ),
                          ),

                          const SizedBox(height: 14),

                          const Text(
                            'Selamat Datang',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF263238),
                            ),
                          ),

                          // === MODIF BESAR:
                          //  "Masuk untuk melanjutkan ke aplikasi" diganti
                          //  dengan LOGO aplikasi kamu + chip sayur/jeruk
                          const SizedBox(height: 10),

                          // LOGO APK (DolokFresh)
                          SizedBox(
                            height: 120,
                            width: 110,
                            child: Image.asset(
                              'assets/images/Dolokfresh.png', // <- sesuaikan path
                              fit: BoxFit.contain,
                            ),
                          ),

                          const SizedBox(height: 8),

                          // mini tag "sayur" dan "jeruk"
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _miniTag('🥦 Sayur Segar', primaryGreen),
                              _miniTag('🍊 Buah & Jeruk', accentOrange),
                            ],
                          ),

                          const SizedBox(height: 18),

                          // ================== Email ==================
                          TextFormField(
                            controller: _emailC,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              prefixIcon:
                                  const Icon(Icons.email_outlined, size: 20),
                              filled: true,
                              fillColor: lightBg,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 14),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(
                                  color: Color(0xFFB0BEC5),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(
                                  color: primaryGreen,
                                  width: 1.6,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                  width: 1.4,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                  width: 1.4,
                                ),
                              ),
                            ),
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return 'Email wajib diisi';
                              }
                              if (!v.contains('@')) {
                                return 'Format email tidak valid';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 12),

                          // ================== Password ==================
                          TextFormField(
                            controller: _passwordC,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon:
                                  const Icon(Icons.lock_outline, size: 20),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                              filled: true,
                              fillColor: lightBg,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 14),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(
                                  color: Color(0xFFB0BEC5),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(
                                  color: primaryGreen,
                                  width: 1.6,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                  width: 1.4,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                  width: 1.4,
                                ),
                              ),
                            ),
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return 'Password wajib diisi';
                              }
                              if (v.length < 4) {
                                return 'Password minimal 4 karakter';
                              }
                              return null;
                            },
                          ),

                          if (_error != null) ...[
                            const SizedBox(height: 6),
                            Text(
                              _error!,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ],

                          const SizedBox(height: 20),

                          // ================== Tombol Masuk ==================
                          SizedBox(
                            height: 46,
                            child: ElevatedButton(
                              onPressed: _loading ? null : _doLogin,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryGreen,
                                disabledBackgroundColor:
                                    primaryGreen.withOpacity(0.6),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 0,
                              ),
                              child: _loading
                                  ? const SizedBox(
                                      height: 22,
                                      width: 22,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation(
                                            Colors.white),
                                      ),
                                    )
                                  : const Text(
                                      'Masuk',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                          ),

                          const SizedBox(height: 14),

                          // ================== Link ke Register ==================
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Belum punya akun? ',
                                style: TextStyle(fontSize: 13),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacementNamed(
                                      context, '/register');
                                },
                                child: const Text(
                                  'Daftar',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: primaryGreen,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // === NEW: separator + tombol login Google/Facebook/dll ===
                          const SizedBox(height: 18),
                          Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  color: Colors.grey.shade300,
                                  thickness: 1,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  'atau masuk dengan',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  color: Colors.grey.shade300,
                                  thickness: 1,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          Row(
                            children: [
                              // Google
                              _socialButton(
                                label: 'Google',
                                icon: Icons.g_mobiledata, // placeholder icon
                                borderColor: Colors.redAccent,
                              ),
                              const SizedBox(width: 10),
                              // Facebook
                              _socialButton(
                                label: 'Facebook',
                                icon: Icons.facebook,
                                borderColor: Color(0xFF1877F2),
                              ),
                              const SizedBox(width: 10),
                              // Login lain (guest / email)
                              _socialButton(
                                label: 'Guest',
                                icon: Icons.person_outline,
                                borderColor: primaryGreen,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // === NEW: widget kecil untuk chip sayur & jeruk ===
  Widget _miniTag(String text, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.5),
          width: 0.8,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // === NEW: tombol login sosial (Google/Facebook/dll) ===
  Widget _socialButton({
    required String label,
    required IconData icon,
    required Color borderColor,
  }) {
    return Expanded(
      child: OutlinedButton.icon(
        onPressed: () {
          // TODO: sambungkan ke login sosial beneran kalau perlu
        },
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 8),
          side: BorderSide(color: borderColor.withOpacity(0.8)),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: Icon(
          icon,
          size: 18,
          color: borderColor,
        ),
        label: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: borderColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

/// Clipper buat efek wave di bagian atas
class _TopWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height * 0.65);

    final firstControlPoint = Offset(size.width * 0.25, size.height * 0.85);
    final firstEndPoint = Offset(size.width * 0.6, size.height * 0.7);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    final secondControlPoint = Offset(size.width * 0.85, size.height * 0.6);
    final secondEndPoint = Offset(size.width, size.height * 0.75);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
