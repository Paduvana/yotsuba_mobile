import 'package:flutter/material.dart';
import 'package:yotsuba_mobile/widgets/BottomNavBar.dart';
import 'package:yotsuba_mobile/widgets/ReservationItemWidget.dart';
import 'package:yotsuba_mobile/services/AuthService.dart';
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
    _loadTokenAndFetchData(); // Fetch token and then data
  }

  Future<void> _loadTokenAndFetchData() async {
    try {
      final token = await AuthService().getToken();
      if (token != null) {
        await _fetchDashboardData(token);
      } else {
        _setError('No access token found');
      }
    } catch (e) {
      _setError('Error retrieving token: $e');
    }
  }

  Future<void> _fetchDashboardData(String token) async {
    setState(() {
      _isDashboardLoading = true;
    });

    try {
      final data = await _dashboardService.fetchDashboardData(token);
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
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.teal,
        title: const Text('ダッシュボード'),
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
        return ListView(
          children: [
            if (_dashboardData['overdue_reservation'] != null)
              ..._buildReservationWidgets(
                _dashboardData['overdue_reservation'],
                title: '返却期限が過ぎてしまいました。',
                titleColor: Colors.red,
                backgroundColor: Colors.red[100]!,
              ),
            if (_dashboardData['due_today_reservation'] != null)
              ..._buildReservationWidgets(
                _dashboardData['due_today_reservation'],
                title: '本日返却予定があります。',
                titleColor: Colors.orange,
                backgroundColor: Colors.white,
              ),
            if (_dashboardData['due_soon_reservation'] != null)
              ..._buildReservationWidgets(
                _dashboardData['due_soon_reservation'],
                title: '近日返却予定があります。',
                titleColor: Colors.blue,
                backgroundColor: Colors.white,
              ),
            if (_dashboardData['in_use_reservation'] != null)
              ..._buildReservationWidgets(
                _dashboardData['in_use_reservation'],
                title: 'ご利用中',
                titleColor: Colors.green,
                backgroundColor: Colors.white,
              ),
          ],
        );
  }

  List<Widget> _buildReservationWidgets(List<dynamic> reservations,
      {required String title,
      required Color titleColor,
      required Color backgroundColor}) {
    return reservations.map((reservation) {
      return ReservationItemWidget(
        title: title,
        reservationNumber: reservation['bill_number'],
        usagePeriod: '${reservation['start_date']} ~ \n${reservation['end_date']}',
        quantity: reservation['quantity'].toString(),
        amount: '¥${reservation['price']}',
        consumptionTax: '¥${reservation['tax']}',
        total: '¥${reservation['sub_total']}',
        machineName: reservation['device_name'],
        period: 'Daily',
        unitPrice: '¥${reservation['unit_price']}',
        numberOfDays: reservation['duration'],
        reservationDate: DateTime.parse(reservation['reserve_date']),
        titleColor: titleColor,
        backgroundColor: backgroundColor,
      );
    }).toList();
  }
}
