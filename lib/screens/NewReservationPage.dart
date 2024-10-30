import 'dart:async';
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
import 'package:yotsuba_mobile/widgets/ProductList.dart';
import 'package:yotsuba_mobile/widgets/SearchFilters.dart';
import 'package:yotsuba_mobile/widgets/ReservationBottomBar.dart';

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
  Timer? _debounceTimer;

  final DeviceService deviceService = DeviceService(authService: AuthService());

  @override
  void initState() {
    super.initState();
    cart = Cart();
    _rentalDate = DateTime.now();
    _returnDate = DateTime.now().add(const Duration(days: 1));
    _loadInitialData();

    // Add listener for the keyword search controller with debounce
    _keywordController.addListener(_onSearchKeywordChanged);
  }

  @override
  void dispose() {
    cart.dispose();
    _keywordController.removeListener(_onSearchKeywordChanged);
    _keywordController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    await cart.loadFromStorage(); // Load saved cart items
    await _fetchInitialDevices();
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

  Future<void> _fetchDevices({String? startDate, String? endDate, String keyword = ''}) async {
    if (!mounted || _isFetching) return;

    try {
      _isFetching = true;
      setState(() {
        _isLoading = true;
        _devices = [];
      });

      final response = await deviceService.fetchDeviceData(
        context,
        startDate: startDate!,
        endDate: endDate!,
        category: '',
        search: keyword,
      );

      setState(() {
        _devices = response['devices'];
        _isLoading = false;
      });
    } catch (e) {
      print("Error fetching devices: $e");
      setState(() => _isLoading = false);
      _showErrorSnackbar();
    } finally {
      _isFetching = false;
    }
  }

  void _onSearchKeywordChanged() {
    // Cancel any existing timer to debounce
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    // Start a new timer
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      if (mounted) {
        _fetchDevices(
          startDate: DateFormat('yyyy-MM-dd').format(_rentalDate!),
          endDate: DateFormat('yyyy-MM-dd').format(_returnDate!),
          keyword: _keywordController.text,
        );
      }
    });
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
        keyword: _keywordController.text,
      );
    }
  }

  void _handleAddToCart(CartItem item) {
    final CartItem cartItem = item.startDate == DateTime.now()
        ? CartItem(
      deviceId: item.deviceId,
      name: item.name,
      price: item.price,
      quantity: item.quantity,
      startDate: _rentalDate!,
      endDate: _returnDate!,
      duration: _returnDate!.difference(_rentalDate!).inDays + 1,
    )
        : item;

    setState(() {
      final existingIndex =
      cart.items.indexWhere((i) => i.deviceId == cartItem.deviceId);

      if (existingIndex >= 0) {
        cart.removeItem(cart.items[existingIndex]);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${cartItem.name} をカートから削除しました')),
        );
      } else {
        cart.addItem(cartItem);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${cartItem.name} をカートに追加しました')),
        );
      }
      cart.saveToStorage();
    });
  }

  Future<void> _processCheckout() async {
    if (!mounted) return;
    try {
      setState(() => _isLoading = true);
      await CartService(authService: AuthService()).checkout(context, cart.items);

      if (mounted) {
        setState(() {
          _isLoading = false;
          cart.clear();
          cart.saveToStorage();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('予約が完了しました'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
        _fetchInitialDevices();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('エラーが発生しました: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
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

  void _showErrorSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('デバイスの取得中にエラーが発生しました。'),
        backgroundColor: Colors.red,
      ),
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
      bottomNavigationBar: ListView(
        shrinkWrap: true,
        children: [_buildBottomNavigation()],
      ),
    );
  }
}