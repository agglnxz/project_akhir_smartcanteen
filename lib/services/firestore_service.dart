import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';
import '../models/user_model.dart';

class FirestoreServiceGalang {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // COLLECTION NAMES
  final String _productsCollectionGalang = 'Products';
  final String _usersCollectionGalang = 'Users';


  // Seeder Produk Dummy
  Future<void> seedProductsGalang() async {
    final List<ProductModelGalang> dummyProductsGalang = [
      ProductModelGalang(productId: 'P001', name: 'Nasi Goreng', price: 15000, stock: 25, imageUrl: 'assets/images/nasigoreng.jpg'),
      ProductModelGalang(productId: 'P002', name: 'Mie Ayam', price: 12000, stock: 30, imageUrl: 'assets/images/mieayam.jpg'),
      ProductModelGalang(productId: 'P003', name: 'Soto Ayam', price: 14000, stock: 18, imageUrl: 'assets/images/sotoayam.jpg'),
      ProductModelGalang(productId: 'P004', name: 'Es Teh Manis', price: 4000, stock: 50, imageUrl: 'assets/images/estehmanis.jpg'),
      ProductModelGalang(productId: 'P005', name: 'Kopi Susu', price: 8000, stock: 45, imageUrl: 'assets/images/kopisusu.jpg'),
      ProductModelGalang(productId: 'P006', name: 'Roti Bakar', price: 10000, stock: 22, imageUrl: 'assets/images/rotibakar.jpg'),
      ProductModelGalang(productId: 'P007', name: 'Gado-Gado', price: 16000, stock: 15, imageUrl: 'assets/images/gadogado.jpg'),
      ProductModelGalang(productId: 'P008', name: 'Bakso Kuah', price: 18000, stock: 28, imageUrl: 'assets/images/baksokuah.jpg'),
      ProductModelGalang(productId: 'P009', name: 'Air Mineral', price: 3000, stock: 60, imageUrl: 'assets/images/airmineral.jpg'),
      ProductModelGalang(productId: 'P010', name: 'Nasi Padang', price: 20000, stock: 10, imageUrl: 'assets/images/nasipadang.jpg'),
    ];

    WriteBatch batchGalang = _db.batch();

    for (var product in dummyProductsGalang) {
      final ref = _db.collection(_productsCollectionGalang).doc(product.productId);
      batchGalang.set(ref, product.toJsonGalang());
    }

    await batchGalang.commit();
  }

  // GET All Products
  Future<List<ProductModelGalang>> getProductsGalang() async {
    try {
      final query = await _db.collection(_productsCollectionGalang).get();
      return query.docs
          .map((doc) => ProductModelGalang.fromJsonGalang(doc.data()))
          .toList();
    } catch (e) {
      print('Error fetching products: $e');
      return [];
    }
  }

  // ===============================================================
  // ==================== BAGIAN USER ==============================
  // ===============================================================

  Future<void> saveUserToFirestore({
    required String uid,
    required UserModelGalang user,
  }) async {
    await _db.collection(_usersCollectionGalang).doc(uid).set(user.toJsonGalang());
  }

  Future<UserModelGalang?> getUserByUid(String uid) async {
    final doc = await _db.collection(_usersCollectionGalang).doc(uid).get();
    if (doc.exists && doc.data() != null) {
      return UserModelGalang.fromJsonGalang(doc.data()!);
    }
    return null;
  }

  Future<bool> checkUserIdExists(String userId) async {
    final query = await _db
        .collection(_usersCollectionGalang)
        .where('user_id', isEqualTo: userId)
        .get();
    return query.docs.isNotEmpty;
  }

  // ===============================================================
  // ==================== UPDATE STOK (VALIDASI) ===================
  // ===============================================================

  /// Update stok dengan pengurangan qty (transaksi atomic)
  Future<void> updateProductStock_inandiar(String productId, int qtyToReduce) async {
    try {
      final ref = _db.collection(_productsCollectionGalang).doc(productId);
      await _db.runTransaction((transaction) async {
        final snap = await transaction.get(ref);

        if (!snap.exists) throw Exception("Produk tidak ditemukan");

        final currentStock = snap.data()?['stock'] ?? 0;
        if (currentStock < qtyToReduce) {
          throw Exception("Stok tidak cukup untuk produk $productId");
        }

        transaction.update(ref, {'stock': currentStock - qtyToReduce});
      });
    } catch (e) {
      throw Exception("Gagal update stok: $e");
    }
  }

  // ===============================================================
  // ========== TAMBAHAN BARU — UPDATE STOK LANGSUNG ===============
  // ===============================================================

  /// Dipakai CartProvider: update stok langsung ke nilai baru
  Future<void> updateProductStockGalang(String productId, int newStock) async {
    final ref = _db.collection(_productsCollectionGalang).doc(productId);

    await ref.update({
      'stock': newStock,
    });
  }

  // ===============================================================
  // ==================== TRANSAKSI ================================
  // ===============================================================

  Future<void> createTransaction_inandiar({
    required String trxId,
    required num finalTotal,
    required List<Map<String, dynamic>> items,
  }) async {
    await _db.collection("Transactions").doc(trxId).set({
      "trx_id": trxId,
      "total": finalTotal,
      "status": "Success",
      "items": items,
      "date": FieldValue.serverTimestamp(),
    });

    // Update stok produk
    WriteBatch batch = _db.batch();

    for (var item in items) {
      final productId = item["product_id"];
      final qty = item["qty"];

      final ref = _db.collection(_productsCollectionGalang).doc(productId);

      batch.update(ref, {
        "stock": FieldValue.increment(-qty),
      });
    }

    await batch.commit();
  }
}
