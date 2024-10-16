// services/dashboard_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:yotsuba_mobile/services/APIConstants.dart';

class DashboardService {
  Future<Map<String, dynamic>> fetchDashboardData(String token) async {
    final url = Uri.parse(ApiConstants.dashboardEndpoint);
    final response = await http.get(url, headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load dashboard data. Status code: ${response.statusCode}');
    }
  }
}
