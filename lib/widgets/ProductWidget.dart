import 'package:flutter/material.dart';

class ProductWidget extends StatefulWidget {
  final String title;
  final String imagePath;
  final double basePrice;
  final List<String> imageGallery;
  final VoidCallback onAddToCart;

  ProductWidget({
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

  @override
  void initState() {
    super.initState();
    _totalPrice = widget.basePrice; // Initialize total price
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
          child: Container(
            height: 300,
            child: PageView(
              children: widget.imageGallery.map((image) {
                return Image.asset(image, fit: BoxFit.cover);
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
        color: const Color(0xFFE0E0E0),
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => _showImageGallery(context), // Show gallery on tap
            child: Container(
              width: 200,
              height: 240,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(widget.imagePath),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('数量'),
                    const SizedBox(width: 8),
                    DropdownButton<int>(
                      value: _quantity,
                      onChanged: (int? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _quantity = newValue;
                            _updatePrice(_quantity);
                          });
                        }
                      },
                      items: List.generate(10, (index) => index + 1)
                          .map<DropdownMenuItem<int>>((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text('$value'),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '金額: ¥$_totalPrice',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Add to cart functionality
                    widget.onAddToCart();
                  },
                  child: const Text('カートに入れる'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () {
                    // Set period functionality
                  },
                  child: const Text('個別に期間を設定する'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xFF9E9E9E),
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}