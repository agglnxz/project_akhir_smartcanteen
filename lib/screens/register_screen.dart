import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import 'login_screen.dart';

class RegisterScreen_yossy extends StatefulWidget {
  const RegisterScreen_yossy({super.key});
  @override
  State<RegisterScreen_yossy> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen_yossy> {
  final AuthControllerFirman _authController = AuthControllerFirman();
  final TextEditingController _nameC = TextEditingController();
  final TextEditingController _idC = TextEditingController();
  final TextEditingController _emailC = TextEditingController();
  final TextEditingController _passC = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameC.dispose();
    _idC.dispose();
    _emailC.dispose();
    _passC.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      await _authController.registerUser(
        email: _emailC.text,
        password: _passC.text,
        fullName: _nameC.text,
        userIdFromInput: _idC.text,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Registrasi berhasil. Silakan login.')));
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen_yossy()));
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
      appBar: AppBar(title: const Text('Register')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Image.asset("assets/images/logo.jpg", height: 120),
            const SizedBox(height: 20),
            TextField(controller: _nameC, decoration: const InputDecoration(labelText: 'Nama Lengkap', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: _idC, decoration: const InputDecoration(labelText: 'NIM', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: _emailC, decoration: const InputDecoration(labelText: 'Email (...@poliwangi.ac.id)', border: OutlineInputBorder()), keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 12),
            TextField(controller: _passC, decoration: const InputDecoration(labelText: 'Password (min 6)', border: OutlineInputBorder()), obscureText: true),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _handleRegister,
              child: _isLoading ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Text('Daftar'),
            ),
            const SizedBox(height: 12),
            TextButton(onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen_yossy())), child: const Text('Sudah punya akun? Login'))
          ],
        ),
      ),
    );
  }
}
