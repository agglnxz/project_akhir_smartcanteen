import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../models/product_model.dart';
import '../services/firestore_service.dart';
import '../models/user_model.dart'; // TAMBAHAN: Untuk profile (jika perlu)

class CartScreen_yossy extends StatelessWidget {
  final UserModelGalang? profile; // TAMBAHAN: Tambahkan profile sebagai parameter untuk NIM
  const CartScreen_yossy({super.key, this.profile});

  @override
  Widget build(BuildContext context_inandiar) {
    final cartProv_inandiar = Provider.of<CartProvider_inandiar>(context_inandiar);
    final totalBefore_inandiar = cartProv_inandiar.totalPrice_inandiar();
    // Ambil NIM dari profile.userId (asumsikan userId adalah NIM)
    final nim_inandiar = profile?.userId ?? ""; // Fallback jika null (kosong -> no nim)
    final finalTotal_inandiar = cartProv_inandiar.applyNimLogic_inandiar(
      totalBefore_inandiar,
      nim_inandiar.trim(),
    );

    return Scaffold(
      appBar: AppBar(title: const Text("Keranjang")),
      body: cartProv_inandiar.cart_inandiar.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.shopping_cart, size: 80),
                  SizedBox(height: 20),
                  Text("Keranjang masih kosong"),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView(
                    children: cartProv_inandiar.cart_inandiar.keys.map((id_inandiar) {
                      final qty_inandiar = cartProv_inandiar.cart_inandiar[id_inandiar]!;
                      final product_inandiar = cartProv_inandiar.productsData_inandiar[id_inandiar];
                      if (product_inandiar == null) return SizedBox.shrink(); // Safety check

                      final subtotal_inandiar = product_inandiar.price * qty_inandiar;

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              product_inandiar.imageUrl,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(product_inandiar.name),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Harga: Rp ${product_inandiar.price}"),
                              Text("Qty: $qty_inandiar"),
                              Text("Subtotal: Rp $subtotal_inandiar"),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.add, color: Colors.green),
                                onPressed: () {
                                  cartProv_inandiar.addToCart_inandiar(product_inandiar);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.remove, color: Colors.red),
                                onPressed: () {
                                  cartProv_inandiar.removeFromCart_inandiar(id_inandiar);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                // Tampilan Total Harga Real-Time
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.grey[200],
                  child: Column(
                    children: [
                      Text("Total Sebelum Diskon/Ongkir: Rp $totalBefore_inandiar"),
                      Text("Total Akhir (dengan Logic NIM): Rp $finalTotal_inandiar"),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () async {
                          // Ambil NIM dari profile.userId
                          final nimUser = profile?.userId ?? "";

                          // Hitung total akhir dengan diskon/logika NIM dan kosongkan keranjang
                          final totalAkhir = cartProv_inandiar.checkout_inandiar(nimUser);

                          // Siapkan item untuk disimpan di Firestore (ambil dari cartItems_inandiar sebelum clearCart_inandiar)
                          final items = cartProv_inandiar.cartItems_inandiar.entries.map((entry) {
                            final product = cartProv_inandiar.productsData_inandiar[entry.key];
                            return {
                              "product_id": entry.key,
                              "name": product?.name ?? "Unknown",
                              "qty": entry.value,
                              "price": product?.price ?? 0,
                            };
                          }).toList();

                          final firestoreService = FirestoreServiceGalang();
                          final trxId = DateTime.now().millisecondsSinceEpoch.toString(); // TrxId unik

                          try {
                            // TAMBAHAN: Kurangi stok produk satu per satu SEBELUM menyimpan transaksi
                            for (var item in items) {
                              final productId = item['product_id'] as String;
                              final qty = item['qty'] as int;
                              await firestoreService.updateProductStock_inandiar(productId, qty);
                            }

                            // Simpan transaksi ke Firestore
                            await firestoreService.createTransaction_inandiar(
                              trxId: trxId,
                              finalTotal: finalTotal_inandiar,
                              items: items,
                            );

                            // Tampilkan receipt
                            showDialog(
                              context: context_inandiar,
                              builder: (BuildContext dialogContext) {
                                return AlertDialog(
                                  title: const Text("Receipt Pembelian"),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        ...items.map(
                                          (item) => Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 4),
                                            child: Text(
                                              "${item['name']} (jumlah: ${item['qty']}) - Rp ${(item['price'] as num) * (item['qty'] as num)}",
                                            ),
                                          ),
                                        ),
                                        const Divider(),
                                        Text("Total Akhir (Jumlah Dibelanjakan): Rp $totalAkhir"),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(dialogContext).pop();
                                        ScaffoldMessenger.of(context_inandiar).showSnackBar(
                                          const SnackBar(
                                            content: Text("Checkout berhasil, keranjang sudah dikosongkan"),
                                          ),
                                        );
                                        Navigator.pop(context_inandiar);
                                      },
                                      child: const Text("OK"),
                                    ),
                                  ],
                                );
                              },
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context_inandiar).showSnackBar(
                              SnackBar(content: Text("Checkout gagal: $e")),
                            );
                          }
                        },
                        child: const Text("Checkout"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}