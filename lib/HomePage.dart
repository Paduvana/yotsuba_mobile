import 'package:flutter/material.dart';
import 'LogoutPage.dart';
import 'BottomNavBar.dart'; // Import the BottomNavBar
import 'ReservationDialogBox.dart'; // Import the ReservationDialogBox

class HomePage extends StatefulWidget {
  final items = List<String>.generate(10000, (i) => 'Item $i');

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final items = List<String>.generate(10000, (i) => 'Item $i');
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
              title: '返却期限が過ぎました',
              reservationNumber: '0000',
              usagePeriod: '0000-00-00 - 0000-00-00',
              quantity: '0',
            ),
            ReservationDialogBox(
              title: '返却予定日は今日です',
              reservationNumber: '0000',
              usagePeriod: '0000-00-00 - 0000-00-00',
              quantity: '0',
            ),
            ReservationDialogBox(
              title: 'まもなく返却予定です',
              reservationNumber: '0000',
              usagePeriod: '0000-00-00 - 0000-00-00',
              quantity: '0',
            ),
            ReservationDialogBox(
              title: '現在使用中です',
              reservationNumber: '0000',
              usagePeriod: '0000-00-00 - 0000-00-00',
              quantity: '0',
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