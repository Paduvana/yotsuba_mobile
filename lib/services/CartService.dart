// lib/services/cart_service.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yotsuba_mobile/models/CartModels.dart';
import 'package:yotsuba_mobile/services/APIConstants.dart';
import 'package:yotsuba_mobile/services/AuthService.dart';

class CartService {
  final AuthService authService;

  CartService({required this.authService});

  Future<void> checkout(BuildContext context, List<CartItem> items) async {
    try {
      final url = Uri.parse(ApiConstants.cartEndpoint);
      final jsonItems = items.map((item) => item.toJson()).toList();
      final response = await authService.makeAuthenticatedRequest(
        url,
        context,
        method: 'POST',
        body: jsonItems,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        await _clearStoredCart();
        return;
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['detail'] ?? 'Checkout failed');
      }
    } catch (e) {
      print('Checkout error: $e');
      rethrow;
    }
  }

  Future<void> _clearStoredCart() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('cart_items');
  }
}
