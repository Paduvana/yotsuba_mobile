import 'package:flutter/material.dart';

class ShoppingCart {
  List<CartProduct> items = [];

  void addItem(CartProduct product) {
    items.add(product);
  }

  void removeItem(CartProduct product) {
    items.remove(product);
  }

  double get total => items.fold(0, (sum, item) => sum + item.subtotal); // Updated total calculation

  double get consumptionTax => total * 0.1; // Assuming 10% tax
}

class CartProduct {
  final String title;
  final double price;
  int quantity; // Changed to allow updating
  final int days;
  final String period;

  CartProduct({
    required this.title,
    required this.price,
    this.quantity = 1,
    required this.days,
    required this.period,
  });

  double get subtotal => price * quantity * days; // Correct subtotal calculation
}

class CartDetailsDialog extends StatelessWidget {
  final ShoppingCart cart;
  final Function(CartProduct) onRemove;

  const CartDetailsDialog({
    Key? key,
    required this.cart,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.9,
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Expanded(
                  child: Text(
                    'カートの内容',
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.black),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            const Divider(thickness: 1.0, color: Colors.grey),
            // Table Headers
            const Row(
              children: [
                Expanded(flex: 2, child: Text('機器/期間', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))),
                Expanded(child: Text('数量', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))),
                Expanded(child: Text('単価', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))),
                Expanded(child: Text('日数', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))),
                Expanded(child: Text('金額', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))),
              ],
            ),
            const SizedBox(height: 10),
            const Divider(thickness: 1.0, color: Colors.grey),
            const SizedBox(height: 10),
            // Cart Items
            Expanded(
              child: ListView.builder(
                itemCount: cart.items.length,
                itemBuilder: (context, index) {
                  final product = cart.items[index];
                  return Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.cancel, color: Colors.black), // Use cancel icon
                        onPressed: () {
                          onRemove(product); // Call the remove function
                        },
                      ),
                      Expanded(
                        flex: 2,
                        child: Text('${product.title}\n${product.period}', style: const TextStyle(fontSize: 14.0)),
                      ),
                      Expanded(
                        child: Text('${product.quantity}', style: const TextStyle(fontSize: 14.0)),
                      ),
                      Expanded(
                        child: Text('¥${product.price.toStringAsFixed(0)}', style: const TextStyle(fontSize: 14.0)),
                      ),
                      Expanded(
                        child: Text('${product.days}', style: const TextStyle(fontSize: 14.0)),
                      ),
                      Expanded(
                        child: Text('¥${product.subtotal.toStringAsFixed(0)}', style: const TextStyle(fontSize: 14.0)),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            const Divider(thickness: 1.0, color: Colors.grey),
            // Bottom Consumption Tax and Total Rows
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('消費税', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.grey)),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Text(
                        '¥${cart.consumptionTax.toStringAsFixed(0)}',
                        style: const TextStyle(fontSize: 16.0, color: Colors.black),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('合計（税込）', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.grey)),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Text(
                        '¥${(cart.total + cart.consumptionTax).toStringAsFixed(0)}',
                        style: const TextStyle(fontSize: 16.0, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}