import 'dart:convert';
import 'package:flutter/material.dart';

class ReservationModel {
  final String startDate;
  final String endDate;
  final int duration;
  final String user;
  final int deviceId;
  final String deviceName;
  final int quantity;
  final int status;
  final double price;
  final String billNumber;
  final double unitPrice;
  final double tax;
  final double subTotal;
  final String reserveDate;

  ReservationModel({
    required this.startDate,
    required this.endDate,
    required this.duration,
    required this.user,
    required this.deviceId,
    required this.deviceName,
    required this.quantity,
    required this.status,
    required this.price,
    required this.billNumber,
    required this.unitPrice,
    required this.tax,
    required this.subTotal,
    required this.reserveDate,
  });

  // Factory constructor for creating a ReservationModel instance from JSON
  factory ReservationModel.fromJson(Map<String, dynamic> json) {
    return ReservationModel(
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      duration: json['duration'] ?? 0,
      user: json['user'] ?? '',
      deviceId: json['device_id'] ?? 0,
      deviceName: json['device_name'] ?? '',
      quantity: json['quantity'] ?? 0,
      status: json['status'] ?? 0,
      price: (json['price'] != null) ? json['price'].toDouble() : 0.0,
      billNumber: json['bill_number'] ?? '',
      unitPrice: (json['unit_price'] != null) ? json['unit_price'].toDouble() : 0.0,
      tax: (json['tax'] != null) ? json['tax'].toDouble() : 0.0,
      subTotal: (json['sub_total'] != null) ? json['sub_total'].toDouble() : 0.0,
      reserveDate: json['reserve_date'] ?? '',
    );
  }

  // Method to convert a ReservationModel instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'start_date': startDate,
      'end_date': endDate,
      'duration': duration,
      'user': user,
      'device_id': deviceId,
      'device_name': deviceName,
      'quantity': quantity,
      'status': status,
      'price': price,
      'bill_number': billNumber,
      'unit_price': unitPrice,
      'tax': tax,
      'sub_total': subTotal,
      'reserve_date': reserveDate,
    };
  }
    static const Map<String, Map<String, dynamic>> reservationMapping = {
    "overdue_reservation": {
      "name": "返却期限が過ぎています。",
      "color": Colors.red,
    },
    "due_today_reservation": {
      "name": "本日返却予定があります。",
      "color": Colors.red,
    },
    "due_soon_reservation": {
      "name": "近日返却予定があります。",
      "color": Colors.orange,
    },
    "in_use_reservation": {
      "name": "ご利用中",
      "color": Colors.green,
    },
  };
}

