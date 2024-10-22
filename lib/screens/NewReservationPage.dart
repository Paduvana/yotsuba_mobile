import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yotsuba_mobile/widgets/BottomNavBar.dart';
import 'package:yotsuba_mobile/widgets/SearchFilters.dart';
import 'package:yotsuba_mobile/widgets/ReservationBottomBar.dart'; // Import ReservationBottomBar

class NewReservationPage extends StatefulWidget {
  @override
  _ReservationDateState createState() => _ReservationDateState();
}

class _ReservationDateState extends State<NewReservationPage> {
  DateTime? _rentalDate;
  DateTime? _returnDate;
  final TextEditingController _keywordController = TextEditingController();
  final double _totalPrice = 5000; // Example price

  Future<void> _selectDate(BuildContext context, bool isRentalDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isRentalDate) {
          _rentalDate = picked;
        } else {
          _returnDate = picked;
        }
      });
    }
  }

  void _proceedToReservationConfirmation() {
    // Implement navigation to confirmation screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('新規予約', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row for 貸出日 and 返却日
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 貸出日
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '貸出日',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => _selectDate(context, true),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Text(
                              _rentalDate != null
                                  ? DateFormat('yyyy/MM/dd').format(_rentalDate!)
                                  : 'Selected Date',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(width: 16),
                            const Icon(Icons.calendar_month_rounded, size: 24),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                // 返却日
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '返却日',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => _selectDate(context, false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Text(
                              _returnDate != null
                                  ? DateFormat('yyyy/MM/dd').format(_returnDate!)
                                  : 'Selected Date',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(width: 16),
                            const Icon(Icons.calendar_month_rounded, size: 24),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Combined CategoryDropdown and KeywordSearchBox
            SearchFilters(
              keywordController: _keywordController,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Use the new ReservationBottomBar widget
          ReservationBottomBar(
            totalPrice: _totalPrice,
            onProceed: _proceedToReservationConfirmation,
          ),

          // The original BottomNavBar
          BottomNavBar(selectedIndex: 1),
        ],
      ),
    );
  }
}