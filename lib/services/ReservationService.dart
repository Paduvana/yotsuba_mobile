// services/reservation_service.dart
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:yotsuba_mobile/services/APIConstants.dart';
import 'package:yotsuba_mobile/services/AuthService.dart';

class ReservationService {
  final AuthService authService;

  ReservationService({required this.authService});

  Future<Map<String, dynamic>> fetchReservationData(
      BuildContext context) async {
    final url = Uri.parse(ApiConstants.reservationEndpoint);

    try {
      final response = await authService.makeAuthenticatedRequest(url, context);
      if (response.statusCode == 200) {
        return jsonDecode(utf8.decode(response.bodyBytes));
      } else {
        throw Exception(
            'Failed to load reservation data: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error fetching reservation data: $e');
      rethrow;
    }
  }
}
