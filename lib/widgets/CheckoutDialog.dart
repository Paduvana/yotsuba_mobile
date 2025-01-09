import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yotsuba_mobile/models/CartModels.dart';

class CheckOutDialog extends StatefulWidget {
  final List<CartItem> items;
  final DateTime startDate;
  final DateTime endDate;
  final Color backgroundColor;
  final Color titleColor;
  final Function(CartItem) onRemoveItem;

  const CheckOutDialog({
    super.key,
    required this.items,
    required this.startDate,
    required this.endDate,
    required this.onRemoveItem,
    this.backgroundColor = Colors.white,
    this.titleColor = Colors.black,
  });

  @override
  _CheckOutDialogState createState() => _CheckOutDialogState();
}

class _CheckOutDialogState extends State<CheckOutDialog> {
  late List<CartItem> items;

  @override
  void initState() {
    super.initState();
    items = List.from(widget.items); // Make a copy to work with locally
  }

  double get subtotal => items.fold(0, (sum, item) => sum + item.total);
  double get consumptionTaxAmount => subtotal * 0.1;
  double get total => subtotal + consumptionTaxAmount;

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
          children: [
            // Header
            Row(
              children: [
                Expanded(
                  child: Text(
                    '予約内容確認',
                    style: TextStyle(
                      fontSize: 15.0,
                      color: widget.titleColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.black),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Reservation Date
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('予約期間',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '${DateFormat('yyyy/MM/dd').format(widget.startDate)} ~ ${DateFormat('yyyy/MM/dd').format(widget.endDate)}',
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Table Headers
            const Row(
              children: [
                Expanded(
                    flex: 2,
                    child: Text('機器/期間',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold))),
                Expanded(
                    child: Text('数量',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold))),
                Expanded(
                    child: Text('単価',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold))),
                Expanded(
                    child: Text('日数',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold))),
                Expanded(
                    child: Text('金額',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold))),
              ],
            ),
            const Divider(thickness: 1.0, color: Colors.grey),

            // Items List
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.cancel_outlined, color: Colors.black, size: 20),
                        onPressed: () {
                          // Remove the item locally and update the UI
                          setState(() {
                            items.remove(item);
                          });

                          // Call the callback to update the cart in the parent widget
                          widget.onRemoveItem(item);
                        },
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          item.name,
                          style: const TextStyle(fontSize: 14.0),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          item.quantity.toString(),
                          style: const TextStyle(fontSize: 14.0),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '¥${item.price.toStringAsFixed(0)}',
                          style: const TextStyle(fontSize: 14.0),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          item.duration.toString(),
                          style: const TextStyle(fontSize: 14.0),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '¥${item.total.toStringAsFixed(0)}',
                          style: const TextStyle(fontSize: 14.0),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            const Divider(thickness: 1.0, color: Colors.grey),

            // Totals
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('消費税',
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey)),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: Text(
                        '¥${consumptionTaxAmount.toStringAsFixed(0)}',
                        style: const TextStyle(
                            fontSize: 16.0, color: Colors.black),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('合計（税込）',
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey)),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: Text(
                        '¥${total.toStringAsFixed(0)}',
                        style: const TextStyle(
                            fontSize: 16.0, color: Colors.black),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context,
                          true), // Return true to proceed with checkout
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                      ),
                      child: const Text(
                        '予約を確定する',
                        style: TextStyle(
                          color: Colors.white,
                        ),
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