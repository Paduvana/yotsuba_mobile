import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  BottomNavBar({
    required this.selectedIndex,
    required this.onItemTapped,
  });

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
      selectedLabelStyle: TextStyle(fontSize: 16),
      unselectedLabelStyle: TextStyle(fontSize: 12),
      onTap: onItemTapped,
    );
  }
}