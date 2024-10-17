// services/reservation_service.dart
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:yotsuba_mobile/services/APIConstants.dart';
import 'package:yotsuba_mobile/services/AuthService.dart';

class ReservationService {
  final authService = AuthService();

  Future<Map<String, dynamic>> fetchReservationData(BuildContext context) async {
    final url = Uri.parse(ApiConstants.reservationEndpoint);
    final response = await authService.makeAuthenticatedRequest(url, context);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load reservation data. Status code: ${response.statusCode}');
    }
  }
}
