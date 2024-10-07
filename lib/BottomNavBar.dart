import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex; // The currently selected index
  final Function(int) onItemTapped; // Callback function for item tap

  BottomNavBar({
    Key? key, // Key for identifying the widget
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.arrow_upward),
          label: 'Top', // Label for the first item
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.edit_calendar_sharp),
          label: '新規予約', // Label for the second item (New Reservation)
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: '予約確認済み', // Label for the third item (Confirmed Reservations)
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: '設定', // Label for the fourth item (Settings)
        ),
      ],
      currentIndex: selectedIndex, // Set the current selected index
      selectedItemColor: Colors.teal, // Color for the selected item
      unselectedItemColor: Colors.grey, // Color for unselected items
      type: BottomNavigationBarType.fixed, // Fixed bottom navigation bar type
      backgroundColor: Colors.white, // Background color of the bar
      selectedLabelStyle: TextStyle(fontSize: 16), // Style for selected label
      unselectedLabelStyle: TextStyle(fontSize: 12), // Style for unselected labels
      onTap: onItemTapped, // Callback for when an item is tapped
    );
  }
}