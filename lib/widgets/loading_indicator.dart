import 'package:flutter/material.dart';

// Ganti _AP dengan inisial nama asli Anda
class LoadingIndicatorGalang extends StatelessWidget {
  const LoadingIndicatorGalang({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        // Opsional: Sesuaikan warna dengan tema aplikasi
        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
      ),
    );
  }
}