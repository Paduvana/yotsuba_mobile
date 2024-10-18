import 'package:flutter/material.dart';
import 'package:yotsuba_mobile/widgets/BottomNavBar.dart';
import 'package:yotsuba_mobile/services/ReservationService.dart';
import 'package:yotsuba_mobile/services/AuthService.dart';

class ReservationConfirmation extends StatefulWidget {
  const ReservationConfirmation({Key? key}) : super(key: key);

  @override
  _ReservationConfirmationState createState() => _ReservationConfirmationState();
}

class _ReservationConfirmationState extends State<ReservationConfirmation> {
  bool showCurrent = true; // Toggle between Current and Past reservations
  int _selectedIndex = 2; // Start with the third tab selected
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
      appBar: AppBar(
        title: const Text('予約確認'),
        foregroundColor: Colors.white,
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(child: Text(_errorMessage!))
          : _buildReservationDetails(),
      bottomNavigationBar: BottomNavBar(selectedIndex: _selectedIndex),
    );
  }

  Widget _buildReservationDetails() {
    List<dynamic> reservationsToShow = showCurrent
        ? _reservationData['currentReservations']
        : _reservationData['pastReservations'];

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
            borderColor: Colors.green.shade900,
            selectedBorderColor: Colors.green.shade900,
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

          // Header Row
          const Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  '予約No.',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  '利用期間',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  '数量',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  '詳細',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 1),
          Divider(thickness: 1, color: Colors.black),
          const SizedBox(height: 1),

          // List of Reservations
          Expanded(
            child: ListView.builder(
              itemCount: reservationsToShow.length,
              itemBuilder: (context, index) {
                final reservation = reservationsToShow[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      Expanded(flex: 2, child: Text(reservation['reservationNo'])),
                      Expanded(flex: 2, child: Text(reservation['usagePeriod'])),
                      Expanded(flex: 1, child: Text(reservation['quantity'].toString())),
                      Expanded(
                        flex: 1,
                        child: Container(
                          width: 30,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white54,
                            border: Border.all(color: Colors.black, width: 2),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.more_horiz),
                            onPressed: () {
                              // Handle button press for reservation details
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}