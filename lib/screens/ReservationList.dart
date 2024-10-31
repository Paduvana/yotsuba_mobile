import 'package:flutter/material.dart';
import 'package:yotsuba_mobile/widgets/BottomNavBar.dart';
import 'package:yotsuba_mobile/services/ReservationService.dart';
import 'package:yotsuba_mobile/services/AuthService.dart';
import 'package:yotsuba_mobile/widgets/CustomAppBar.dart';
import 'package:yotsuba_mobile/widgets/ReservationDetailsTable.dart';

class ReservationList extends StatefulWidget {
  const ReservationList({super.key});

  @override
  _ReservationListState createState() => _ReservationListState();
}

class _ReservationListState extends State<ReservationList> {
  bool showCurrent = true; // Toggle between Current and Past reservations
  final int _selectedIndex = 2; // Start with the third tab selected
  List<bool> isSelected = [true, false]; // For ToggleButtons

  Map<String, dynamic> _reservationData = {};
  bool _isLoading = true;
  String? _errorMessage;

  final AuthService _authService = AuthService();
  late final ReservationService _reservationService;

  @override
  void initState() {
    super.initState();
    _reservationService = ReservationService(authService: _authService);
    _fetchReservationData();
  }

  Future<void> _fetchReservationData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final data = await _reservationService.fetchReservationData(context);
      setState(() {
        _reservationData = data;
        _isLoading = false;
        _errorMessage = null;
      });
    } catch (e) {
      _setError(e.toString());
    }
  }

  void _setError(String message) {
    setState(() {
      _isLoading = false;
      _errorMessage = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: '予約確認', hideBackButton: true),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : _buildReservationDetails(),
      bottomNavigationBar: BottomNavBar(selectedIndex: _selectedIndex),
    );
  }

  Widget _buildReservationDetails() {
    List<Map<String, dynamic>> reservationsToShow = (showCurrent
                ? _reservationData['current_reservations']
                : _reservationData['past_reservations'])
            ?.cast<Map<String, dynamic>>() ??
        [];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Toggle Buttons for Current and Past Reservations
          ToggleButtons(
            isSelected: isSelected,
            onPressed: (int index) {
              setState(() {
                for (int i = 0; i < isSelected.length; i++) {
                  isSelected[i] = i == index;
                }
                showCurrent = index == 0;
              });
            },
            color: Colors.green,
            selectedColor: Colors.white,
            fillColor: Colors.green,
            borderRadius: BorderRadius.circular(10),
            borderColor: Colors.green,
            selectedBorderColor: Colors.green,
            children: const [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text('現在の予約'),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text('過去の予約'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical, // Enable vertical scrolling
              child: ReservationDetailsTable(reservations: reservationsToShow),
            ),
          ),
        ],
      ),
    );
  }
}
