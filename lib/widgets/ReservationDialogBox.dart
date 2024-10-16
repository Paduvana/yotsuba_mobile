import 'package:flutter/material.dart';

class ReservationDialogBox extends StatelessWidget {
  final String title;
  final int reservationNumber;
  final String usagePeriod;
  final String quantity;
  final Color backgroundColor;
  final Color titleColor;
  final DateTime reservationDate;
  final String machineName;
  final String period;
  final String unitPrice;
  final int numberOfDays;
  final String amount;
  final String consumptionTax; // Add consumption tax parameter
  final String total; // Add total parameter

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
    required this.consumptionTax, // Initialize consumption tax
    required this.total, // Initialize total
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with Close Button
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '詳細（予約No.$reservationNumber）',
                      style: TextStyle(
                        fontSize: 15.0,
                        color: titleColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.black),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Reservation Date
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('予約日', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${reservationDate.year}/${reservationDate.month}/${reservationDate.day}（木）',
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Table Headers
              const Row(
                children: [
                  Expanded(flex: 2, child: Text('機器/期間', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))),
                  Expanded(child: Text('数量', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))),
                  Expanded(child: Text('単価', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))),
                  Expanded(child: Text('日数', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))),
                  Expanded(child: Text('金額', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))),
                ],
              ),
              const SizedBox(height: 10),
              const Divider(thickness: 1.0, color: Colors.grey),
              const SizedBox(height: 10),
              // Table Data
             Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text('$machineName \n ${_formatUsagePeriod(usagePeriod)}', style: const TextStyle(fontSize: 14.0)),
                  ),
                  Expanded(
                    child: Text(quantity, style: const TextStyle(fontSize: 14.0)),
                  ),
                  Expanded(
                    child: Text(unitPrice, style: const TextStyle(fontSize: 14.0)),
                  ),
                  Expanded(
                    child: Text(numberOfDays.toString(), style: const TextStyle(fontSize: 14.0)),
                  ),
                  Expanded(
                    child: Text(amount, style: const TextStyle(fontSize: 14.0)),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(thickness: 1.0, color: Colors.grey),
              const SizedBox(height: 20),
              // Consumption Tax
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('消費税', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.grey)),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Text(
                      consumptionTax,
                      style: const TextStyle(fontSize: 16.0, color: Colors.black),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              // Total
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('合計（税込）', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.grey)),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Text(
                      total,
                      style: const TextStyle(fontSize: 16.0, color: Colors.black),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
    String _formatUsagePeriod(String period) {
      // Split the usage period into two dates
      List<String> dates = period.replaceAll('-', '/').split('〜');
      if (dates.length == 2) {
        String startDate = dates[0].trim();
        String endDate = dates[1].trim();
            String formattedStart = startDate.substring(5);
            String formattedEnd = endDate.substring(5);
            return '$formattedStart ~ $formattedEnd';
      }
      else{
        return period.replaceAll('-', '/');
      }
}

}
