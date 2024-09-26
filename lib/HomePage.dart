import 'package:flutter/material.dart';
import 'logout_page.dart'; // Import the new LogoutPage


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
    const title = 'Long List';
    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(title),
        ),
        body: ListView.builder(
          itemCount: items.length,
          prototypeItem: ListTile(
            title: Text(items.first),
          ),
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(items[index]),
            );
          },
        ),
        //NAV bar
        bottomNavigationBar: BottomNavigationBar(
          items: const<BottomNavigationBarItem>[
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
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.teal,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed, // Always show labels
          backgroundColor: Colors.white,
          selectedLabelStyle: TextStyle(fontSize: 16),  // Selected tab font size
          unselectedLabelStyle: TextStyle(fontSize: 12), // Unselected tab font size
          onTap: _onItemTapped,
        ),
      ),
    );
  }
  Widget _getBodyContent() {
    switch (_selectedIndex) {
      case 0:
        return ListView.builder(
          itemCount: items.length,
          prototypeItem: ListTile(
            title: Text(items.first),
          ),
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(items[index]),
            );
          },
        );
      case 1:
        return Center(child: Text(
            'New Reservation Screen', style: TextStyle(fontSize: 24)));
      case 2:
        return Center(child: Text(
            'Reservation Confirmed Screen', style: TextStyle(fontSize: 24)));
      case 3:
        return Center(
            child: Text('Settings Screen', style: TextStyle(fontSize: 24)));
      default:
        return Container(); // Fallback for safety
    }
  }
}



