import 'package:flutter/material.dart';
import 'package:fooddeliveryapp/features/restaurant/screens/confirm_order_screen.dart';
import 'package:fooddeliveryapp/providers/cart_provider.dart';
import 'package:provider/provider.dart';


class FoodDetailScreen extends StatefulWidget {
  final Map<String, dynamic> foodItem;

  final String restaurantName;
  final String restaurantImage;

  const FoodDetailScreen({
    super.key,
    required this.foodItem,
    required this.restaurantName,
    required this.restaurantImage,
  });

  @override
  State<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  String _selectedSize = 'M';
  int _quantity = 1;

  void _updateQuantity(int change) {
    if (_quantity + change >= 1) {
      setState(() {
        _quantity += change;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Center(
                          child: Container(
                            width: 50,
                            height: 5,
                            margin: const EdgeInsets.only(top: 16.0, bottom: 24.0),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        Text(
                          widget.foodItem['name'] ?? 'Food Item',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2d3a5a),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40.0),
                          child: Text(
                            widget.foodItem['description'] ?? 'A delicious food item, perfect for any occasion.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey[600],
                              height: 1.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 250,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Positioned(
                                  left: -60,
                                  child: Opacity(
                                    opacity: 0.4,
                                    child: Image.asset(widget.foodItem['image']!, height: 180, errorBuilder: (c, e, s) => const SizedBox()),
                                  )),
                              Positioned(
                                  right: -60,
                                  child: Opacity(
                                    opacity: 0.4,
                                    child: Image.asset(widget.foodItem['image']!, height: 180, errorBuilder: (c, e, s) => const SizedBox()),
                                  )),
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.4),
                                      spreadRadius: 2,
                                      blurRadius: 25,
                                      offset: const Offset(0, 15),
                                    ),
                                  ],
                                ),
                                child: Image.asset(
                                  widget.foodItem['image']!,
                                  height: 220,
                                  fit: BoxFit.contain,
                                  errorBuilder: (c, e, s) => const Icon(Icons.fastfood, size: 150, color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                        _buildSizeSelector(),
                        const SizedBox(height: 30),
                        _buildQuantitySelector(),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
                _buildBottomBar(),
              ],
            ),

            Positioned(
              top: 16.0,
              left: 16.0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSizeSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSizeOption('S'),
        const SizedBox(width: 20),
        _buildSizeOption('M'),
        const SizedBox(width: 20),
        _buildSizeOption('L'),
      ],
    );
  }

  Widget _buildSizeOption(String size) {
    bool isSelected = _selectedSize == size;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedSize = size;
        });
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFC72C) : Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            size,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuantitySelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildQuantityButton(icon: Icons.add, onTap: () => _updateQuantity(1)),
        const SizedBox(width: 30),
        Text(
          '$_quantity',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 30),
        _buildQuantityButton(icon: Icons.remove, onTap: () => _updateQuantity(-1)),
      ],
    );
  }

  Widget _buildQuantityButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: const Color(0xFFFFF4E0),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, color: const Color(0xFFFFA000)),
      ),
    );
  }

  Widget _buildBottomBar() {
    final double price = double.tryParse(widget.foodItem['price'] ?? '0.0') ?? 0.0;
    final double totalPrice = price * _quantity;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Price',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              const SizedBox(height: 4),
              Text(
                '\$ ${totalPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF3A938),
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              final cart = Provider.of<CartProvider>(context, listen: false);

              for (int i = 0; i < _quantity; i++) {
                cart.addItem(
                  widget.foodItem['name']!,
                  price,
                  widget.foodItem['name']!,
                  widget.foodItem['image']!,
                  restaurantName: widget.restaurantName,
                  restaurantImage: widget.restaurantImage,
                );
              }

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Added $_quantity x ${widget.foodItem['name']} to your order'),
                  duration: const Duration(seconds: 2),
                  backgroundColor: Colors.green,
                ),
              );

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ConfirmOrderScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF3A938),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              elevation: 2,
            ),
            child: const Text(
              'Add to Order',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}