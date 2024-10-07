import 'dart:convert';
import 'package:flutter/material.dart';
import 'LogoutPage.dart';
import 'package:http/http.dart' as http; // Import http package
import 'BottomNavBar.dart'; // Import the BottomNavBar
import 'ReservationItemWidget.dart'; // Import the ReservationItemWidget

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  List<dynamic> _reservations = []; // Store reservations from API
  bool _isLoading = true; // Show loading indicator

  @override
  void initState() {
    super.initState();
    _fetchReservations(); // Call the API when the page is loaded
  }

  Future<void> _fetchReservations() async {
    try {
      // API endpoint URL
      final url = Uri.parse('https://http://10.0.2.2:8000/api/v1/');

      // Make the GET request
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Parse the response body
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _reservations = data;
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load reservations');
      }
    } catch (e) {
      // Handle errors
      print('Error fetching reservations: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

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
          backgroundColor: Colors.teal,
          title: const Text(title),
        ),
        body: _isLoading ? _buildLoadingIndicator() : _getBodyContent(),
        bottomNavigationBar: BottomNavBar(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(child: CircularProgressIndicator());
  }

  Widget _getBodyContent() {
    if (_selectedIndex == 0) {
      return ListView.builder(
        itemCount: _reservations.length,
        itemBuilder: (context, index) {
          var reservation = _reservations[index];
          return ReservationItemWidget(
            title: reservation['title'],
            reservationNumber: reservation['reservationNumber'],
            usagePeriod: reservation['usagePeriod'],
            quantity: reservation['quantity'],
            titleColor: reservation['titleColor'] == 'red' ? Colors.red : Colors.green,
            backgroundColor: Colors.white,
            reservationDate: DateTime.parse(reservation['reservationDate']),
            machineName: reservation['machineName'],
            period: reservation['period'],
            unitPrice: '\$${reservation['unitPrice']}',
            numberOfDays: reservation['numberOfDays'],
            amount: '\$${reservation['amount']}',
            consumptionTax: '\$${reservation['consumptionTax']}',
            total: '\$${reservation['total']}',
          );
        },
      );
    } else {
      return Center(
        child: Text('Other Screens Placeholder', style: TextStyle(fontSize: 24)),
      );
    }
  }
}