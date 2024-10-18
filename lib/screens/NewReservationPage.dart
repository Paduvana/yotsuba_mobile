import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:yotsuba_mobile/widgets/BottomNavBar.dart'; // Import BottomNavBar

class NewReservationPage extends StatefulWidget {
  @override
  _ReservationDateState createState() => _ReservationDateState();
}

class _ReservationDateState extends State<NewReservationPage> {
  DateTime? _rentalDate;
  DateTime? _returnDate;
  String? _selectedCategory = '機械測定機器'; // Default category
  final List<String> _categories = ['機械測定機器', '機械測定機器ー2', '機械測定機器ー3']; // Dropdown options
  final TextEditingController _keywordController = TextEditingController(); // Controller for the search box

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('新規予約'),
        centerTitle: true,
        automaticallyImplyLeading: false, // Remove top left back arrow
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
                                  : 'Selected Date', // Display selected date or placeholder
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
                                  : 'Selected Date', // Display selected date or placeholder
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

            // Row for カテゴリーから探す and キーワードで探す
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // カテゴリーから探す
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'カテゴリーから探す',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 185, // Set width as needed
                      height: 45,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButton<String>(
                        value: _selectedCategory,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedCategory = newValue;
                          });
                        },
                        items: _categories.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        icon: const Icon(Icons.arrow_drop_down),
                        isExpanded: true,
                        underline: SizedBox(), // Remove underline
                      ),
                    ),
                  ],
                ),

                // キーワードで探す
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'キーワードで探す',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 185, // Set width as needed
                      height: 45,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        controller: _keywordController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderSide: BorderSide.none), // Remove default border
                          suffixIcon: const Icon(Icons.search),
                          hintText: '', // Hint text
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
      bottomNavigationBar: BottomNavBar(selectedIndex: 1), // Add BottomNavBar with the second tab selected
    );
  }
}