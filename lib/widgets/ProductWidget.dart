import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProductWidget extends StatefulWidget {
  final String title;
  final String imagePath;
  final double basePrice;
  final List<String> imageGallery;
  final Function(int quantity) onAddToCart;

  const ProductWidget({
    Key? key,
    required this.title,
    required this.imagePath,
    required this.basePrice,
    required this.imageGallery,
    required this.onAddToCart,
  }) : super(key: key);

  @override
  _ProductWidgetState createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  int _quantity = 1;
  late double _totalPrice;
  bool _isAddedToCart = false;

  @override
  void initState() {
    super.initState();
    _totalPrice = widget.basePrice;
  }

  void _updatePrice(int quantity) {
    setState(() {
      _totalPrice = widget.basePrice * quantity;
    });
  }

  void _showImageGallery(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: SizedBox(
            height: 300,
            child: PageView(
              children: widget.imageGallery.map((image) {
                return Image.network(
                  image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.camera_alt, size: 50, color: Colors.grey),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

@override
Widget build(BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: Colors.grey.shade300),
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 8, offset: Offset(0, 4)),
      ],
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Column for Image and Reservation Indicator with increased flex
        Expanded(
          flex: 3, // Increased flex to give more space
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => _showImageGallery(context),
                child: Container(
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey.shade200,
                    image: DecorationImage(
                      image: NetworkImage(widget.imagePath),
                      fit: BoxFit.cover,
                      onError: (_, __) => AssetImage('assets/images/default_image.png'),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildReservationIndicator(),
            ],
          ),
        ),
        
        const SizedBox(width: 16), // Spacing between columns

        // Right Column for Title, Quantity, Price, and Buttons with less flex
        Expanded(
          flex: 2, // Reduced flex to give less space
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              _buildQuantitySelector(),
              const SizedBox(height: 8),
              _buildPriceRow(),
              const SizedBox(height: 12),
              _buildAddToCartButton(),
              const SizedBox(height: 14),
              _buildSetPeriodButton(),
            ],
          ),
        ),
      ],
    ),
  );
}



  Widget _buildQuantitySelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('数量', style: TextStyle(fontSize: 16, color: Colors.black)),
        const SizedBox(width: 8),
        Container(
          width: 80,
          height: 25,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: _quantity,
              onChanged: (int? newValue) {
                if (newValue != null) {
                  setState(() {
                    _quantity = newValue;
                    _updatePrice(_quantity);
                  });
                }
              },
              dropdownColor: Colors.white,
              style: const TextStyle(color: Colors.black),
              isExpanded: true,
              alignment: Alignment.center,
              icon: const Icon(Icons.keyboard_arrow_down_sharp, color: Colors.grey),
              items: List.generate(10, (index) => index + 1).map<DropdownMenuItem<int>>((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Center(child: Text('$value', style: const TextStyle(color: Colors.black))),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPriceRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('金額:', style: TextStyle(fontSize: 16, color: Colors.black)),
        const SizedBox(width: 8),
        Container(
          width: 80,
          height: 25,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey),
          ),
          child: Center(
            child: Text(
              '¥${_totalPrice.toStringAsFixed(0)}',
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddToCartButton() {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _isAddedToCart = !_isAddedToCart;
        });
        widget.onAddToCart(_quantity);
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, backgroundColor: Colors.teal,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        textStyle: const TextStyle(fontSize: 16),
      ),
      child: const Text('カートに入れる'),
    );
  }

  Widget _buildSetPeriodButton() {
    return OutlinedButton(
      onPressed: () {
        // Set period functionality
      },
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white, backgroundColor: Colors.grey.shade500,
        side: const BorderSide(color: Colors.grey),
      ),
      child: const Text('個別に期間を設定する'),
    );
  }

  Widget _buildReservationIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      color: Colors.grey[600],
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildIndicator(Colors.blue[200]!, '空きあり'),
              _buildIndicator(Colors.red[200]!, '空きなし'),
              _buildIndicator(Colors.grey[400]!, '予約不可'),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: List.generate(30, (index) {
              bool isReserved = index % 5 == 0; // Example reserved dates
              return Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 0.5),
                  height: 10,
                  color: isReserved ? Colors.red[200] : Colors.blue[200],
                ),
              );
            }),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(6, (i) => Text('${i * 5 + 1}', style: const TextStyle(fontSize: 10))),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicator(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          color: color,
        ),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 12, color: Colors.black)),
      ],
    );
  }
}
