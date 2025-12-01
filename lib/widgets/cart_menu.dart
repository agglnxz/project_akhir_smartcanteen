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

                // TAMBAHAN: Tampilkan stok produk secara real-time
                Consumer<CartProvider_inandiar>(
                  builder: (context, cartProv_inandiar, child) {
                    // Cari produk berdasarkan nama untuk dapatkan stok
                    ProductModelGalang? product;
                    cartProv_inandiar.productsData_inandiar.forEach((id, p) {
                      if (p.name == title_yossy) {
                        product = p;
                      }
                    });

                    if (product != null) {
                      return Text(
                        "Stok: ${product!.stock}",
                        style: TextStyle(
                          fontSize: 14,
                          color: product!.stock > 0 ? Colors.black : Colors.red,  // TAMBAHAN: Warna merah jika stok 0
                        ),
                      );
                    } else {
                      return const Text(
                        "Stok: Tidak tersedia",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      );
                    }
                  },
                ),
              ],
            ),
          ),

          // IKON KERANJANG HIJAU UNTUK ADD TO CART
          Consumer<CartProvider_inandiar>(
            builder: (context, cartProv_inandiar, child) {
              // TAMBAHAN: Cari produk berdasarkan nama untuk dapatkan stok dan productId
              ProductModelGalang? product;
              cartProv_inandiar.productsData_inandiar.forEach((id, p) {
                if (p.name == title_yossy) {
                  product = p;
                }
              });

              final isOutOfStock = product == null || product!.stock <= 0;  // TAMBAHAN: Cek jika stok habis

              return IconButton(
                icon: Icon(
                  Icons.add_shopping_cart,
                  color: isOutOfStock ? Colors.grey : Colors.green,  // TAMBAHAN: Warna abu jika stok habis
                  size: 28,
                ),
                onPressed: isOutOfStock  // TAMBAHAN: Nonaktifkan jika stok habis
                    ? null
                    : () {
                        // TAMBAHAN: Cari productId yang benar berdasarkan nama
                        String correctProductId = title_yossy;  // Default ke title_yossy jika tidak ditemukan
                        cartProv_inandiar.productsData_inandiar.forEach((id, p) {
                          if (p.name == title_yossy) {
                            correctProductId = id;  // Gunakan ID unik yang benar
                          }
                        });

                        cartProv_inandiar.addToCart_inandiar(
                          ProductModelGalang(
                            productId: correctProductId,  // TAMBAHAN: Gunakan productId yang benar
                            name: title_yossy,
                            price: num.parse(price_yossy),
                            imageUrl: image_yossy,
                            stock: product?.stock ?? 0,  // TAMBAHAN: Sertakan stok
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