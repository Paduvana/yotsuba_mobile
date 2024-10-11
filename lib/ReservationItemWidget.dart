import 'package:flutter/material.dart';

class ReservationItemWidget extends StatelessWidget {
  final String title; // Title of the reservation (e.g., device name)
  final String reservationNumber; // Reservation number (bill number)
  final String usagePeriod; // Period of usage (start-end date)
  final String quantity; // Quantity of items reserved
  final Color titleColor; // Color for the title text
  final Color backgroundColor; // Background color of the card
  final DateTime reservationDate; // Date of reservation
  final String machineName; // Name of the machine/device
  final String period; // Period for display (if different from usagePeriod)
  final String unitPrice; // Unit price of the item
  final int numberOfDays; // Number of days reserved
  final String amount; // Subtotal amount
  final String consumptionTax; // Tax applied
  final String total; // Total amount including tax

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
    required this.consumptionTax,
    required this.total,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor, // Set background color of the card
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16), // Margin around the card
      child: Padding(
        padding: const EdgeInsets.all(16), // Padding inside the card
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Align children to the start
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18, // Title font size
                fontWeight: FontWeight.bold, // Bold title
                color: titleColor, // Title color
              ),
            ),
            const SizedBox(height: 8), // Space between title and other text
            Text('Reservation No: $reservationNumber'), // Display reservation number
            Text('Period: $usagePeriod'), // Display usage period
            Text('Quantity: $quantity'), // Display quantity
            const SizedBox(height: 8), // Space before financial details
            Text('Unit Price: $unitPrice'), // Display unit price
            Text('Number of Days: $numberOfDays'), // Display number of days
            Text('Amount: $amount'), // Display subtotal
            Text('Consumption Tax: $consumptionTax'), // Display tax amount
            Text('Total: $total'), // Display total amount
          ],
        ),
      ),
    );
  }
}