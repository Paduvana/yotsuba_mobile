import 'package:flutter/material.dart';
import 'LogoutPage.dart';
import 'BottomNavBar.dart'; // Import the BottomNavBar
import 'ReservationDialogBox.dart'; // Import the ReservationDialogBox

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LogoutPage()),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const title = 'ダッシュボード';
    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.teal, // Background Color
          title: const Text(title),
        ),
        body: _getBodyContent(), // Use the correct body content
        bottomNavigationBar: BottomNavBar(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
        ), // Use the new BottomNavBar widget
      ),
    );
  }

  Widget _getBodyContent() {
    switch (_selectedIndex) {
      case 0:
        return ListView(
          children: [
            ReservationDialogBox(
              title: '返却期限が過ぎてしまいました。',
              reservationNumber: '0000',
              usagePeriod: '0000-00-00 - 0000-00-00',
              quantity: '0',
              titleColor: Colors.red, // Set title color to red
              backgroundColor: Colors.red[100]!, // Light red background
              reservationDate: DateTime.now(), // Example reservation date
              machineName: 'Machine A', // Example machine name
              period: '6/1-6/3', // Example period
              unitPrice: '\$100.00', // Example unit price
              numberOfDays: 3, // Example number of days
              amount: '\$300.00', // Example amount
            ),
            ReservationDialogBox(
              title: '本日返却予定があります。',
              reservationNumber: '0000',
              usagePeriod: '0000-00-00 - 0000-00-00',
              quantity: '0',
              titleColor: Colors.red, // Set title color to red
              backgroundColor: Colors.white, // Default background
              reservationDate: DateTime.now(), // Example reservation date
              machineName: 'Machine B', // Example machine name
              period: '6/3-6/5', // Example period
              unitPrice: '\$150.00', // Example unit price
              numberOfDays: 2, // Example number of days
              amount: '\$300.00', // Example amount
            ),
            ReservationDialogBox(
              title: '近日返却予定があります。',
              reservationNumber: '0000',
              usagePeriod: '0000-00-00 - 0000-00-00',
              quantity: '0',
              titleColor: Colors.orange, // Set title color to orange
              backgroundColor: Colors.white, // Default background
              reservationDate: DateTime.now(), // Example reservation date
              machineName: 'Machine C', // Example machine name
              period: '6/4-6/5', // Example period
              unitPrice: '\$200.00', // Example unit price
              numberOfDays: 1, // Example number of days
              amount: '\$200.00', // Example amount
            ),
            ReservationDialogBox(
              title: 'ご利用中',
              reservationNumber: '0000',
              usagePeriod: '0000-00-00 - 0000-00-00',
              quantity: '0',
              titleColor: Colors.greenAccent, // Set title color to green
              backgroundColor: Colors.white, // Default background
              reservationDate: DateTime.now(), // Example reservation date
              machineName: 'Machine D', // Example machine name
              period: '6/1-6/5', // Example period
              unitPrice: '\$250.00', // Example unit price
              numberOfDays: 4, // Example number of days
              amount: '\$1000.00', // Example amount
            ),
          ],
        );
      case 1:
        return Center(child: Text('New Reservation Screen', style: TextStyle(fontSize: 24)));
      case 2:
        return Center(child: Text('Reservation Confirmed Screen', style: TextStyle(fontSize: 24)));
      case 3:
        return Center(child: Text('Settings Screen', style: TextStyle(fontSize: 24)));
      default:
        return Container(); // Fallback for safety
    }
  }
}