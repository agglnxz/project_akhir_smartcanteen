import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'services/firestore_service.dart'; 

// Hapus baris ini setelah seeding berhasil!
bool shouldSeedData = true; 

void main() async {
  // 1. Memastikan binding diinisialisasi sebelum memanggil native code (Firebase)
  WidgetsFlutterBinding.ensureInitialized();
  
  // 2. Inisialisasi Firebase
  await Firebase.initializeApp();
  
  // 3. PANGGIL FUNGSI SEEDING
  if (shouldSeedData) {
    print("Memeriksa dan menjalankan seeding data...");
    
    // Inisialisasi Service Anda
    final firestoreService = FirestoreServiceGalang();
    
    // Panggil fungsi seeding produk
    await firestoreService.seedProductsGalang();
    
    // **SANGAT PENTING:** Ubah shouldSeedData menjadi false atau HAPUS BARIS INI
    // setelah Anda memastikan 10 produk sudah ada di Firebase Firestore.
    // Jika tidak dihapus/diubah, seeding akan berjalan setiap kali aplikasi dibuka.
    shouldSeedData = false; 
    
    print("Seeding selesai. Data sudah ada di Firestore.");
  }
  
  // 4. Jalankan Aplikasi
  runApp(const MyApp());
}

// ... (Definisi class MyApp Anda) ...
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Anggota 3 akan bertanggung jawab pada routing awal.
    return MaterialApp(
      title: 'Smart E-Kantin',
      home: Text('Loading...'), // Ganti dengan SplashScreen/LoginScreen
    );
  }
}