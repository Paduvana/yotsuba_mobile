// lib/services/CategoryService.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'APIConstants.dart';
import 'AuthService.dart';

class CategoryService {
  final AuthService authService;

  CategoryService({required this.authService});

  Future<List<String>> fetchCategories(BuildContext context) async {
    try {
      final response = await authService.makeAuthenticatedRequest(
        Uri.parse(ApiConstants.categoryEndpoint),
        context,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final Set<String> uniqueCategories = data
            .map<String>((item) => item['name'].toString())
            .toSet();
        final List<String> categories = uniqueCategories.toList()..sort();
        return categories;
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching categories: $e');
      }
      throw Exception('Failed to load categories');
    }
  }
}