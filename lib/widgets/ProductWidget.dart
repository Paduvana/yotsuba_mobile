import 'package:flutter/material.dart';

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
    return SingleChildScrollView( // Added ScrollView to prevent overflow
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFE0E0E0),
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => _showImageGallery(context),
                  child: Container(
                    width: 190,
                    height: 200,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(widget.imagePath),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
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
                          const Text(
                            '数量',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
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
                                icon: const SizedBox.shrink(),
                                items: List.generate(10, (index) => index + 1)
                                    .map<DropdownMenuItem<int>>((int value) {
                                  return DropdownMenuItem<int>(
                                    value: value,
                                    child: Center(
                                      child: Text(
                                        '$value',
                                        style: const TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 2),
                          Icon(
                            Icons.keyboard_arrow_down_sharp,
                            size: 30,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            '金額: ',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(width: 26),
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
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () {
                          widget.onAddToCart(_quantity);
                        },
                        child: const Text('カートに入れる'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.teal,
                          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                        ),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton(
                        onPressed: () {
                          // Set period functionality
                        },
                        child: const Text('個別に期間を設定する'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: const Color(0xFF9E9E9E),
                          side: const BorderSide(color: Colors.grey),
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16), // Add some spacing before the ReservationIndicator
            Container(
              width: 190, // Match the width of the image
              child: ReservationIndicator(), // Add the ReservationIndicator here
            ),
          ],
        ),
      ),
    );
  }
}

class ReservationIndicator extends StatelessWidget {
  final List<bool> reservedDates = List.generate(30, (index) => index % 5 == 0); // Example reserved dates

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 8.0),
          padding: EdgeInsets.symmetric(vertical: 4.0),
          color: Colors.grey[600],
          child: SingleChildScrollView( // Allow horizontal scrolling
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildIndicator(Colors.blue[400]!, '空きあり'),
                _buildIndicator(Colors.red[400]!, '空きなし'),
                _buildIndicator(Colors.grey[400]!, '予約不可'),
              ],
            ),
          ),
        ),
        Row(
          children: List.generate(30, (index) {
            bool isReserved = reservedDates[index];
            bool isMultipleOf5 = (index + 1) % 5 == 0; // Check for multiples of 5

            return Container(
              width: 5,
              height: 10,
              decoration: BoxDecoration(
                color: isReserved ? Colors.red[400] : Colors.blue[400],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (isMultipleOf5)
                    CustomPaint(
                      size: Size(20, 100),
                      painter: DashedBorderPainter(),
                    ),
                  if (isMultipleOf5)
                    Text(
                      '${index + 1}',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildIndicator(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          margin: EdgeInsets.symmetric(horizontal: 4.0),
          color: color,
        ),
        Text(text, style: TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.grey[200]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    double dashWidth = 4.0;
    double dashSpace = 4.0;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}