import 'package:flutter/material.dart';
import 'LogoutPage.dart';
import 'BottomNavBar.dart'; // Import the BottomNavBar

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