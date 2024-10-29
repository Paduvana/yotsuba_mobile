import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yotsuba_mobile/models/CartModels.dart';
import 'package:yotsuba_mobile/services/AuthService.dart';
import 'package:yotsuba_mobile/services/CartService.dart';
import 'package:yotsuba_mobile/services/DeviceService.dart';
import 'package:yotsuba_mobile/widgets/BottomNavBar.dart';
import 'package:yotsuba_mobile/widgets/CheckoutDialog.dart';
import 'package:yotsuba_mobile/widgets/CustomAppBar.dart';
import 'package:yotsuba_mobile/widgets/DateSelectionRow.dart';
import 'package:yotsuba_mobile/widgets/ProductGridView.dart';
import 'package:yotsuba_mobile/widgets/SearchFilters.dart';
import 'package:yotsuba_mobile/widgets/ReservationBottomBar.dart';
import 'package:yotsuba_mobile/widgets/GridToggleButton.dart';

class NewReservationPage extends StatefulWidget {
  const NewReservationPage({Key? key}) : super(key: key);

  @override
  _NewReservationPageState createState() => _NewReservationPageState();
}

class _NewReservationPageState extends State<NewReservationPage> {
  DateTime? _rentalDate;
  DateTime? _returnDate;
  bool _isGridView = false;
  final TextEditingController _keywordController = TextEditingController();
  double _totalPrice = 0;
  late final Cart cart;
  List<dynamic> _devices = [];
  bool _isLoading = true;
  bool _isFetching = false;

  final DeviceService deviceService = DeviceService(authService: AuthService());

  @override
  void initState() {
    super.initState();
    cart = Cart();
    _rentalDate = DateTime.now();
    _returnDate = DateTime.now().add(const Duration(days: 1));
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    await cart.loadFromStorage(); // Load saved cart items
    await _fetchInitialDevices();
  }

  @override
  void dispose() {
    cart.dispose();
    _keywordController.dispose();
    super.dispose();
  }

  Future<void> _fetchInitialDevices() async {
    if (!mounted) return;

    try {
      final String startDate = DateFormat('yyyy-MM-dd').format(_rentalDate!);
      final String endDate = DateFormat('yyyy-MM-dd').format(_returnDate!);

      await _fetchDevices(startDate: startDate, endDate: endDate);
    } catch (e) {
      print("Error in initial fetch: $e");
      _showErrorSnackbar();
    }
  }

