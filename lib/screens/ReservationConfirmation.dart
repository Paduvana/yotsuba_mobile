import 'package:flutter/material.dart';
import 'package:yotsuba_mobile/widgets/BottomNavBar.dart';

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
  List<bool> isSelected = [true, false]; // For ToggleButtons

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
      appBar: AppBar(
        title: const Text('予約確認'),
        foregroundColor: Colors.white,
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Toggle Button for Current and Past Reservations
            ToggleButtons(
              isSelected: isSelected,
              onPressed: (int index) {
                setState(() {
                  for (int i = 0; i < isSelected.length; i++) {
                    isSelected[i] = i == index;
                  }
                  showCurrent = index == 0;
                });
              },
              color: Colors.green,
              selectedColor: Colors.white,
              fillColor: Colors.green,
              borderRadius: BorderRadius.circular(10),
              borderColor: Colors.green.shade900,
              selectedBorderColor: Colors.green.shade900,
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('Current Reservation'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('Past Reservation'),
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
            const SizedBox(height: 1),
            Divider(thickness: 1, color: Colors.black), // Add this line to create a divider
            const SizedBox(height: 1),

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
                          child: Container(
                            width: 30, // Set the width to a smaller value
                            height: 40, // Set the height to a smaller value
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white54,
                              border: Border.all(color: Colors.black, width: 2),
                            ),
                          child: IconButton(
                            icon: const Icon(Icons.more_horiz),
                            onPressed: () {
                              // Handle button press for reservation details
                            },
                          ),
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