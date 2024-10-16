class ReservationModel {
  final String startDate;
  final String endDate;
  final int duration;
  final String user;
  final int deviceId;
  final String deviceName;
  final int quantity;
  final int status;
  final String price;
  final String billNumber;
  final String unitPrice;
  final String tax;
  final String subTotal;
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
      startDate: json['start_date'],
      endDate: json['end_date'],
      duration: json['duration'],
      user: json['user'],
      deviceId: json['device_id'],
      deviceName: json['device_name'],
      quantity: json['quantity'],
      status: json['status'],
      price: json['price'],
      billNumber: json['bill_number'],
      unitPrice: json['unit_price'],
      tax: json['tax'],
      subTotal: json['sub_total'],
      reserveDate: json['reserve_date'],
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
}
