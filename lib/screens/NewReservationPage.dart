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
  const NewReservationPage({super.key});

  @override
  _NewReservationPageState createState() => _NewReservationPageState();
}

class _NewReservationPageState extends State<NewReservationPage> {
  DateTime? _rentalDate;
  DateTime? _returnDate;
  final bool _isGridView = false;
  final TextEditingController _keywordController = TextEditingController();
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
      _showErrorSnackbar();
    }
  }

  Future<void> _fetchDevices({String? startDate, String? endDate, String? search, String? category}) async {
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
        category: category ?? '',
        search: search ?? '',
      );

      if (mounted) {
        setState(() {
          _devices = response['devices'];
          _isLoading = false;
        });
      }
    } catch (e) {
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

      _fetchDevices(
        startDate: DateFormat('yyyy-MM-dd').format(rental),
        endDate: DateFormat('yyyy-MM-dd').format(return_),
      );
    }
  }

void _handleSearch(String keyword, String category) {
    if (!mounted) return;
    
    setState(() => _isLoading = true);

    final String startDate = _rentalDate != null 
        ? DateFormat('yyyy-MM-dd').format(_rentalDate!)
        : DateFormat('yyyy-MM-dd').format(DateTime.now());
        
    final String endDate = _returnDate != null
        ? DateFormat('yyyy-MM-dd').format(_returnDate!)
        : DateFormat('yyyy-MM-dd').format(DateTime.now().add(const Duration(days: 1)));

    _fetchDevices(
      startDate: startDate,
      endDate: endDate,
      search: keyword,
      category: category,
    );
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
      await CartService(authService: AuthService())
          .checkout(context, cart.items);

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
          SearchFilters(keywordController: _keywordController,onSearch: _handleSearch,),
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
        const BottomNavBar(selectedIndex: 1),
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
