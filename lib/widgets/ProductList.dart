import 'package:flutter/material.dart';

// Product class definition
class Product {
  final String title;
  final double price;

  Product(this.title, this.price);
}

// Cart class definition
class Cart {
  final List<Product> _items = [];

  void addItem(Product product) {
    _items.add(product);
  }

  void removeItem(Product product) {
    _items.remove(product);
  }

  List<Product> get items => _items;
}

// ProductWidget class (assumed to exist from previous context)
class ProductWidget extends StatelessWidget {
  final String title;
  final String imagePath;
  final double basePrice;
  final List<String> imageGallery;
  final VoidCallback onAddToCart;

  const ProductWidget({
    Key? key,
    required this.title,
    required this.imagePath,
    required this.basePrice,
    required this.imageGallery,
    required this.onAddToCart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE0E0E0),
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              // Implement image gallery viewing functionality
            },
            child: Image.asset(imagePath, width: 200, height: 240),
          ),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('金額: ¥$basePrice', style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: onAddToCart,
            child: const Text('カートに入れる'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.teal,
            ),
          ),
        ],
      ),
    );
  }
}

class CartDialog extends StatelessWidget {
  final Cart cart;
  final Function(Product) onRemove;

  const CartDialog({
    Key? key,
    required this.cart,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('カートの詳細'),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          itemCount: cart.items.length,
          itemBuilder: (context, index) {
            final product = cart.items[index];
            return ListTile(
              title: Text(product.title),
              trailing: IconButton(
                icon: const Icon(Icons.cancel, color: Colors.black),
                onPressed: () => onRemove(product),
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('閉じる'),
        ),
      ],
    );
  }
}

// ProductList widget definition
class ProductList extends StatefulWidget {
  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  Cart cart = Cart();

  void _addToCart(Product product) {
    setState(() {
      cart.addItem(product);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${product.title} をカートに追加しました')),
    );
  }

  void _removeFromCart(Product product) {
    setState(() {
      cart.removeItem(product);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${product.title} をカートから削除しました')),
    );
  }

  void _showCart(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return CartDialog(
          cart: cart,
          onRemove: _removeFromCart,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => _showCart(context),
          ),
        ],
      ),
      body: ListView(
        children: [
          ProductWidget(
            title: 'トランジット',
            imagePath: 'asset/images/Transit.png',
            basePrice: 1000,
            imageGallery: [
              'asset/images/Transit.png',
              'asset/images/Transit2.png',
              'asset/images/Transit3.png',
            ],
            onAddToCart: () => _addToCart(Product('トランジット', 1000)),
          ),
          ProductWidget(
            title: 'マイクロゲージ',
            imagePath: 'asset/images/tripod.png',
            basePrice: 1200,
            imageGallery: [
              'asset/images/tripod.png',
              'asset/images/tripod2.png',
            ],
            onAddToCart: () => _addToCart(Product('マイクロゲージ', 1200)),
          ),
        ],
      ),
    );
  }
}