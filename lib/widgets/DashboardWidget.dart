import 'package:flutter/material.dart';
import 'package:yotsuba_mobile/widgets/ReservationDetailsTable.dart';

class Dashboardwidget extends StatelessWidget {
  final String title;
  final Map<String, dynamic> reservation;
  final Color titleColor;
  final Color backgroundColor;


  const Dashboardwidget({
    super.key,
    required this.title,
    required this.reservation,
    required this.titleColor,
    required this.backgroundColor,

  });

  @override
  Widget build(BuildContext context) {
    // Creating a list containing a single reservation item
    List<Map<String, dynamic>> reservations = [reservation];

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
          ReservationDetailsTable(reservations: reservations)
        ],
      ),
    );
  }
}
