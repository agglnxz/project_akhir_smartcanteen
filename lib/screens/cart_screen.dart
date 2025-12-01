import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../models/product_model.dart';
import '../services/firestore_service.dart';
import '../models/user_model.dart';

class CartScreen_yossy extends StatefulWidget {
  final UserModelGalang? profile;
  const CartScreen_yossy({super.key, this.profile});

  @override
  State<CartScreen_yossy> createState() => _CartScreen_yossyState();
}

class _CartScreen_yossyState extends State<CartScreen_yossy> {
  final TextEditingController nimController_inandiar = TextEditingController();

  @override
  Widget build(BuildContext context_inandiar) {
    final cartProv_inandiar = Provider.of<CartProvider_inandiar>(context_inandiar);

    final totalBefore_inandiar = cartProv_inandiar.totalPrice_inandiar();
    final nim_inandiar = nimController_inandiar.text.trim();
    final finalTotalPreview_inandiar =
        cartProv_inandiar.applyNimLogic_inandiar(totalBefore_inandiar, nim_inandiar);

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
                      final product_inandiar =
                          cartProv_inandiar.productsData_inandiar[id_inandiar];
                      if (product_inandiar == null) return const SizedBox.shrink();

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

                // ================================
                // BAGIAN TOTAL + NIM + CHECKOUT
                // ================================
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.grey[200],
                  child: Column(
                    children: [
                      // ----------------------------
                      // INPUT NIM
                      // ----------------------------
                      TextField(
                        controller: nimController_inandiar,
                        decoration: InputDecoration(
                          labelText: "Masukkan NIM untuk identifikasi promo",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onChanged: (_) {
                          setState(() {});
                        },
                      ),

                      const SizedBox(height: 16),

                      Text("Total Sebelum Diskon/Ongkir: Rp $totalBefore_inandiar"),
                      Text("Total Akhir: Rp $finalTotalPreview_inandiar"),
                      Text(cartProv_inandiar.promoDescription_inandiar),

                      const SizedBox(height: 10),

                      ElevatedButton(
                        onPressed: () async {
                          final nimUser = nimController_inandiar.text.trim();
                          if (nimUser.isEmpty) {
                            ScaffoldMessenger.of(context_inandiar).showSnackBar(
                              const SnackBar(content: Text("Masukkan NIM terlebih dahulu")),
                            );
                            return;
                          }

                          // simpan item sebelum cart kosong
                          final items =
                              cartProv_inandiar.cartItems_inandiar.entries.map((entry) {
                            final product =
                                cartProv_inandiar.productsData_inandiar[entry.key];
                            return {
                              "product_id": entry.key,
                              "name": product?.name ?? "Unknown",
                              "qty": entry.value,
                              "price": product?.price ?? 0,
                            };
                          }).toList();

                          final totalAkhir =
                              await cartProv_inandiar.checkout_inandiar(nimUser);

                          final firestoreService = FirestoreServiceGalang();
                          final trxId = DateTime.now().millisecondsSinceEpoch.toString();

                          try {
                            await firestoreService.createTransaction_inandiar(
                              trxId: trxId,
                              finalTotal: totalAkhir,
                              items: items,
                            );

                            // ============================
                            // TAMPAILAN DIALOG CHECKOUT
                            // ============================
                            showDialog(
                              context: context_inandiar,
                              builder: (BuildContext dialogContext) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16)),
                                  title: const Text(
                                    "Detail Transaksi",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold, fontSize: 18),
                                  ),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        ...items.map(
                                          (item) {
                                            final subtotal = (item['price'] as num) *
                                                (item['qty'] as num);
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(vertical: 4),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                        "${item['name']} (x${item['qty']})"),
                                                  ),
                                                  Text("Rp $subtotal"),
                                                ],
                                              ),
                                            );
                                          },
                                        ),

                                        const Divider(),

                                        // ============================
                                        // DISKON ATAU GRATIS ONGKIR
                                        // ============================
                                        if (cartProv_inandiar.shippingCost_inandiar == 0)
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: const [
                                              Text("Gratis Ongkir"),
                                              Text("Rp 0"),
                                            ],
                                          ),

                                        if (cartProv_inandiar.shippingCost_inandiar > 0)
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text("Diskon 5%"),
                                              Text(
                                                "-Rp ${(totalBefore_inandiar * 0.05).toInt()}",
                                              ),
                                            ],
                                          ),

                                        const Divider(),

                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              "Total Bayar",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              "Rp $totalAkhir",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(dialogContext).pop();
                                        Navigator.pop(context_inandiar);
                                      },
                                      child: const Text("Kembali ke Home"),
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
