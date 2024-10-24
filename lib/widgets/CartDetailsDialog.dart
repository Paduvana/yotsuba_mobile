import 'package:flutter/material.dart';

class ShoppingCart {
  List<CartProduct> items = [];

  void addItem(CartProduct product) {
    items.add(product);
  }

  void removeItem(CartProduct product) {
    items.remove(product);
  }
}

class CartProduct {
  final String title;
  final double price;

  CartProduct(this.title, this.price);
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
                  icon: Icon(Icons.close, color: Colors.black),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            const Divider(thickness: 1.0, color: Colors.grey),
            // Cart Items
            Expanded(
              child: ListView.builder(
                itemCount: cart.items.length,
                itemBuilder: (context, index) {
                  final product = cart.items[index];
                  return Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.cancel, color: Colors.black),
                        onPressed: () => onRemove(product),
                      ),
                      Text(
                        product.title,
                        style: const TextStyle(fontSize: 16.0),
                      ),
                      Spacer(),
                      Text('¥${product.price.toStringAsFixed(0)}'),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}