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
    _fetchDevices(); // Call the device fetch method
  }

  Future<void> _fetchDevices() async {
    try {
      final DateTime today = DateTime.now();
      final String startDate = DateFormat('yyyy-MM-dd').format(today);
      final DateTime tomorrow = today.add(const Duration(days: 1));
      final String endDate = DateFormat('yyyy-MM-dd').format(tomorrow);
      const category = '';
      const search = '';

      final response = await deviceService.fetchDeviceData(
        context,
        startDate: startDate,
        endDate: endDate,
        category: category,
        search: search
      );

      setState(() {
        _devices = response['devices'];
        print(_devices);

        _isLoading = false; // Stop loading once data is fetched
      });
    } catch (e) {
      print("Error fetching devices: $e");
      setState(() {
        _isLoading = false;
      });
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
Future<void> _selectDate(BuildContext context, bool isRentalDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isRentalDate) {
          _rentalDate = picked;
        } else {
          _returnDate = picked;
        }
      });
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
            ),
            child: Row(
              children: [
                Text(
                  date != null ? DateFormat('yyyy/MM/dd').format(date) : 'Selected Date',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.calendar_month_rounded, size: 24),
              ],
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
