class ProductModelGalang {
  final String productId;
  final String name;
  final num price;
  final num stock;
  final String imageUrl;

  ProductModelGalang({
    required this.productId,
    required this.name,
    required this.price,
    required this.stock,
    required this.imageUrl,
  });

  factory ProductModelGalang.fromJsonGalang(Map<String, dynamic> json) {
    return ProductModelGalang(
      productId: json['product_id'] as String,
      name: json['name'] as String,
      price: json['price'] as num,
      stock: json['stock'] as num,
      imageUrl: json['image_url'] as String,
    );
  }

  Map<String, dynamic> toJsonGalang() {
    return {
      'product_id': productId,
      'name': name,
      'price': price,
      'stock': stock,
      'image_url': imageUrl,
    };
  }
}