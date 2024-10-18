import 'package:flutter/material.dart';
import 'package:yotsuba_mobile/models/reservation_model.dart'; // Import the ReservationModel
import 'package:yotsuba_mobile/widgets/BottomNavBar.dart';
import 'package:yotsuba_mobile/widgets/CustomAppBar.dart';
import 'package:yotsuba_mobile/widgets/DashboardWidget.dart';
import 'package:yotsuba_mobile/services/DashboardService.dart';

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
  final DashboardService _dashboardService = DashboardService();

  @override
  void initState() {
    super.initState();
    _fetchDashboardData(); // Fetch token and then data
  }

  Future<void> _fetchDashboardData() async {
    setState(() {
      _isDashboardLoading = true;
    });

    try {
      final data = await _dashboardService.fetchDashboardData(context);
      setState(() {
        _dashboardData = data;
        _isDashboardLoading = false;
        _errorMessage = null;
      });
    } catch (e) {
      _setError(e.toString());
    }
  }

  void _setError(String message) {
    setState(() {
      _isDashboardLoading = false;
      _errorMessage = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'ダッシュボード',
        hideBackButton: true,
      ),
      body: _isDashboardLoading
          ? _buildLoadingIndicator()
          : _errorMessage != null
              ? _buildErrorIndicator(_errorMessage!)
              : _getBodyContent(),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
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
    List<Widget> reservationWidgets = [];

    // Iterate through the dashboard data keys and use reservationMapping to get title, color, and border
    _dashboardData.forEach((key, reservations) {
      if (reservations != null && reservations is List && reservations.isNotEmpty) {
        reservationWidgets.addAll(_buildReservationWidgets(reservations, key));
      }
    });

    return ListView(children: reservationWidgets);
  }

  List<Widget> _buildReservationWidgets(List<dynamic> reservations, String key) {
    final mapping = ReservationModel.reservationMapping[key];

    if (mapping == null) {
      return []; // Return an empty list if no mapping is found
    }

    // Define the background color based on the reservation type
    Color backgroundColor = key == 'overdue_reservation' ? Colors.red[100]! : Colors.white;

    return reservations.map<Widget>((reservation) {
      return Dashboardwidget(
        title: mapping['name'],
        reservation: reservation,
        titleColor: mapping['color'],
        backgroundColor: backgroundColor, // Use the conditional color
      );
    }).toList();
  }
}
