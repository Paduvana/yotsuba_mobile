import 'package:flutter/material.dart';
import 'package:yotsuba_mobile/models/CartModels.dart';
import 'package:yotsuba_mobile/widgets/ProductWidget.dart';

class ProductsListView extends StatelessWidget {
  final List<dynamic> devices;
  final Function(CartItem) onAddToCart; 

  const ProductsListView({
    Key? key,
    required this.devices,
    required this.onAddToCart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: devices.length,
      itemBuilder: (context, index) {
        final device = devices[index];
        return ProductWidget(
          deviceId: device['id'],
          title: device['name'] ?? 'Unknown Device',
          imagePath: device['images']?.isNotEmpty 
              ? device['images'][0]['path'] 
              : 'assets/images/default_image.png',
          basePrice: double.tryParse(device['price'].toString()) ?? 0.0,
          imageGallery: (device['images'] as List<dynamic>?)
              ?.map((img) => img['path'] as String?)
              .whereType<String>()
              .toList() ?? [],
          availableCount: device['available_count'] ?? 1,
          reservedDates: device['reserved_dates'] ?? [],
          onAddToCart: onAddToCart, isInCart: false,
        );
      },
    );
  }
}