import 'package:flutter/material.dart';
import '../widgets/card_menu.dart';
import '../services/firestore_service.dart';
import '../models/product_model.dart';

class HomeScreen_yossy extends StatelessWidget {
  const HomeScreen_yossy({super.key});

  @override
  Widget build(BuildContext context) {
    final FirestoreServiceGalang firestoreService = FirestoreServiceGalang();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Smart E-Kantin"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, "/cart");
            },
            icon: const Icon(Icons.shopping_cart),
          )
        ],
      ),
      body: FutureBuilder<List<ProductModelGalang>>(
        future: firestoreService.getProductsGalang(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Loading indicator saat data belum siap
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
