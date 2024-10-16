import 'package:flutter/material.dart';

class ReservationItemWidget extends StatelessWidget {
  final String title;
  final String reservationNumber;
  final String usagePeriod; // This can be formatted to include line breaks
  final String quantity;
  final Color titleColor;
  final Color backgroundColor;
  final DateTime reservationDate;
  final String machineName;
  final String period;
  final String unitPrice;
  final int numberOfDays;
  final String amount;
  final String consumptionTax; // Add consumption tax parameter
  final String total; // Add total parameter

  const ReservationItemWidget({
    Key? key,
    required this.title,
    required this.reservationNumber,
    required this.usagePeriod,
    required this.quantity,
    required this.titleColor,
    required this.backgroundColor,
    required this.reservationDate,
    required this.machineName,
    required this.period,
    required this.unitPrice,
    required this.numberOfDays,
    required this.amount,
    required this.consumptionTax, // Initialize consumption tax
    required this.total, // Initialize total
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(color: titleColor, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8.0),
          // Header row (no data here)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildColumn('予約No.', ''), // No data, just headers
              _buildColumn('利用期間', ''),
              _buildColumn('数量', ''),
              _buildColumn('詳細', ''),
            ],
          ),
          const Divider(
            thickness: 1.0,  // Adjust the thickness of the line
            color: Colors.grey, // Set the color of the line
          ),
          const SizedBox(height: 8.0), // Space below headers
          // Data row (actual data corresponding to headers)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildColumn('', reservationNumber), // Data
              _buildColumn('', _formatUsagePeriod(usagePeriod)), // Data
              _buildColumn('', quantity), // Data
              IconButton(
                icon: const Icon(Icons.more_horiz),
                onPressed: () {
                  // Do something else, e.g., show a snackbar or log
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Details button clicked')),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildColumn(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4.0), // Padding between header and data
        Text(value),
      ],
    );
  }

  String _formatUsagePeriod(String period) {
    return period.replaceAll(' - ', '\n');
  }
}