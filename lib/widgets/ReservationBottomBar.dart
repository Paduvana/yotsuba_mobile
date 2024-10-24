import 'package:flutter/material.dart';
import 'package:yotsuba_mobile/widgets/ProductList.dart';
import 'package:yotsuba_mobile/widgets/CartDetailsDialog.dart';

class ReservationBottomBar extends StatelessWidget {
  final double totalPrice;
  final VoidCallback onProceed;
  final ShoppingCart cart; // Holds the cart state

  const ReservationBottomBar({
    Key? key,
    required this.totalPrice,
    required this.onProceed,
    required this.cart, // Include cart in constructor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Shopping cart button and total text
          Row(
            children: [
              IconButton(
                onPressed: () {
                  // Open CartDetailsDialog when the cart icon is pressed
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CartDetailsDialog(
                        cart: cart,
                        onRemove: (CartProduct) {
                          print('${CartProduct.title} removed from cart');
                          cart.removeItem(CartProduct);
                          Navigator.of(context).pop(); // Close the dialog
                        },
                      );
                    },
                  );
                },
                icon: const Icon(Icons.shopping_cart),
                iconSize: 32,
                color: Colors.teal,
              ),
              const SizedBox(width: 8),
              const Text(
                '合計',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF9E9E9E),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Color(0xFFE0E0E0)),
                ),
                child: Text(
                  '¥${totalPrice.toStringAsFixed(0)}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),

          // Proceed button
          ElevatedButton(
            onPressed: onProceed,
            child: const Text('予約確認画面へ進む'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFC8CDCE),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              textStyle: const TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}