import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'LogoutPage.dart';
import 'AuthService.dart'; // Import AuthService for token handling
import 'BottomNavBar.dart';
import 'ReservationItemWidget.dart';

class Dashboard extends StatefulWidget {

  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;
  Map<String, dynamic> _dashboardData = {};
  bool _isDashboardLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadTokenAndFetchData(); // Fetch token and then data
  }

  Future<void> _loadTokenAndFetchData() async {
    try {
      final token = await AuthService().getToken(); // Use AuthService to retrieve token
      if (token != null) {
        await _fetchDashboardData(token); // Fetch data with token
      } else {
        _setError('No access token found');
      }
    } catch (e) {
      _setError('Error retrieving token: $e');
    }
  }

  Future<void> _fetchDashboardData(String token) async {
    setState(() {
      _isDashboardLoading = true; // Show loading indicator
    });

    try {
      final url = Uri.parse('http://127.0.0.1:8000/api/v1/dashboard/');
      final response = await http.get(url, headers: {'Authorization': 'Bearer $token'});

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _dashboardData = data;
          _isDashboardLoading = false;
          _errorMessage = null;
        });
      } else {
        _setError('Failed to load dashboard data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      _setError('An error occurred while fetching data: $e');
    }
  }

  void _setError(String message) {
    setState(() {
      _isDashboardLoading = false;
      _errorMessage = message;
    });
  }

  void _onItemTapped(int index) {
    if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LogoutPage()),
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
          ? _buildErrorIndicator(_errorMessage!)
          : _getBodyContent(),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildErrorIndicator(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          message,
          style: const TextStyle(fontSize: 18, color: Colors.red),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _getBodyContent() {
    switch (_selectedIndex) {
      case 0:
        return ListView(
          children: [
            ReservationItemWidget(
              title: '返却期限が過ぎてしまいました。',
              reservationNumber: '0000',
              usagePeriod: '2024-10-01 - 2024-10-03',
              quantity: '1',
              amount: '¥1000',
              consumptionTax: '¥100',
              total: '¥1100',
              machineName: 'Machine A',
              period: 'Daily',
              unitPrice: '¥1000',
              numberOfDays: 2,
              reservationDate: DateTime.now(),
              titleColor: Colors.red,
              backgroundColor: Colors.red[100]!,
            ),

            ReservationItemWidget(
              title: '本日返却予定があります。',
              reservationNumber: '0001',
              usagePeriod: '2024-10-03 - 2024-10-05',
              quantity: '2',
              amount: '¥1000',
              consumptionTax: '¥100',
              total: '¥1100',
              machineName: 'Machine A',
              period: 'Daily',
              unitPrice: '¥1000',
              numberOfDays: 2,
              reservationDate: DateTime.now(),
              titleColor: Colors.orange,
              backgroundColor: Colors.white,
            ),
            ReservationItemWidget(
              title: '近日返却予定があります。',
              reservationNumber: '0002',
              usagePeriod: '2024-10-05 - 2024-10-06',
              quantity: '3',
              amount: '¥1000',
              consumptionTax: '¥100',
              total: '¥1100',
              machineName: 'Machine A',
              period: 'Daily',
              unitPrice: '¥1000',
              numberOfDays: 2,
              reservationDate: DateTime.now(),
              titleColor: Colors.blue,
              backgroundColor: Colors.white,
            ),
            ReservationItemWidget(
              title: 'ご利用中',
              reservationNumber: '0003',
              usagePeriod: '2024-10-01 - 2024-10-06',
              quantity: '4',
              amount: '¥1000',
              consumptionTax: '¥100',
              total: '¥1100',
              machineName: 'Machine A',
              period: 'Daily',
              unitPrice: '¥1000',
              numberOfDays: 2,
              reservationDate: DateTime.now(),
              titleColor: Colors.green,
              backgroundColor: Colors.white,

            ),
          ],
        );
      case 1:
        return const Center(child: Text('New Reservation Screen', style: TextStyle(fontSize: 24)));
      case 2:
        return const Center(child: Text('Reservation Confirmed Screen', style: TextStyle(fontSize: 24)));
      case 3:
        return const Center(child: Text('Settings Screen', style: TextStyle(fontSize: 24)));
      default:
        return Container();
    }
  }
}