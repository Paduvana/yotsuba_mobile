// services/dashboard_service.dart
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:yotsuba_mobile/services/APIConstants.dart';
import 'package:yotsuba_mobile/services/AuthService.dart';

class DashboardService {
  final authService = AuthService();

  Future<Map<String, dynamic>> fetchDashboardData(BuildContext context) async {
    final url = Uri.parse(ApiConstants.dashboardEndpoint);
    final response = await authService.makeAuthenticatedRequest(url, context);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load dashboard data. Status code: ${response.statusCode}');
    }
  }
}
