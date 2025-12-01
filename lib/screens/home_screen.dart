import 'package:flutter/material.dart';
import 'package:provider/provider.dart';  // TAMBAHAN: Jika belum ada
import '../widgets/cart_menu.dart';
import '../services/firestore_service.dart';
import '../models/product_model.dart';
import '../models/user_model.dart';
import '../providers/cart_provider.dart'; 
import '../widgets/loading_indicator.dart';

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
              Navigator.pushNamed(context, "/cart", arguments: profile);
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
            return const LoadingIndicatorGalang();
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Belum ada produk tersedia'));
          }

          final products = snapshot.data!;

          // TAMBAHAN: Set data produk ke CartProvider setelah fetch berhasil
          // Ini memungkinkan CartScreen mengakses data produk untuk menampilkan gambar, nama, dll.
          final productsMap_inandiar = {for (var p in products) p.productId: p};
          Provider.of<CartProvider_inandiar>(context, listen: false).setProductsData_inandiar(productsMap_inandiar);

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