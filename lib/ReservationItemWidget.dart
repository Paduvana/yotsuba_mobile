import 'package:flutter/material.dart';

class ReservationItemWidget extends StatelessWidget {
  final String title;
  final String reservationNumber;
  final String usagePeriod;
  final String quantity;
  final Color titleColor;
  final Color backgroundColor;
  final DateTime reservationDate;
  final String machineName;
  final String period;
  final String unitPrice;
  final int numberOfDays;
  final String amount;
  final String consumptionTax;
  final String total;

  ReservationItemWidget({
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
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: titleColor, fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text('Reservation Number: $reservationNumber'),
          Text('Usage Period: $usagePeriod'),
          Text('Quantity: $quantity'),
          Text('Reservation Date: ${reservationDate.toLocal()}'.split(' ')[0]),
          Text('Machine Name: $machineName'),
          Text('Period: $period'),
          Text('Unit Price: $unitPrice'),
          Text('Number of Days: $numberOfDays'),
          Text('Amount: $amount'),
          Text('Consumption Tax: $consumptionTax'),
          Text('Total: $total'),
        ],
      ),
    );
  }
}