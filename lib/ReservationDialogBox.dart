import 'package:flutter/material.dart';

class ReservationDialogBox extends StatelessWidget {
  final String title;
  final String reservationNumber;
  final String usagePeriod;
  final String quantity;

  const ReservationDialogBox({
    required this.title,
    required this.reservationNumber,
    required this.usagePeriod,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10.0),
      elevation: 5.0,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title with underline
            Text(
              title,
              style: const TextStyle(
                fontSize: 20.0, // Title font size
                color: Colors.red, // Title text color
                fontWeight: FontWeight.bold, // Title bold text
                decoration: TextDecoration.underline, // Underline the title
              ),
            ),
            const SizedBox(height: 10),

            // Labels Row (Reservation Number, Usage Period, Quantity + More Options)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Expanded(
                  child: Text(
                    '予約番号',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    '使用期間',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    '数量',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'オプション',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),

            // Data Row (Corresponding to the Labels)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    reservationNumber,
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    usagePeriod,
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    quantity,
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        // Handle more options tap
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Options'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    title: Text('詳細を見る'), // 'View Details'
                                    onTap: () {
                                      // Handle view details action
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ListTile(
                                    title: Text('編集'), // 'Edit'
                                    onTap: () {
                                      // Handle edit action
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ListTile(
                                    title: Text('削除'), // 'Delete'
                                    onTap: () {
                                      // Handle delete action
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[300], // Circle background color
                        ),
                        child: Icon(
                          Icons.more_horiz,
                          color: Colors.black, // Icon color
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}