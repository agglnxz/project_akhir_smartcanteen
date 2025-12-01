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
        title: const Text("Smart Canteen",
         style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromRGBO(133, 14, 53, 1),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, "/cart", arguments: profile);
            },
            icon: const Icon(Icons.shopping_cart),
            style: IconButton.styleFrom(
            foregroundColor: Colors.white,
          ),

          ),

          // tombol logout
          IconButton(
            onPressed: logout,
            icon: const Icon(Icons.logout),
            style: IconButton.styleFrom(
            foregroundColor: Colors.white,
            ),
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

          return GridView.builder(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            itemCount: products.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,          // 2 kolom
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.88,     // proporsi tinggi/width
            ),
            itemBuilder: (context, index) {
              final product_yossy = products[index];
              return CardMenu_yossy(
                title_yossy: product_yossy.name,
                price_yossy: product_yossy.price.toString(),
                image_yossy: product_yossy.imageUrl,
              );
            },
          );
        },
      ),
    );
  }
}