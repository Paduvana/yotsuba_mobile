import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartItem {
  final int deviceId;
  final String name;
  final double price;
  final int quantity;
  final DateTime startDate;
  final DateTime endDate;
  final int duration;
  final int status;
  String? remarks;

  CartItem({
    required this.deviceId,
    required this.name,
    required this.price,
    required this.quantity,
    required this.startDate,
    required this.endDate,
    required this.duration,
    this.status = 0,
    this.remarks,
  });

  double get total => price * quantity * duration;

  Map<String, dynamic> toJson() => {
        'device': deviceId,
        'name': name,
        'price': price,
        'quantity': quantity,
        'start_date': DateFormat('yyyy-MM-dd').format(startDate),
        'end_date': DateFormat('yyyy-MM-dd').format(endDate),
        'duration': duration,
        'status': status,
        'remarks': remarks,
      };

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        deviceId: json['device'],
        name: json['name'],
        price: json['price'].toDouble(),
        quantity: json['quantity'],
        startDate: DateFormat('yyyy-MM-dd').parse(json['start_date']),
        endDate: DateFormat('yyyy-MM-dd').parse(json['end_date']),
        duration: json['duration'],
        status: json['status'] ?? 0,
        remarks: json['remarks'],
      );
}

class Cart extends ChangeNotifier {
  List<CartItem> items = [];

  double get total => items.fold(0, (sum, item) => sum + item.total);
  int get itemCount => items.length;
  double get tax => total * 0.10; // 10% tax rate
  double get grandTotal => total + tax;

  void addItem(CartItem item) {
    items.add(item);
    saveToStorage();
    notifyListeners();
  }

  void removeItem(CartItem item) {
    items.remove(item);
    saveToStorage();
    notifyListeners();
  }

  void clear() {
    items.clear();
    saveToStorage();
    notifyListeners();
  }

  Future<void> saveToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String jsonString =
          jsonEncode(items.map((e) => e.toJson()).toList());
      await prefs.setString('cart_items', jsonString);
    } catch (e) {
      if (kDebugMode) {
        print('Error saving cart: $e');
      }
    }
  }

  Future<void> loadFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? jsonString = prefs.getString('cart_items');
      if (jsonString != null) {
        final List<dynamic> jsonList = jsonDecode(jsonString);
        items = jsonList.map((json) => CartItem.fromJson(json)).toList();
        notifyListeners(); // Notify listeners after loading
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading cart: $e');
      }
    }
  }
}
