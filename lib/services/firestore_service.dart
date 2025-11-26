import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart'; 

class FirestoreServiceGalang {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  
  // Variabel Collection Names (Watermark)
  // Collection 2: Products [cite: 15]
  final String _productsCollectionGalang = 'Products'; 

  // Fungsi untuk Seeding Data 10 Produk (Watermark pada fungsi) 
  Future<void> seedProductsGalang() async {
    // List data dummy minimal 10 produk 
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

    WriteBatch batchGalang = _db.batch(); // Watermark pada variabel
    print('Memulai seeding ${dummyProductsGalang.length} produk...');

    for (var product in dummyProductsGalang) {
      // Menggunakan Product ID sebagai Document ID di Firestore
      DocumentReference docRefGalang = _db.collection(_productsCollectionGalang).doc(product.productId);
      
      // Menulis data menggunakan fungsi toJsonGalang()
      batchGalang.set(docRefGalang, product.toJsonGalang()); 
    }

    await batchGalang.commit();
    print('Seeding data dummy produk berhasil diselesaikan!');
  }

  // Fungsi tambahan yang mungkin diperlukan Anggota 4: Mengambil semua produk
  Future<List<ProductModelGalang>> getProductsGalang() async {
    try {
      final querySnapshotGalang = await _db
          .collection(_productsCollectionGalang)
          .get();

      return querySnapshotGalang.docs.map((doc) => 
          ProductModelGalang.fromJsonGalang(doc.data()!)).toList();
    } catch (e) {
      print('Error fetching products: $e');
      return [];
    }
  }
}