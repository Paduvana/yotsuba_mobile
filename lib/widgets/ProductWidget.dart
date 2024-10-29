import 'package:flutter/material.dart';
import 'package:yotsuba_mobile/services/APIConstants.dart';
import 'package:yotsuba_mobile/widgets/SetPeriodDialog.dart';

class ProductWidget extends StatefulWidget {
  final int deviceId;
  final String title;
  final String imagePath;
  final double basePrice;
  final List<String> imageGallery;
  final int availableCount;
  final List<dynamic> reservedDates;
  final Function(int quantity) onAddToCart;
  final bool isInCart;

  const ProductWidget({
    Key? key,
    required this.deviceId,
    required this.title,
    required this.imagePath,
    required this.basePrice,
    required this.imageGallery,
    required this.availableCount,
    required this.reservedDates,
    required this.onAddToCart,
    required this.isInCart,
  }) : super(key: key);

  @override
  _ProductWidgetState createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  int _quantity = 1;
  late double _totalPrice;
  bool _isAddedToCart = false;
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    _totalPrice = widget.basePrice;
    _quantity = widget.availableCount > 0 ? 1 : 0;
     _isAddedToCart = widget.isInCart;
  }
  @override
  void didUpdateWidget(ProductWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isInCart != widget.isInCart) {
      setState(() {
        _isAddedToCart = widget.isInCart;
      });
    }
  }
  void _updatePrice(int quantity) {
    setState(() {
      _totalPrice = widget.basePrice * quantity;
    });
  }

void _showImageGallery(BuildContext context) {
    if (widget.imageGallery.isEmpty) return;
    
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: SizedBox(
            height: 300,
            child: Stack(
              children: [
                PageView.builder(
                  itemCount: widget.imageGallery.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentImageIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return _buildNetworkImage(widget.imageGallery[index]);
                  },
                ),
                // Close button
                Positioned(
                  right: 8,
                  top: 8,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                // Page indicator
                if (widget.imageGallery.length > 1)
                  Positioned(
                    bottom: 16,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        widget.imageGallery.length,
                        (index) => Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentImageIndex == index
                                ? Colors.white
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
  Widget _buildNetworkImage(String imageUrl) {
    print(ApiConstants.getImageUrl(imageUrl));
    return Image.network(
      ApiConstants.getImageUrl(imageUrl),
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                : null,
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        print('Error loading image: $error');
        return Container(
          color: Colors.grey[300],
          child: const Icon(
            Icons.image_not_supported,
            size: 50,
            color: Colors.grey,
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final bool isAvailable = widget.availableCount > 0;

    return Padding(
      padding: const EdgeInsets.all(8.0), // Padding between widgets
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _isAddedToCart ? Colors.blue.shade100 : (isAvailable ? Colors.grey.shade300 : Colors.grey.shade700),
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 8, offset: Offset(0, 4)),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Column for Image and Reservation Indicator
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: isAvailable && widget.imageGallery.isNotEmpty ? () => _showImageGallery(context) : null,
                        child: Container(
                          width: double.infinity,
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: isAvailable ? Colors.grey.shade200 : Colors.grey.shade500,
                            image: DecorationImage(
                              image: NetworkImage(ApiConstants.getImageUrl(widget.imagePath)),
                              fit: BoxFit.cover,
                              onError: (_, __) => const AssetImage('assets/images/default_image.png'),
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

                // Right Column for Title, Quantity, Price, and Buttons
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        widget.title,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      _buildQuantitySelector(isAvailable),
                      const SizedBox(height: 8),
                      _buildPriceRow(),
                      const SizedBox(height: 12),
                      _buildAddToCartButton(isAvailable),
                      const SizedBox(height: 14),
                      _buildSetPeriodButton(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Grey overlay if unavailable
          if (!isAvailable)
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.6),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildQuantitySelector(bool isAvailable) {
    // Ensure we have valid items for the dropdown
    final List<int> availableQuantities = isAvailable && widget.availableCount > 0
        ? List<int>.generate(widget.availableCount, (index) => index + 1)
        : [0];

    // Ensure _quantity is in the available range
    if (!availableQuantities.contains(_quantity)) {
      _quantity = availableQuantities.first;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('数量', style: TextStyle(fontSize: 16, color: Colors.black)),
        const SizedBox(width: 8),
        Container(
          width: 80,
          height: 25,
          decoration: BoxDecoration(
            color: isAvailable ? Colors.white : Colors.grey.shade400,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: _quantity,
              onChanged: isAvailable ? (int? newValue) {
                if (newValue != null) {
                  setState(() {
                    _quantity = newValue;
                    _updatePrice(_quantity);
                  });
                }
              } : null,
              dropdownColor: Colors.white,
              style: const TextStyle(color: Colors.black),
              isExpanded: true,
              alignment: Alignment.center,
              icon: const Icon(Icons.keyboard_arrow_down_sharp, color: Colors.grey),
              items: availableQuantities.map((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Center(
                    child: Text(
                      value.toString(),
                      style: TextStyle(
                        color: isAvailable ? Colors.black : Colors.grey,
                      ),
                    ),
                  ),
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

  Widget _buildAddToCartButton(bool isAvailable) {
    return ElevatedButton(
      onPressed: isAvailable
          ? () {
              setState(() {
                _isAddedToCart = !_isAddedToCart;
              });
              widget.onAddToCart(_quantity);
            }
          : null,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: _isAddedToCart ? Colors.blue : Colors.teal,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        textStyle: const TextStyle(fontSize: 16),
        disabledBackgroundColor: const Color.fromARGB(255, 71, 94, 92),
      ),
      child: Text(_isAddedToCart ? 'カートから外す' : 'カートに入れる'),
    );
  }

  Widget _buildSetPeriodButton() {
    return OutlinedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) => SetPeriodDialog(machineName: widget.title),
        );
        },
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white, backgroundColor: Colors.grey.shade500,
        side: const BorderSide(color: Colors.grey),
      ),
      child: const Text('個別に期間を設定する'),
    );
  }
List<DateTime> _parseReservedDates(List<dynamic> reservedDates) {
  List<DateTime> allReservedDates = [];

  for (var dateEntry in reservedDates) {
    try {
      if (dateEntry.contains(',')) {
        List<String> dateRange = dateEntry.split(',');
        DateTime startDate = DateTime.parse(dateRange[0]);
        DateTime endDate = DateTime.parse(dateRange[1]);

        for (DateTime date = startDate; date.isBefore(endDate.add(Duration(days: 1))); date = date.add(Duration(days: 1))) {
          allReservedDates.add(date);
        }
      } else {
        DateTime singleDate = DateTime.parse(dateEntry);
        allReservedDates.add(singleDate);
      }
    } catch (e) {
      print("Invalid date format in reserved dates: $e");
    }
  }

  return allReservedDates.toSet().toList(); // Remove duplicates if any
}

Widget _buildReservationIndicator() {
    DateTime today = DateTime.now();
    List<DateTime> reservedDates =_parseReservedDates(widget.reservedDates);

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
              DateTime currentDate = today.add(Duration(days: index));
              bool isReserved = reservedDates.any((reservedDate) =>
                  reservedDate.year == currentDate.year &&
                  reservedDate.month == currentDate.month &&
                  reservedDate.day == currentDate.day);

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
