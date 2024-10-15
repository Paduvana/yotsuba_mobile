import 'package:flutter/material.dart';

class ReservationItemWidget extends StatelessWidget {
  final String title;
  final String reservationNumber;
  final String usagePeriod; // This can be formatted to include line breaks
  final String quantity;
  final Color titleColor;
  final Color backgroundColor;

  const ReservationItemWidget({
    Key? key,
    required this.title,
    required this.reservationNumber,
    required this.usagePeriod,
    required this.quantity,
    required this.titleColor,
    required this.backgroundColor,
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
          Row(
            children: [
              _buildColumn('予約No.', reservationNumber),
              const Spacer(), // Equal spacing
              _buildColumn('利用期間', _formatUsagePeriod(usagePeriod)),
              const Spacer(), // Equal spacing
              _buildColumn('数量', quantity),
              const Spacer(), // Equal spacing
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildColumn('詳細', ''), // Detail header
                  IconButton(
                    icon: const Icon(Icons.more_horiz), // Ellipsis button
                    onPressed: () {
                      // Handle button press here
                    },
                  ),
                ],
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
        Text(value),
      ],
    );
  }

  String _formatUsagePeriod(String period) {
    // Format the usage period to include line breaks
    return period.replaceAll(' - ', '\n');
  }
}