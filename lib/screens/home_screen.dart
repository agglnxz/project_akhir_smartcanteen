import 'package:flutter/material.dart';
import '../widgets/card_menu.dart';
import '../services/firestore_service.dart';
import '../models/product_model.dart';
import '../models/user_model.dart';

// Auth login/logout
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/login_screen.dart';

class HomeScreen_yossy extends StatelessWidget {
  final UserModelGalang? profile;
  const HomeScreen_yossy({super.key, this.profile});

  @override
  Widget build(BuildContext context) {
    final FirestoreServiceGalang firestoreService = FirestoreServiceGalang();
    final FirebaseAuth auth = FirebaseAuth.instance;

    void logout() async {
      await auth.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen_yossy()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Smart E-Kantin"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, "/cart");
            },
            icon: const Icon(Icons.shopping_cart),
          ),

          // tombol logout
          IconButton(
            onPressed: logout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: FutureBuilder<List<ProductModelGalang>>(
        future: firestoreService.getProductsGalang(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Belum ada produk tersedia'));
          }

          final products = snapshot.data!;

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: products.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final product = products[index];
              return CardMenu_yossy(
                title_yossy: product.name,
                price_yossy: product.price.toString(),
                image_yossy: product.imageUrl,
              );
            },
          );
        },
      ),
    );
  }
}
