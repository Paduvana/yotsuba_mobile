import 'package:flutter/material.dart';
import 'LogoutPage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Import for JSON handling
import 'BottomNavBar.dart'; // Import the BottomNavBar
import 'ReservationItemWidget.dart'; // Import the ReservationItemWidget
import 'AuthService.dart';

class HomePage extends StatefulWidget {
  final String accessToken; // Pass the access token from login

  const HomePage({Key? key, required this.accessToken}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  Map<String, dynamic> _dashboardData = {}; // Store dashboard data
  bool _isDashboardLoading = true; // Show loading indicator for dashboard data
  String? _errorMessage; // Store any error messages

  @override
  void initState() {
    super.initState();
    _fetchDashboardData(); // Fetch dashboard data when page is loaded
  }

  Future<void> _fetchDashboardData() async {
    try {
      final String? accessToken = await AuthService().getToken();
      final url = Uri.parse('http://127.0.0.1/api/v1/dashboard/'); // Updated to use emulator IP
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        setState(() {
          _dashboardData = data;
          _isDashboardLoading = false;
          _errorMessage = null; // Clear any previous error messages
        });
      } else {
        setState(() {
          _isDashboardLoading = false;
          _errorMessage = 'Failed to load dashboard data. Please try again.'; // Set error message
        });
      }
    } catch (e) {
      print('Error fetching dashboard data: $e');
      setState(() {
        _isDashboardLoading = false;
        _errorMessage = 'An error occurred while fetching data. Please check your connection.'; // Set error message
      });
    }
  }

  void _onItemTapped(int index) {
    if (index == 3) {
      // Navigate to LogoutPage and pass the access token
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LogoutPage(accessToken: widget.accessToken),
        ),
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
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.teal,
        title: const Text(title),
      ),
      body: _isDashboardLoading
          ? _buildLoadingIndicator()
          : _errorMessage != null
          ? _buildErrorIndicator(_errorMessage!) // Show error if present
          : _getBodyContent(),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(child: CircularProgressIndicator());
  }

  Widget _buildErrorIndicator(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          message,
          style: TextStyle(fontSize: 18, color: Colors.red),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _getBodyContent() {
    if (_selectedIndex == 0) {
      return ListView(
        children: [
          _buildDashboardSection('Overdue Reservations', _dashboardData['overdue_reservation'], Colors.red),
          _buildDashboardSection('Due Today Reservations', _dashboardData['due_today_reservation'], Colors.orange),
          _buildDashboardSection('Due Soon Reservations', _dashboardData['due_soon_reservation'], Colors.blue),
          _buildDashboardSection('In Use Reservations', _dashboardData['in_use_reservation'], Colors.green),
        ],
      );
    } else {
      return Center(
        child: Text('Other Screens Placeholder', style: TextStyle(fontSize: 24)),
      );
    }
  }

  Widget _buildDashboardSection(String title, List<dynamic>? reservations, Color color) {
    if (reservations == null || reservations.isEmpty) {
      return Container(); // No reservations to show
    }

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: reservations.length,
              itemBuilder: (context, index) {
                var reservation = reservations[index];
                return ReservationItemWidget(
                  title: reservation['device_name'], // Use the device name as title
                  reservationNumber: reservation['bill_number'], // Bill number as reservation number
                  usagePeriod: '${reservation['start_date']} - ${reservation['end_date']}', // Start-End date
                  quantity: reservation['quantity'].toString(), // Quantity
                  titleColor: color, // Set color based on status
                  backgroundColor: Colors.white,
                  reservationDate: DateTime.parse(reservation['reserve_date']), // Reservation date
                  machineName: reservation['device_name'], // Machine name
                  period: '${reservation['start_date']} - ${reservation['end_date']}', // Period
                  unitPrice: '\$${reservation['unit_price']}', // Unit price
                  numberOfDays: reservation['duration'], // Duration in days
                  amount: '\$${reservation['sub_total']}', // Subtotal amount
                  consumptionTax: '\$${reservation['tax']}', // Tax
                  total: '\$${reservation['price']}', // Total amount
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}