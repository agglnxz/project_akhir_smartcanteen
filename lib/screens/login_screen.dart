import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'register_screen.dart';
import '../controllers/auth_controller.dart';
import '../services/firestore_service.dart';
import '../models/user_model.dart';

class LoginScreen_yossy extends StatefulWidget {
  const LoginScreen_yossy({super.key});
  @override
  State<LoginScreen_yossy> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen_yossy> {
  final AuthControllerFirman _authController = AuthControllerFirman();
  final FirestoreServiceGalang _firestore = FirestoreServiceGalang();
  final TextEditingController _emailC = TextEditingController();
  final TextEditingController _passC = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailC.dispose();
    _passC.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      final user = await _authController.loginUser(email: _emailC.text, password: _passC.text);
      if (user == null) throw Exception('Login gagal - tidak mendapat user dari Auth.');

      // Ambil profile dari Firestore (docId = uid)
      final UserModelGalang? profile = await _firestore.getUserByUid(user.uid);

      if (profile == null) {
        // Profil belum ada di Firestore — tetap bisa login, tapi beri peringatan
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Login berhasil, tetapi profil belum lengkap.'), backgroundColor: Colors.orange));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Login berhasil!')));
      }

      if (!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen_yossy(profile: profile)));
    } on Exception catch (e) {
      final message = e.toString().replaceFirst('Exception: ', '');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/logo.jpg", height: 120),
            const SizedBox(height: 20),
            TextField(controller: _emailC, decoration: const InputDecoration(labelText: 'Email (...@poliwangi.ac.id)', border: OutlineInputBorder()), keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 12),
            TextField(controller: _passC, decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder()), obscureText: true),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _isLoading ? null : _handleLogin, child: _isLoading ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Text('Login')),
            const SizedBox(height: 12),
            TextButton(onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const RegisterScreen_yossy())), child: const Text('Belum punya akun? Register'))
          ],
        ),
      ),
    );
  }
}
