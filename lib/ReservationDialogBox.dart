import 'package:flutter/material.dart';

class ReservationDialogBox extends StatelessWidget {
  final String title;
  final String reservationNumber;
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
    return Card(
      margin: const EdgeInsets.all(10.0),
      elevation: 5.0,
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 20.0, color: titleColor, fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            ),
            const SizedBox(height: 10),
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
            const Divider(thickness: 1.0, color: Colors.grey),
            const SizedBox(height: 5),
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
                        showGeneralDialog(
                          context: context,
                          barrierDismissible: true,
                          barrierLabel: '',
                          pageBuilder: (context, animation1, animation2) {
                            return Scaffold(
                              appBar: AppBar(
                                title: Text(
                                  'Details',
                                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                                ),
                                automaticallyImplyLeading: false,
                                actions: [
                                  IconButton(
                                    icon: Icon(Icons.close),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              ),
                              body: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Reservation Date label and value without divider
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Reservation Date:', style: TextStyle(fontWeight: FontWeight.bold)),
                                        Text('${reservationDate.month}/${reservationDate.day}/${reservationDate.year}'),
                                      ],
                                    ),
                                    const SizedBox(height: 10),

                                    // Row for labels and their values below them
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('Machine/Period ', style: TextStyle(fontWeight: FontWeight.bold)),
                                              const SizedBox(height: 5), // Add space before divider
                                              const Divider(thickness: 1.0, color: Colors.grey), // Divider
                                              const SizedBox(height: 5), // Add space after divider
                                              Text('$machineName $period'),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('Quantity ', style: TextStyle(fontWeight: FontWeight.bold)),
                                              const SizedBox(height: 5), // Add space before divider
                                              const Divider(thickness: 1.0, color: Colors.grey), // Divider
                                              const SizedBox(height: 5), // Add space after divider
                                              Text(quantity),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('Unit Price ', style: TextStyle(fontWeight: FontWeight.bold)),
                                              const SizedBox(height: 5), // Add space before divider
                                              const Divider(thickness: 1.0, color: Colors.grey), // Divider
                                              const SizedBox(height: 5), // Add space after divider
                                              Text(unitPrice),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('No of Days ', style: TextStyle(fontWeight: FontWeight.bold)),
                                              const SizedBox(height: 5), // Add space before divider
                                              const Divider(thickness: 1.0, color: Colors.grey), // Divider
                                              const SizedBox(height: 5), // Add space after divider
                                              Text(numberOfDays.toString()),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('Amount ', style: TextStyle(fontWeight: FontWeight.bold)),
                                              const SizedBox(height: 5), // Add space before divider
                                              const Divider(thickness: 1.0, color: Colors.grey), // Divider
                                              const SizedBox(height: 5), // Add space after divider
                                              Text(amount),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    const Divider(thickness: 1.0, color: Colors.grey), // Divider after values

                                    // Add Consumption Tax and Total
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Consumption Tax:', style: TextStyle(fontWeight: FontWeight.bold)),
                                        Text(consumptionTax), // Show consumption tax value
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Total (tax included):', style: TextStyle(fontWeight: FontWeight.bold)),
                                        Text(total), // Show total value
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          transitionBuilder: (context, animation1, animation2, child) {
                            return FadeTransition(
                              opacity: animation1,
                              child: child,
                            );
                          },
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[300],
                        ),
                        child: const Icon(
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