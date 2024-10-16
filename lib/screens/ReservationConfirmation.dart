import 'package:flutter/material.dart';
import 'package:yotsuba_mobile/widgets/BottomNavBar.dart';
import 'package:yotsuba_mobile/widgets/CustomAppBar.dart';

class Reservation {
  final String reservationNo;
  final String usagePeriod;
  final int quantity;

  Reservation({
    required this.reservationNo,
    required this.usagePeriod,
    required this.quantity,
  });
}

class ReservationConfirmation extends StatefulWidget {
  const ReservationConfirmation({Key? key}) : super(key: key);

  @override
  _ReservationConfirmationState createState() => _ReservationConfirmationState();
}

class _ReservationConfirmationState extends State<ReservationConfirmation> {
  bool showCurrent = true; // Toggle between Current and Past reservations
  int _selectedIndex = 2; // Start with "予約確認済み" tab selected

  final List<Reservation> currentReservations = [
    Reservation(reservationNo: '123456', usagePeriod: '01/01/2024 - 01/07/2024', quantity: 5),
    Reservation(reservationNo: '789012', usagePeriod: '02/01/2024 - 02/05/2024', quantity: 3),
  ];

  final List<Reservation> pastReservations = [
    Reservation(reservationNo: '345678', usagePeriod: '01/01/2023 - 01/07/2023', quantity: 4),
    Reservation(reservationNo: '901234', usagePeriod: '02/01/2023 - 02/05/2023', quantity: 2),
  ];

  @override
  Widget build(BuildContext context) {
    List<Reservation> reservationsToShow = showCurrent ? currentReservations : pastReservations;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: '予約確認',hideBackButton: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        showCurrent = true;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: showCurrent ? Colors.teal : Colors.grey,
                    ),
                    child: const Text('Current Reservation'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        showCurrent = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: !showCurrent ? Colors.teal : Colors.grey,
                    ),
                    child: const Text('Past Reservation'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Header Row
            const Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'Reservation No.',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Usage Period',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'Quantity',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'Details',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // List of Reservations
            Expanded(
              child: ListView.builder(
                itemCount: reservationsToShow.length,
                itemBuilder: (context, index) {
                  final reservation = reservationsToShow[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Expanded(flex: 2, child: Text(reservation.reservationNo)),
                        Expanded(flex: 2, child: Text(reservation.usagePeriod)),
                        Expanded(flex: 1, child: Text(reservation.quantity.toString())),
                        Expanded(
                          flex: 1,
                          child: IconButton(
                            icon: const Icon(Icons.more_horiz),
                            onPressed: () {
                              // Handle button press for reservation details
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
      ),
    );
  }
}
