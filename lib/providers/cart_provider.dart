import 'package:flutter/material.dart';
import '../models/product_model.dart';

class CartProvider_inandiar extends ChangeNotifier {
  final Map<String, int> cart_inandiar = {};
  Map<String, ProductModelGalang> productsData_inandiar =
      {}; // TAMBAHAN: Untuk akses data produk di CartScreen

  // SET DATA PRODUK (Panggil dari HomeScreen saat load produk)
  void setProductsData_inandiar(Map<String, ProductModelGalang> data_inandiar) {
    productsData_inandiar = data_inandiar;
    notifyListeners();
  }

  // ADD TO CART
  void addToCart_inandiar(ProductModelGalang product_inandiar) {
    cart_inandiar[product_inandiar.productId] =
        (cart_inandiar[product_inandiar.productId] ?? 0) + 1;
    notifyListeners();
  }

  // REMOVE FROM CART
  void removeFromCart_inandiar(String id_inandiar) {
    if (!cart_inandiar.containsKey(id_inandiar)) return;
    cart_inandiar[id_inandiar] = cart_inandiar[id_inandiar]! - 1;

    if (cart_inandiar[id_inandiar]! <= 0) {
      cart_inandiar.remove(id_inandiar);
    }
    notifyListeners();
  }

  // TOTAL HARGA SEBELUM DISKON/ONGKIR
  num totalPrice_inandiar() {
    num total_inandiar = 0;
    cart_inandiar.forEach((id_inandiar, qty_inandiar) {
      final product_inandiar = productsData_inandiar[id_inandiar];
      if (product_inandiar != null) {
        total_inandiar += product_inandiar.price * qty_inandiar;
      }
    });
    return total_inandiar;
  }

  num applyNimLogic_inandiar(num total_inandiar, String nim_inandiar) {
    final nimTrim_inandiar = (nim_inandiar ?? '').trim();

    // Ambil digit terakhir dari NIM yang valid (jika ada)
    // Gunakan regex untuk mengumpulkan digit, lalu ambil digit terakhir jika ada
    final digitMatches = RegExp(r'\d').allMatches(nimTrim_inandiar);
    int lastDigit_inandiar = 0;
    // Treat some known dummy fallbacks as "no valid NIM" (e.g., default placeholder)
    final invalidFallbacks = {'', '12345', '000000'};
    if (invalidFallbacks.contains(nimTrim_inandiar)) {
      // No valid NIM provided -> no discount / no special logic
      print(
        'DEBUG applyNimLogic_inandiar → no valid NIM provided ($nimTrim_inandiar)',
      );
      return total_inandiar;
    }
    if (digitMatches.isNotEmpty) {
      final lastMatch = digitMatches.last;
      lastDigit_inandiar = int.parse(
        nimTrim_inandiar.substring(lastMatch.start, lastMatch.end),
      );
    }
    // DEBUG — show extracted info
    final allDigits = digitMatches
        .map((m) => nimTrim_inandiar.substring(m.start, m.end))
        .join('');
    print(
      "DEBUG applyNimLogic_inandiar → NIM: $nimTrim_inandiar, Digits: $allDigits, Last Digit: $lastDigit_inandiar, Total: $total_inandiar",
    );

    const num ongkir_inandiar =
        5000; // tarif ongkir tetap (tidak dipakai untuk final calculation)
    if (lastDigit_inandiar % 2 == 1) {
      // Ganjil → diskon 5% pada subtotal, tanpa menambahkan ongkir
      final discounted = total_inandiar - (total_inandiar * 0.05);
      return discounted < 0 ? 0 : discounted;
    } else {
      // Genap → tidak ada diskon dan tidak menambahkan ongkir (tetap total sama)
      final finalTotal = total_inandiar;
      return finalTotal < 0 ? 0 : finalTotal;
    }
  }

  // PENAMBAHAN FUNGSI PENDUKUNG: Untuk mengakses data keranjang dengan lebih aman
  Map<String, int> get cartItems_inandiar {
    return Map.unmodifiable(cart_inandiar);
  }

  // PENAMBAHAN FUNGSI PENDUKUNG: Untuk menghapus semua item saat checkout (dianjurkan)
  void clearCart_inandiar() {
    cart_inandiar.clear();
    notifyListeners();
  }

  // ==========================
  // TRANSAKSI / CHECKOUT
  // ==========================
  num checkout_inandiar(String nim_inandiar) {
    // Ambil total harga sebelum diskon
    num total_inandiar = totalPrice_inandiar();

    // Terapkan logika NIM (diskon atau gratis ongkir)
    num finalTotal_inandiar = applyNimLogic_inandiar(
      total_inandiar,
      nim_inandiar,
    );

    // Hapus keranjang setelah checkout
    clearCart_inandiar();

    print(
      "DEBUG checkout_inandiar → NIM: $nim_inandiar, Total sebelum diskon: $total_inandiar, Total akhir: $finalTotal_inandiar",
    );

    return finalTotal_inandiar;
  }
}
