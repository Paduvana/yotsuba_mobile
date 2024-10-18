import 'package:flutter/material.dart';

class NewReservationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('新規予約'),
        centerTitle: true,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: TextButton(
              onPressed: () {
                // Handle the button press logic here
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2), //change vertical padding
                minimumSize: Size(50, 25), //Change height and width
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), // Change radius
                ),
              ),
              child: const Text('表示切替'),
            ),
          ),
        ],
      ),
      body: Center(
        child: Text('New Reservation Page Content'),
      ),
    );
  }
}