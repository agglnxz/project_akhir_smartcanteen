import 'package:flutter/material.dart';

// Ganti _AP dengan inisial nama asli Anda
class LoadingIndicatorGalang extends StatelessWidget {
  final double? size;
  final Color?  color;
  const LoadingIndicatorGalang({
    super.key,
    this.size,
    this.color,
    });

  @override
  Widget build(BuildContext context) {
    return  Center(
      child:SizedBox(
        height: size,
        width: size,
      child: CircularProgressIndicator(
        // Opsional: Sesuaikan warna dengan tema aplikasi
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(
          color?? Colors.blue),
      ),
      ),
    );
  }
}