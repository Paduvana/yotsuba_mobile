import 'package:flutter/material.dart';
import 'package:yotsuba_mobile/screens/Dashboard.dart';
import 'package:yotsuba_mobile/screens/UserProfile.dart';
import '../screens/ReservationConfirmation.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;

  BottomNavBar({required this.selectedIndex});

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Dashboard()),
        );
        break;
      case 1:
        // Implement navigation for "新規予約" tab if applicable
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ReservationConfirmation()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const UserProfile()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.arrow_upward),
          label: 'Top',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.edit_calendar_sharp),
          label: '新規予約',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: '予約確認済み',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: '設定',
        ),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: Colors.teal,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedLabelStyle: const TextStyle(fontSize: 16),
      unselectedLabelStyle: const TextStyle(fontSize: 12),
      onTap: (index) => _onItemTapped(context, index),
    );
  }
}