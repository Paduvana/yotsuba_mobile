import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yotsuba_mobile/services/AuthService.dart';
import 'package:yotsuba_mobile/services/DeviceService.dart';
import 'package:yotsuba_mobile/widgets/BottomNavBar.dart';
import 'package:yotsuba_mobile/widgets/SearchFilters.dart';
import 'package:yotsuba_mobile/widgets/ReservationBottomBar.dart';
import 'package:yotsuba_mobile/widgets/ProductWidget.dart';
import 'package:yotsuba_mobile/widgets/GridToggleButton.dart';
import 'package:yotsuba_mobile/widgets/CartDetailsDialog.dart';

class NewReservationPage extends StatefulWidget {
  @override
  _NewReservationPageState createState() => _NewReservationPageState();
}

class _NewReservationPageState extends State<NewReservationPage> {
  DateTime? _rentalDate;
  DateTime? _returnDate;
  bool _isGridView = false;
  final TextEditingController _keywordController = TextEditingController();
  double _totalPrice = 0;
  final ShoppingCart cart = ShoppingCart();
  List<dynamic> _devices = []; // Store fetched devices
  bool _isLoading = true; // Add loading state

  final DeviceService deviceService = DeviceService(authService: AuthService()); // Initialize service

  @override
  void initState() {
    super.initState();
    _fetchInitialDevices(); // Call the device fetch method
  }

    Future<void> _fetchDevices({String? startDate, String? endDate}) async {
    try {
      setState(() {
        _isLoading = true;
        _devices = []; // Clear existing devices while loading
      });

      const category = '';
      final search = _keywordController.text;

      final response = await deviceService.fetchDeviceData(
        context,
        startDate: startDate!,
        endDate: endDate!,
        category: category,
        search: search
      );

      setState(() {
        _devices = response['devices'];
        _isLoading = false;
      });
    } catch (e) {
      print("Error fetching devices: $e");
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('デバイスの取得中にエラーが発生しました。'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _fetchInitialDevices() async {
    try {
      final DateTime today = DateTime.now();
      final String startDate = DateFormat('yyyy-MM-dd').format(today);
      final DateTime tomorrow = today.add(const Duration(days: 1));
      final String endDate = DateFormat('yyyy-MM-dd').format(tomorrow);
      
      await _fetchDevices(startDate: startDate, endDate: endDate);
    } catch (e) {
      print("Error in initial fetch: $e");
    }
  }

void _proceedToReservationConfirmation() {
    if (_rentalDate == null || _returnDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('貸出日と返却日を選択してください')),
      );
      return;
    }
    // Implement navigation to confirmation screen
  }

  void _updateTotalPrice() {
    _totalPrice = cart.items.fold(0, (sum, product) => sum + (product.price * product.quantity)); // Update total price calculation
  }

   void _checkAndFetchDevices() {
    if (_rentalDate != null && _returnDate != null) {
      final String startDate = DateFormat('yyyy-MM-dd').format(_rentalDate!);
      final String endDate = DateFormat('yyyy-MM-dd').format(_returnDate!);
      //cart.clear();
      _updateTotalPrice();
      
      _fetchDevices(startDate: startDate, endDate: endDate);
    }
  }

 Future<void> _selectDate(BuildContext context, bool isRentalDate) async {
    DateTime initialDate;
    DateTime firstDate;
    DateTime lastDate;

    if (isRentalDate) {
      initialDate = _rentalDate ?? DateTime.now();
      firstDate = DateTime.now();
      lastDate = _returnDate ?? DateTime(2101);
    } else {
      initialDate = _returnDate ?? (_rentalDate?.add(const Duration(days: 1)) ?? DateTime.now().add(const Duration(days: 1)));
      firstDate = _rentalDate?.add(const Duration(days: 1)) ?? DateTime.now();
      lastDate = DateTime(2101);
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null) {
      setState(() {
        if (isRentalDate) {
          _rentalDate = picked;
          // Reset return date if it's before the new rental date
          if (_returnDate != null && _returnDate!.isBefore(picked)) {
            _returnDate = null;
          }
        } else {
          _returnDate = picked;
        }
      });

      // Check and fetch only when both dates are selected
      _checkAndFetchDevices();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('新規予約', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          GridToggleButton(
            isGridView: _isGridView,
            onToggle: (newValue) {
              setState(() {
                _isGridView = newValue;
              });
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // Show loader while fetching data
          : Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _dateSelectionColumn('貸出日', _rentalDate, true),
                      _dateSelectionColumn('返却日', _returnDate, false),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SearchFilters(keywordController: _keywordController),
                  const SizedBox(height: 16),
                  Expanded(
                    child: _isGridView
                        ? GridView.count(
                            crossAxisCount: 2,
                            children: _buildProductWidgets(),
                          )
                        : ListView(children: _buildProductWidgets()),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ReservationBottomBar(
            totalPrice: _totalPrice,
            onProceed: _proceedToReservationConfirmation,
            cart: cart,
          ),
          BottomNavBar(selectedIndex: 1),
        ],
      ),
    );
  }

Widget _dateSelectionColumn(String title, DateTime? date, bool isRentalDate) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _selectDate(context, isRentalDate),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: Row(
              children: [
                Text(
                  date != null ? DateFormat('yyyy/MM/dd').format(date) : '日付を選択',
                  style: TextStyle(
                    fontSize: 16,
                    color: date != null ? Colors.black : Colors.grey,
                  ),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.calendar_month_rounded, size: 24),
              ],
            ),
          ),
        ),
        if (isRentalDate && _rentalDate != null && _returnDate == null)
          const Padding(
            padding: EdgeInsets.only(top: 4),
            child: Text(
              '返却日を選択してください',
              style: TextStyle(
                fontSize: 12,
                color: Colors.blue,
              ),
            ),
          ),
      ],
    );
  }

  List<Widget> _buildProductWidgets() {
  return _devices.map((device) {
    // Check if essential fields are available, otherwise use default or skip
    final deviceName = device['name'] ?? 'Unknown Device';
    final reservedDates = device['reserved_dates'] ?? [];
    final devicePrice = double.tryParse(device['price'].toString()) ?? 0.0;
    final imageGallery = (device['images'] as List<dynamic>?)
        ?.map((img) => img['path'] as String?)
        .whereType<String>()
        .toList() ?? ['assets/images/default_image.png'];
    final availableCount = device['available_count'] ?? 1;
    // If any critical information like price is missing, handle accordingly
    if (devicePrice == 0.0) {
      print('Warning: Device "${deviceName}" has an invalid price.');
      return const SizedBox.shrink(); // Return empty widget if the device is invalid
    }

    // Create ProductWidget if validations are passed
    return ProductWidget(
      title: deviceName,
      imagePath: imageGallery.isNotEmpty ? imageGallery[0] : 'assets/images/default_image.png',
      basePrice: devicePrice,
      imageGallery: imageGallery,
      availableCount: availableCount,
      reservedDates: reservedDates,
      onAddToCart: (quantity) {
        // Perform additional validation on quantity if needed
        if (quantity <= 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Invalid quantity selected for $deviceName')),
          );
          return;
        }

        cart.addItem(CartProduct(
          title: deviceName,
          price: devicePrice,
          quantity: quantity,
          days: 3,
          period: '2024/12/24 - 2024/12/27',
        ));
        _updateTotalPrice();
      },
    );
  }).toList();
}

}
