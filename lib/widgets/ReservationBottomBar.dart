import 'package:flutter/material.dart';

class ReservationBottomBar extends StatelessWidget {
  final double totalPrice;
  final VoidCallback onProceed;

  const ReservationBottomBar({
    Key? key,
    required this.totalPrice,
    required this.onProceed,
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
                  // Add cart functionality here
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
                  color: Color(0xFF9E9E9E),  // Changed to #9E9E9E
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Color(0xFFE0E0E0)), // Changed to #E0E0E0
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
              backgroundColor: const Color(0xFFC8CDCE),  // Changed to #C8CDCE
              foregroundColor: Colors.white,  // Changed text color to white
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16), // Increased height
              textStyle: const TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}