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
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color.fromRGBO(252, 245, 238, 1),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [

          /// ====== ISI CARD ======
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: Image.asset(
                  image_yossy,
                  height: 100,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              // ===== KOTAK PUTIH (TINGGI AUTO, TANPA OVERFLOW) =====
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title_yossy,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Rp $price_yossy",
                      style: const TextStyle(
                        color: Color.fromRGBO(133, 14, 53, 1),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),

                    // ==== STOK ====
                    Consumer<CartProvider_inandiar>(
                      builder: (context, cartProv_inandiar, child) {
                        ProductModelGalang? product;
                        cartProv_inandiar.productsData_inandiar.forEach((id, p) {
                          if (p.name == title_yossy) product = p;
                        });

                        if (product != null) {
                          return Text(
                            "Stok: ${product!.stock}",
                            style: TextStyle(
                              fontSize: 14,
                              color: product!.stock > 0 ? Colors.black : Colors.red,
                            ),
                          );
                        }
                        return const Text(
                          "Stok: Tidak tersedia",
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),

          /// ===== ICON KERANJANG DI POJOK KANAN ATAS =====
          Positioned(
            bottom : 8,
            right: 8,
            child: Consumer<CartProvider_inandiar>(
              builder: (context, cartProv_inandiar, child) {
                ProductModelGalang? product;
                cartProv_inandiar.productsData_inandiar.forEach((id, p) {
                  if (p.name == title_yossy) product = p;
                });

                final isOutOfStock = product == null || product!.stock <= 0;

                return Container(
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(133, 14, 53, 1),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.add_shopping_cart,
                      color: isOutOfStock ? Colors.grey : Colors.white,
                      size: 24,
                    ),
                    onPressed: isOutOfStock
                        ? null
                        : () {
                            String correctProductId = title_yossy;
                            cartProv_inandiar.productsData_inandiar.forEach((id, p) {
                              if (p.name == title_yossy) correctProductId = id;
                            });

                            cartProv_inandiar.addToCart_inandiar(
                              ProductModelGalang(
                                productId: correctProductId,
                                name: title_yossy,
                                price: num.parse(price_yossy),
                                imageUrl: image_yossy,
                                stock: product?.stock ?? 0,
                              ),
                            );

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Ditambahkan ke keranjang"),
                              ),
                            );
                          },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
