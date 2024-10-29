import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yotsuba_mobile/models/CartModels.dart';

class ReservationBottomBar extends StatefulWidget {
  final Cart cart;
  final VoidCallback onProceed;

  const ReservationBottomBar({
    Key? key,
    required this.cart,
    required this.onProceed,
  }) : super(key: key);

  @override
  State<ReservationBottomBar> createState() => _ReservationBottomBarState();
}

class _ReservationBottomBarState extends State<ReservationBottomBar> {
  @override
  void initState() {
    super.initState();
    // Listen to cart changes
    widget.cart.addListener(() {
      if (mounted) setState(() {});
    });
  }

  void _showCartDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => CartDetailsDialog(
        cart: widget.cart, // Use widget.cart here
        startDate: widget.cart.items.isNotEmpty ? widget.cart.items.first.startDate : null,
        endDate: widget.cart.items.isNotEmpty ? widget.cart.items.first.endDate : null,
        onRemoveItem: (CartItem item) {
          widget.cart.removeItem(item); // Use widget.cart here
          if (widget.cart.itemCount == 0) {
            Navigator.of(context).pop();
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(8),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Cart icon with badge and total
                Row(
                  children: [
                    Stack(
                      children: [
                        IconButton(
                          onPressed: widget.cart.itemCount > 0 
                              ? () => _showCartDetails(context)
                              : null,
                          icon: const Icon(Icons.shopping_cart),
                          iconSize: 32,
                          color: Colors.teal,
                        ),
                        if (widget.cart.itemCount > 0)
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 16,
                                minHeight: 16,
                              ),
                              child: Text(
                                '${widget.cart.itemCount}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '合計金額',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF9E9E9E),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFE0E0E0)),
                          ),
                          child: Text(
                            '¥${widget.cart.total.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // Checkout button
                ElevatedButton(
                  onPressed: widget.cart.itemCount > 0 ? widget.onProceed : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.cart.itemCount > 0 
                        ? Colors.teal 
                        : const Color(0xFFC8CDCE),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    '予約確認画面へ進む',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Update CartDetailsDialog as well
class CartDetailsDialog extends StatelessWidget {
  final Cart cart;
  final DateTime? startDate;
  final DateTime? endDate;
  final Function(CartItem) onRemoveItem;

  const CartDetailsDialog({
    Key? key,
    required this.cart,
    required this.startDate,
    required this.endDate,
    required this.onRemoveItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'カート内容',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (startDate != null && endDate != null) ...[
              const SizedBox(height: 8),
              Text(
                '予約期間: ${DateFormat('yyyy/MM/dd').format(startDate!)} - ${DateFormat('yyyy/MM/dd').format(endDate!)}',
                style: const TextStyle(fontSize: 14),
              ),
            ],
            const SizedBox(height: 16),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: cart.items.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final item = cart.items[index];
                  return ListTile(
                    title: Text(item.name),
                    subtitle: Text(
                      '${item.quantity}個 × ¥${item.price} × ${item.duration}日',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '¥${item.total.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () => onRemoveItem(item),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '合計:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '¥${cart.total.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('閉じる'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
