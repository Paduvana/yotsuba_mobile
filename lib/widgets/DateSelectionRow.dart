import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateSelectionRow extends StatelessWidget {
  final DateTime? rentalDate;
  final DateTime? returnDate;
  final Function(DateTime?, DateTime?) onDateChange;

  const DateSelectionRow({
    Key? key,
    required this.rentalDate,
    required this.returnDate,
    required this.onDateChange,
  }) : super(key: key);

  Future<void> _selectDate(BuildContext context, bool isRentalDate) async {
    DateTime initialDate;
    DateTime firstDate;
    DateTime lastDate;

    if (isRentalDate) {
      initialDate = rentalDate ?? DateTime.now();
      firstDate = DateTime.now();
      lastDate = returnDate ?? DateTime(2101);
    } else {
      initialDate = returnDate ?? 
          (rentalDate?.add(const Duration(days: 1)) ?? 
           DateTime.now().add(const Duration(days: 1)));
      firstDate = rentalDate?.add(const Duration(days: 1)) ?? DateTime.now();
      lastDate = DateTime(2101);
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null) {
      DateTime? newRentalDate = rentalDate;
      DateTime? newReturnDate = returnDate;

      if (isRentalDate) {
        newRentalDate = picked;
        if (returnDate != null && returnDate!.isBefore(picked)) {
          newReturnDate = null;
        }
      } else {
        newReturnDate = picked;
      }

      onDateChange(newRentalDate, newReturnDate);
    }
  }

  Widget _buildDatePicker(
    BuildContext context,
    String title,
    DateTime? date,
    bool isRental,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _selectDate(context, isRental),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: Row(
              children: [
                Text(
                  date != null ? DateFormat('yyyy/MM/dd').format(date) : '日付を選択',
                  style: TextStyle(
                    fontSize: 16,
                    color: date != null ? Colors.black : Colors.grey,
                  ),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.calendar_month_rounded, size: 24),
              ],
            ),
          ),
        ),
        if (isRental && rentalDate != null && returnDate == null)
          const Padding(
            padding: EdgeInsets.only(top: 4),
            child: Text(
              '返却日を選択してください',
              style: TextStyle(
                fontSize: 12,
                color: Colors.blue,
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: _buildDatePicker(context, '貸出日', rentalDate, true),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildDatePicker(context, '返却日', returnDate, false),
        ),
      ],
    );
  }
}