import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';  // TAMBAHAN: Import firebase_options

// Provider
import 'package:provider/provider.dart';
import 'providers/cart_provider.dart';

// Services
import 'services/firestore_service.dart';  // TAMBAHAN: Untuk seed produk

// Screens
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/cart_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,  // TAMBAHAN: Gunakan firebase_options untuk koneksi benar
  );

final firestoreService = FirestoreServiceGalang();
await firestoreService.seedProductsGalang();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider_inandiar()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart E-Kantin',
      theme: ThemeData(
        fontFamily: 'Poppins',
        primarySwatch: Colors.blue,
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