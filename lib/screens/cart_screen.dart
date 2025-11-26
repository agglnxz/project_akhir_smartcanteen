import 'package:flutter/material.dart';

class CartScreen_yossy extends StatelessWidget {
  const CartScreen_yossy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Keranjang")),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.shopping_cart, size: 80),
            SizedBox(height: 20),
            Text("Keranjang masih kosong"),
          ],
        ),
      ),
    );
  }
}
