import 'package:flutter/material.dart';
import 'package:yotsuba_mobile/screens/Dashboard.dart';
import 'package:yotsuba_mobile/screens/UserProfile.dart';
import '../screens/NewReservationPage.dart';
import '../screens/ReservationList.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;

  const BottomNavBar({super.key, required this.selectedIndex});

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Dashboard()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const NewReservationPage()), // Navigate to the NewReservation page
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ReservationList()),
        );
        break;
      case 3:
        Navigator.pushReplacement(
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
      unselectedLabelStyle:
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      onTap: (index) => _onItemTapped(context, index),
    );
  }
}
