// lib/widgets/new_reservation/products_grid_view.dart
import 'package:flutter/material.dart';
import 'package:yotsuba_mobile/widgets/ProductWidget.dart';

class ProductsGridView extends StatelessWidget {
  final List<dynamic> devices;
  final Function(int deviceId, String name, double price, int quantity) onAddToCart;

  const ProductsGridView({
    Key? key,
    required this.devices,
    required this.onAddToCart,
  }) : super(key: key);

  List<Widget> _buildProductWidgets(BuildContext context) {
    return devices.map((device) {
      final deviceId = device['id'] ?? 0;
      final deviceName = device['name'] ?? 'Unknown Device';
      final reservedDates = device['reserved_dates'] ?? [];
      final devicePrice = double.tryParse(device['price'].toString()) ?? 0.0;
      final imageGallery = (device['images'] as List<dynamic>?)
          ?.map((img) => img['path'] as String?)
          .whereType<String>()
          .toList() ?? ['assets/images/default_image.png'];
      final availableCount = device['available_count'] ?? 1;

      if (devicePrice == 0.0) {
        print('Warning: Device "$deviceName" has an invalid price.');
        return const SizedBox.shrink();
      }

      return ProductWidget(
        deviceId: deviceId,
        title: deviceName,
        imagePath: imageGallery.isNotEmpty ? imageGallery[0] : 'assets/images/default_image.png',
        basePrice: devicePrice,
        imageGallery: imageGallery,
        availableCount: availableCount,
        reservedDates: reservedDates,
        onAddToCart: (quantity) => onAddToCart(deviceId, deviceName, devicePrice, quantity),
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

class ProductsListView extends StatelessWidget {
  final List<dynamic> devices;
  final Function(int deviceId, String name, double price, int quantity) onAddToCart;

  const ProductsListView({
    Key? key,
    required this.devices,
    required this.onAddToCart,
  }) : super(key: key);

  List<Widget> _buildProductWidgets(BuildContext context) {
    return devices.map((device) {
      final deviceId = device['id'] ?? 0;
      final deviceName = device['name'] ?? 'Unknown Device';
      final reservedDates = device['reserved_dates'] ?? [];
      final devicePrice = double.tryParse(device['price'].toString()) ?? 0.0;
      final imageGallery = (device['images'] as List<dynamic>?)
          ?.map((img) => img['path'] as String?)
          .whereType<String>()
          .toList() ?? ['assets/images/default_image.png'];
      final availableCount = device['available_count'] ?? 1;

      if (devicePrice == 0.0) {
        print('Warning: Device "$deviceName" has an invalid price.');
        return const SizedBox.shrink();
      }

      return ProductWidget(
        deviceId: deviceId,
        title: deviceName,
        imagePath: imageGallery.isNotEmpty ? imageGallery[0] : 'assets/images/default_image.png',
        basePrice: devicePrice,
        imageGallery: imageGallery,
        availableCount: availableCount,
        reservedDates: reservedDates,
        onAddToCart: (quantity) => onAddToCart(deviceId, deviceName, devicePrice, quantity),
        isInCart: false, // You'll need to pass this from parent
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(10),
      itemCount: devices.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) => _buildProductWidgets(context)[index],
    );
  }
}