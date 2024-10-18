// services/reservation_service.dart
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:yotsuba_mobile/services/APIConstants.dart';
import 'package:yotsuba_mobile/services/AuthService.dart';

class ReservationService {
<<<<<<< Updated upstream
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
=======
  final AuthService authService;

  ReservationService({required this.authService});

  Future<Map<String, dynamic>> fetchReservationData(BuildContext context) async {
    final url = Uri.parse(ApiConstants.reservationEndpoint);

    try {
      final response = await authService.makeAuthenticatedRequest(url, context);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load reservation data: ${response.reasonPhrase}');
      }
    } catch (e) {
      // Log the error (You can replace this with a logging framework)
      print('Error fetching reservation data: $e');
      rethrow; // Rethrow to handle it in the UI
    }
  }
}
>>>>>>> Stashed changes
