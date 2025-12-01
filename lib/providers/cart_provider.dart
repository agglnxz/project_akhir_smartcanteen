import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/firestore_service.dart';

class CartProvider_inandiar extends ChangeNotifier {
  final Map<String, int> cart_inandiar = {};
  Map<String, ProductModelGalang> productsData_inandiar = {};

  num _shippingCost_inandiar = 0;
  num _finalPrice_inandiar = 0;
  String _promoDescription_inandiar = '';

  void setProductsData_inandiar(Map<String, ProductModelGalang> data_inandiar) {
    productsData_inandiar = data_inandiar;
    notifyListeners();
  }

  void addToCart_inandiar(ProductModelGalang product_inandiar) {
    final currentQty = cart_inandiar[product_inandiar.productId] ?? 0;

    if (currentQty + 1 > product_inandiar.stock) {
      print('DEBUG: Stok tidak cukup untuk ${product_inandiar.name}');
      return;
    }

    cart_inandiar[product_inandiar.productId] = currentQty + 1;
    notifyListeners();
  }

  void removeFromCart_inandiar(String id_inandiar) {
    if (!cart_inandiar.containsKey(id_inandiar)) return;

    cart_inandiar[id_inandiar] = cart_inandiar[id_inandiar]! - 1;

    if (cart_inandiar[id_inandiar]! <= 0) {
      cart_inandiar.remove(id_inandiar);
    }

    notifyListeners();
  }

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

    final digitMatches = RegExp(r'\d').allMatches(nimTrim_inandiar);
    int lastDigit_inandiar = 0;
    final invalidFallbacks = {'', '12345', '000000'};

    if (invalidFallbacks.contains(nimTrim_inandiar)) {
      _shippingCost_inandiar = 0;
      _finalPrice_inandiar = total_inandiar;
      _promoDescription_inandiar =
          'No valid NIM: No discount or free shipping.';
      notifyListeners();
      return _finalPrice_inandiar;
    }

    if (digitMatches.isNotEmpty) {
      final lastMatch = digitMatches.last;
      lastDigit_inandiar = int.parse(
        nimTrim_inandiar.substring(lastMatch.start, lastMatch.end),
      );
    }

    if (lastDigit_inandiar % 2 != 0) {
      double discount = total_inandiar * 0.05;
      _shippingCost_inandiar = 10000;
      _finalPrice_inandiar =
          (total_inandiar - discount) + _shippingCost_inandiar;

      _promoDescription_inandiar =
          "NIM Ganjil: Diskon 5% (-Rp ${discount.toStringAsFixed(0)}) + Ongkir Rp 10.000";
    } else {
      _shippingCost_inandiar = 0;
      _finalPrice_inandiar = total_inandiar;
      _promoDescription_inandiar = "NIM Genap: Gratis Ongkir!";
    }

    notifyListeners();
    return _finalPrice_inandiar;
  }

  Map<String, int> get cartItems_inandiar => Map.unmodifiable(cart_inandiar);

  void clearCart_inandiar() {
    cart_inandiar.clear();
    notifyListeners();
  }

  String get promoDescription_inandiar => _promoDescription_inandiar;
  num get shippingCost_inandiar => _shippingCost_inandiar;
  num get finalPrice_inandiar => _finalPrice_inandiar;

  // =========================================================
  // CHECKOUT + UPDATE STOK FIRESTORE
  // =========================================================
  Future<num> checkout_inandiar(String nim_inandiar) async {
    num total_inandiar = totalPrice_inandiar();

    num finalTotal_inandiar =
        applyNimLogic_inandiar(total_inandiar, nim_inandiar);

    final firestoreService = FirestoreServiceGalang();

    for (final entry in cart_inandiar.entries) {
      final productId = entry.key;
      final qty = entry.value;
      final product = productsData_inandiar[productId];

      if (product != null) {
        final newStock = (product.stock - qty).toInt();

        if (newStock < 0) {
          throw Exception('Stok tidak cukup untuk ${product.name}');
        }

        await firestoreService.updateProductStockGalang(productId, newStock);

        productsData_inandiar[productId] = ProductModelGalang(
          productId: product.productId,
          name: product.name,
          price: product.price,
          stock: newStock,
          imageUrl: product.imageUrl,
        );
      }
    }

    clearCart_inandiar();

    return finalTotal_inandiar;
  }
}
