// lib/widgets/new_reservation/products_grid_view.dart
import 'package:flutter/material.dart';
import 'package:yotsuba_mobile/models/CartModels.dart';
import 'package:yotsuba_mobile/widgets/ProductWidget.dart';

class ProductsGridView extends StatelessWidget {
  final List<dynamic> devices;
  final Function(CartItem) onAddToCart;

  const ProductsGridView({
    super.key,
    required this.devices,
    required this.onAddToCart,
  });

  List<Widget> _buildProductWidgets(BuildContext context) {
    return devices.map((device) {
      final deviceId = device['id'] ?? 0;
      final deviceName = device['name'] ?? 'Unknown Device';
      final reservedDates = device['reserved_dates'] ?? [];
      final devicePrice = double.tryParse(device['price'].toString()) ?? 0.0;
      final imageGallery = (device['images'] as List<dynamic>?)
              ?.map((img) => img['path'] as String?)
              .whereType<String>()
              .toList() ??
          ['assets/images/default_image.png'];
      final availableCount = device['available_count'] ?? 1;

      if (devicePrice == 0.0) {
        print('Warning: Device "$deviceName" has an invalid price.');
        return const SizedBox.shrink();
      }

      return ProductWidget(
        deviceId: deviceId,
        title: deviceName,
        imagePath: imageGallery.isNotEmpty
            ? imageGallery[0]
            : 'assets/images/default_image.png',
        basePrice: devicePrice,
        imageGallery: imageGallery,
        availableCount: availableCount,
        reservedDates: reservedDates,
        onAddToCart: onAddToCart,
        isInCart: false, // You'll need to pass this from parent
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: 0.75,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      padding: const EdgeInsets.all(10),
      children: _buildProductWidgets(context),
    );
  }
}
