import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../services/firestore_service.dart';
import '../models/product_model.dart';

class CheckoutScreen_inandiar extends StatelessWidget {
  final String nim_inandiar;
  final Map<String, ProductModelGalang> products_inandiar;

  const CheckoutScreen_inandiar({
    super.key,
    required this.nim_inandiar,
    required this.products_inandiar,
  });

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider_inandiar>(context);
    final service = FirestoreServiceGalang();

    final subtotal = cart.totalPrice_inandiar();
    final finalTotal = cart.applyNimLogic_inandiar(subtotal, nim_inandiar);

    // Hitung potongan
    num potongan = subtotal - finalTotal;

    return Scaffold(
      appBar: AppBar(title: const Text("Checkout")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ============================
            /// LIST PRODUK DALAM CHECKOUT
            /// ============================
            const Text(
              "Produk Dibeli",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            Expanded(
              child: ListView(
                children: cart.cart_inandiar.entries.map((item) {
                  final product = products_inandiar[item.key]!;
                  final qty = item.value;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      leading: Image.network(
                        product.imageUrl,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Text(product.name),
                      subtitle: Text("Harga: ${product.price} x $qty"),
                      trailing: Text("Rp ${product.price * qty}"),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 20),

            /// ============================
            /// RANGKUMAN HARGA
            /// ============================
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Subtotal: Rp $subtotal",
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  "Potongan: -Rp $potongan",
                  style: const TextStyle(fontSize: 16, color: Colors.green),
                ),
                Text(
                  "Total Bayar: Rp $finalTotal",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// ============================
            /// TOMBOL BAYAR
            /// ============================
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final items = cart.cart_inandiar.entries.map((e) {
                    final p = products_inandiar[e.key]!;
                    return {
                      "product_id": p.productId,
                      "name": p.name,
                      "price": p.price,
                      "qty": e.value,
                    };
                  }).toList();

                  await service.createTransaction_inandiar(
                    trxId: DateTime.now().millisecondsSinceEpoch.toString(),
                    finalTotal: finalTotal,
                    items: items,
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Pembelian Berhasil!")),
                  );
                },
                child: const Text("Bayar Sekarang"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
