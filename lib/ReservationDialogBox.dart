import 'package:flutter/material.dart';

class ReservationDialogBox extends StatelessWidget {
  final String title;
  final String reservationNumber;
  final String usagePeriod;
  final String quantity;
  final Color backgroundColor; // parameter for background color
  final Color titleColor; // parameter for title color
  final DateTime reservationDate; // Added for reservation date
  final String machineName; // Added for machine name
  final String period; // Added for period
  final String unitPrice; // Added for unit price
  final int numberOfDays; // Added for number of days
  final String amount; // Added for amount

  const ReservationDialogBox({
    required this.title,
    required this.reservationNumber,
    required this.usagePeriod,
    required this.quantity,
    required this.backgroundColor,
    this.titleColor = Colors.black,
    required this.reservationDate,
    required this.machineName,
    required this.period,
    required this.unitPrice,
    required this.numberOfDays,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10.0),
      elevation: 5.0,
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title with underline
            Text(
              title,
              style: TextStyle(
                fontSize: 20.0,
                color: titleColor,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            ),
            const SizedBox(height: 10),

            // Labels Row (Reservation Number, Usage Period, Quantity + More Options)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Expanded(child: Text('予約No.', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))),
                Expanded(child: Text('利用期間', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))),
                Expanded(child: Text('数量', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))),
                Expanded(child: Text('詳細', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))),
              ],
            ),
            const SizedBox(height: 5),

            const Divider(thickness: 1.5, color: Colors.grey),
            const SizedBox(height: 5),

            // Data Row (Corresponding to the Labels)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(reservationNumber, style: const TextStyle(fontSize: 16.0))),
                Expanded(child: Text(usagePeriod, style: const TextStyle(fontSize: 16.0))),
                Expanded(child: Text(quantity, style: const TextStyle(fontSize: 16.0))),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        // Show details dialog with larger size
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              child: Container(
                                width: 400, // Set the width of the dialog
                                padding: const EdgeInsets.all(20.0), // Add some padding
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Details', style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 10),
                                    Text('Reservation Date: ${reservationDate.month}/${reservationDate.day}/${reservationDate.year}'),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Machine/Period:'),
                                            Text(machineName + ' ' + period),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Quantity:'),
                                            Text(quantity),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Unit Price:'),
                                            Text(unitPrice),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Number of Days:'),
                                            Text(numberOfDays.toString()),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Amount:'),
                                            Text(amount),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Close'),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[300],
                        ),
                        child: Icon(
                          Icons.more_horiz,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}