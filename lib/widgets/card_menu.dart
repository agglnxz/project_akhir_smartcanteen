import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../models/product_model.dart';

class CardMenu_yossy extends StatelessWidget {
  final String title_yossy;
  final String price_yossy;
  final String image_yossy;

  const CardMenu_yossy({
    super.key,
    required this.title_yossy,
    required this.price_yossy,
    required this.image_yossy,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // GAMBAR
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              image_yossy,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(width: 12),

          // NAMA & HARGA
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title_yossy,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  "Rp $price_yossy",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),

          // IKON KERANJANG HIJAU UNTUK ADD TO CART
          Consumer<CartProvider_inandiar>(
            builder: (context, cartProv_inandiar, child) {
              return IconButton(
                icon: const Icon(
                  Icons.add_shopping_cart,   // icon beda dari checkout
                  color: Colors.green,        // warna hijau
                  size: 28,
                ),
                onPressed: () {
                  // TAMBAHAN: Cari productId yang benar berdasarkan nama (title_yossy) dari productsData_inandiar
                  // Ini memastikan productId unik (misalnya "P001") digunakan, bukan nama produk
                  String correctProductId = title_yossy;  // Default ke title_yossy jika tidak ditemukan
                  cartProv_inandiar.productsData_inandiar.forEach((id, product) {
                    if (product.name == title_yossy) {
                      correctProductId = id;  // Gunakan ID unik yang benar
                    }
                  });

                  cartProv_inandiar.addToCart_inandiar(
                    ProductModelGalang(
                      productId: correctProductId,  // TAMBAHAN: Gunakan productId yang benar
                      name: title_yossy,
                      price: num.parse(price_yossy),
                      imageUrl: image_yossy,
                      stock: 1,
                    ),
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Ditambahkan ke keranjang"),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}