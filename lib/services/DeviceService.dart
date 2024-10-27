import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:yotsuba_mobile/services/APIConstants.dart';
import 'package:yotsuba_mobile/services/AuthService.dart';

class DeviceService {
  final AuthService authService;

  DeviceService({required this.authService});

  Future<Map<String, dynamic>> fetchDeviceData(BuildContext context, {
    required String startDate,
    required String endDate,
    required String category,
    required String search
  }) async {
    // Construct the URL with query parameters
    final url = Uri.parse(ApiConstants.deviceListEndpoint)
        .replace(queryParameters: {
      'start_date': startDate,
      'end_date': endDate,
      'category': category,
      'search': search
    });

    try {
      final response = await authService.makeAuthenticatedRequest(url, context);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load devices data: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error fetching reservation data: $e');
      rethrow; 
    }
  }
}