  Future<void> _fetchDevices({String? startDate, String? endDate}) async {
    if (!mounted || _isFetching) return;

    try {
      _isFetching = true;

      if (mounted) {
        setState(() {
          _isLoading = true;
          _devices = [];
        });
      }

      final response = await deviceService.fetchDeviceData(
        context,
        startDate: startDate!,
        endDate: endDate!,
        category: '',
        search: _keywordController.text,
      );

      if (mounted) {
        setState(() {
          _devices = response['devices'];
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching devices: $e");
      if (mounted) {
        setState(() => _isLoading = false);
        _showErrorSnackbar();
      }
    } finally {
      _isFetching = false;
    }
  }

  void _handleDateChange(DateTime? rental, DateTime? return_) {
    setState(() {
      _rentalDate = rental;
      _returnDate = return_;
    });

    if (rental != null && return_ != null) {
      cart.clear();
      setState(() => _totalPrice = 0);

      _fetchDevices(
        startDate: DateFormat('yyyy-MM-dd').format(rental),
        endDate: DateFormat('yyyy-MM-dd').format(return_),
      );
    }
  }

  void _handleAddToCart(int deviceId, String name, double price, int quantity) {
    print('Adding to cart - Quantity: $quantity');
    final cartItem = CartItem(
      deviceId: deviceId,
      name: name,
      price: price,
      quantity: quantity,
      startDate: _rentalDate!,
      endDate: _returnDate!,
      duration: _returnDate!.difference(_rentalDate!).inDays,
    );

    setState(() {
      final existingIndex =
          cart.items.indexWhere((item) => item.deviceId == deviceId);
      if (existingIndex >= 0) {
        cart.removeItem(cart.items[existingIndex]);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$name をカートから削除しました')),
        );
      } else {
        cart.addItem(cartItem);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$name をカートに追加しました')),
        );
      }
      print('Cart items after update:');
      for (var item in cart.items) {
        print(
            '${item.name}: ${item.quantity} * ${item.price} * ${item.duration}');
      }
      cart.saveToStorage();
    });
  }

  bool _isItemInCart(int deviceId) {
    return cart.items.any((item) => item.deviceId == deviceId);
  }

  Widget _buildCartItemsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: cart.items
          .map((item) => Card(
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  title: Text(item.name),
                  subtitle: Text(
                      '${item.quantity}個 × ¥${item.price} × ${item.duration}日'),
                  trailing: Text(
                    '¥${item.total.toStringAsFixed(0)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildTotalSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('小計:'),
            Text('¥${cart.total.toStringAsFixed(0)}'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('消費税:'),
            Text('¥${(cart.total * 0.1).toStringAsFixed(0)}'),
          ],
        ),
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('合計:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(
              '¥${(cart.total * 1.1).toStringAsFixed(0)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _processCheckout() async {
    try {
      setState(() => _isLoading = true); // Start loading

      await CartService(authService: AuthService())
          .checkout(context, cart.items);

      if (mounted) {
        setState(() {
          _isLoading = false; // Stop loading
          cart.clear();
          cart.saveToStorage();
        });

        // Close the dialog
        Navigator.pop(context);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('予約が完了しました'),
            backgroundColor: Colors.green,
          ),
        );

        // Optionally refresh the devices list
        _fetchInitialDevices();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false); // Stop loading

        // Close the dialog if it's still open
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }

        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('エラーが発生しました: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildDateRangeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '予約期間',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Text(DateFormat('yyyy/MM/dd').format(_rentalDate!)),
            const Text(' 〜 '),
            Text(DateFormat('yyyy/MM/dd').format(_returnDate!)),
          ],
        ),
      ],
    );
  }

  void _proceedToReservationConfirmation() {
    if (cart.itemCount == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('カートにアイテムを追加してください')),
      );
      return;
    }

    _showCheckoutDialog();
  }

void _showCheckoutDialog() async {
  if (cart.items.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('カートにアイテムを追加してください')),
    );
    return;
  }

  final shouldProceed = await showDialog<bool>(
    context: context,
    barrierDismissible: !_isLoading,
    builder: (context) => CheckOutDialog(
      items: cart.items,
      startDate: _rentalDate!,
      endDate: _returnDate!,
    ),
  );

  if (shouldProceed == true && mounted) {
    await _processCheckout();
  }
}

  int _calculateDaysBetween(DateTime start, DateTime end) {
    return end.difference(start).inDays + 1;
  }

  String _formatDateRange(DateTime start, DateTime end) {
    final formatter = DateFormat('yyyy/MM/dd');
    return '${formatter.format(start)} - ${formatter.format(end)}';
  }

  void _showErrorSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('デバイスの取得中にエラーが発生しました。'),
        backgroundColor: Colors.red,
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('新規予約', style: TextStyle(fontWeight: FontWeight.bold)),
      centerTitle: true,
      backgroundColor: Colors.teal,
      foregroundColor: Colors.white,
      actions: [
        GridToggleButton(
          isGridView: _isGridView,
          onToggle: (newValue) => setState(() => _isGridView = newValue),
        ),
      ],
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DateSelectionRow(
            rentalDate: _rentalDate,
            returnDate: _returnDate,
            onDateChange: _handleDateChange,
          ),
          const SizedBox(height: 16),
          SearchFilters(keywordController: _keywordController),
          const SizedBox(height: 16),
          Expanded(
            child: _isGridView
                ? ProductsGridView(
                    devices: _devices,
                    onAddToCart: _handleAddToCart,
                  )
                : ProductsListView(
                    devices: _devices,
                    onAddToCart: _handleAddToCart,
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ReservationBottomBar(
          onProceed: _proceedToReservationConfirmation,
          cart: cart,
        ),
        BottomNavBar(selectedIndex: 1),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: '新規予約', hideBackButton: true),
      body: _buildBody(),
      bottomNavigationBar: ListenableBuilder(
        listenable: cart,
        builder: (context, child) => _buildBottomNavigation(),
      ),
    );
  }
}
