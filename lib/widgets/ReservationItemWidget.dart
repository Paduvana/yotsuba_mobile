import 'package:flutter/material.dart';
import 'package:yotsuba_mobile/widgets/ReservationDialogBox.dart';

class ReservationItemWidget extends StatelessWidget {
  final String title;
  final int reservationNumber;
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

  const ReservationItemWidget({
    super.key,
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
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Colors.black, width: 2.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
                color: titleColor, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8.0),
          Table(
            columnWidths: const {
              0: FlexColumnWidth(2), // More space for reservation number
              1: FlexColumnWidth(3), // More space for usage period
              2: FlexColumnWidth(1), // Less space for quantity
              3: FlexColumnWidth(1), // Space for the button
            },
            children: [
              // Header Row
              TableRow(
                children: [
                  _buildHeaderCell('予約No.'),
                  _buildHeaderCell('利用期間'),
                  _buildHeaderCell('数量'),
                  _buildHeaderCell('詳細'),
                ],
              ),
              // Data Row
              TableRow(
                children: [
                  _buildTableCell(reservationNumber.toString()),
                  _buildTableCell(_formatUsagePeriod(usagePeriod)),
                  _buildTableCell(quantity),
                  _buildButtonCell(context), // Cell for the button
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String header) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: Center(
        child: Text(
          header,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
        ),
      ),
    );
  }

  Widget _buildTableCell(String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Center(
        child: Text(
          value,
          style: const TextStyle(fontSize: 14.0),
        ),
      ),
    );
  }

  Widget _buildButtonCell(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black, width: 2.0),
          ),
          child: GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return ReservationDialogBox(
                    title: title,
                    reservationNumber: reservationNumber,
                    usagePeriod: usagePeriod,
                    quantity: quantity,
                    amount: amount,
                    consumptionTax: consumptionTax,
                    backgroundColor: backgroundColor,
                    machineName: machineName,
                    numberOfDays: numberOfDays,
                    period: period,
                    reservationDate: reservationDate,
                    total: total,
                    unitPrice: unitPrice,
                  );
                },
              );
            },
            child: const Padding(
              padding: EdgeInsets.all(
                  4.0), // Adjust this padding to control the space around the icon
              child: Icon(Icons.more_horiz),
            ),
          ),
        ),
      ),
    );
  }

  String _formatUsagePeriod(String period) {
    // Format the usage period to include line breaks
    return period.replaceAll('-', '/');
  }
}
