import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'services/firestore_service.dart';

import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/cart_screen.dart';

// Hapus baris ini setelah seeding berhasil!
bool shouldSeedData = true; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  if (shouldSeedData) {
    print("Memeriksa dan menjalankan seeding data...");
    final firestoreService = FirestoreServiceGalang();
    await firestoreService.seedProductsGalang();
    shouldSeedData = false; 
    print("Seeding selesai. Data sudah ada di Firestore.");
  }

  runApp(const MyApp());
}

// ... (Definisi class MyApp Anda) ...
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Routing utama digabung di sini
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart E-Kantin',
      theme: ThemeData(
        fontFamily: 'Poppins',
      ),
      initialRoute: '/login',
      routes: {
        '/login': (_) => const LoginScreen_yossy(),
        '/register': (_) => const RegisterScreen_yossy(),
        '/home': (_) => const HomeScreen_yossy(),
        '/cart': (_) => const CartScreen_yossy(),
      },
    );
  }
}
