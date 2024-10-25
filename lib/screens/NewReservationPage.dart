import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  final ShoppingCart cart = ShoppingCart(); // Create an instance of ShoppingCart

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
            cart: cart, // Pass the cart instance here
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
    return [
      ProductWidget(
        title: 'トランジット',
        imagePath: 'asset/images/Transit.png',
        basePrice: 1000,
        imageGallery: [
          'asset/images/Transit.png',
          'asset/images/Transit2.png',
          'asset/images/Transit3.png',
        ],

        onAddToCart: (quantity) { // Pass quantity
          cart.addItem(CartProduct(
            title: 'トランジット',
            price: 1000,
            quantity: quantity, // Use selected quantity
            days: 3,
            period: '2024/10/24 - 2024/10/27',
          )); // Add to cart
          _updateTotalPrice(); // Update total price after adding
        },
      ),
      ProductWidget(
        title: 'マイクロゲージ',
        imagePath: 'asset/images/tripod.png',
        basePrice: 1200,
        imageGallery: [
          'asset/images/Transit.png',
          'asset/images/Transit2.png',
          'asset/images/Transit3.png',
        ],
        onAddToCart: (quantity) { // Pass quantity
          cart.addItem(CartProduct(
            title: 'マイクロゲージ',
            price: 1200,
            quantity: quantity, // Use selected quantity
            days: 3,
            period: '2024/10/24 - 2024/10/27',
          )); // Add to cart
          _updateTotalPrice(); // Update total price after adding
        },
      ),
      ProductWidget(
        title: 'Product 3',
        imagePath: 'asset/images/taper_guage.png',
        basePrice: 1500,
        imageGallery: [
          'asset/images/Transit.png',
          'asset/images/Transit2.png',
          'asset/images/Transit3.png',
        ],
        onAddToCart: (quantity) { // Pass quantity
          cart.addItem(CartProduct(
            title: 'Product 3',
            price: 1500,
            quantity: quantity, // Use selected quantity
            days: 3,
            period: '2024/10/24 - 2024/10/27',
          )); // Add to cart
          _updateTotalPrice(); // Update total price after adding
        },
      ),
      ProductWidget(
        title: 'Product 4',
        imagePath: 'asset/images/level.png',
        basePrice: 1500,
        imageGallery: [
          'asset/images/Transit.png',
          'asset/images/Transit2.png',
          'asset/images/Transit3.png',
        ],
        onAddToCart: (quantity) { // Pass quantity
          cart.addItem(CartProduct(
            title: 'Product 4',
            price: 1500,
            quantity: quantity, // Use selected quantity
            days: 3,
            period: '2024/10/24 - 2024/10/27',
          )); // Add to cart
          _updateTotalPrice(); // Update total price after adding
        },
      ),
    ];
  }
}