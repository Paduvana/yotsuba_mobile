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
                                    // Reservation Date label and value in a box
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Reservation Date:', style: TextStyle(fontWeight: FontWeight.bold)),
                                        const SizedBox(height: 8), // Added gap after label
                                        Container(
                                          padding: const EdgeInsets.all(8.0),
                                          decoration: BoxDecoration(
                                            border: Border.all(color: Colors.grey),
                                            borderRadius: BorderRadius.circular(4.0),
                                          ),
                                          child: Text(
                                            '${reservationDate.year}/${reservationDate.month.toString().padLeft(2, '0')}/${reservationDate.day.toString().padLeft(2, '0')} (${reservationDate.day.toString().padLeft(2, '0')})',
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),

                                    // Row for labels and their values below them
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text('Machine/Period:', style: TextStyle(fontWeight: FontWeight.bold)),
                                            ),
                                            Expanded(
                                              child: Text('Quantity:', style: TextStyle(fontWeight: FontWeight.bold)),
                                            ),
                                            Expanded(
                                              child: Text('Unit Price:', style: TextStyle(fontWeight: FontWeight.bold)),
                                            ),
                                            Expanded(
                                              child: Text('Number of Days:', style: TextStyle(fontWeight: FontWeight.bold)),
                                            ),
                                            Expanded(
                                              child: Text('Amount:', style: TextStyle(fontWeight: FontWeight.bold)),
                                            ),
                                          ],
                                        ),
                                        const Divider(thickness: 1, color: Colors.grey), // Single separation line after labels
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(child: Text('$machineName $period')),
                                            Expanded(child: Text(quantity)),
                                            Expanded(child: Text(unitPrice)),
                                            Expanded(child: Text(numberOfDays.toString())),
                                            Expanded(child: Text(amount)),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const Divider(thickness: 1, color: Colors.grey), // Single separation line after values
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