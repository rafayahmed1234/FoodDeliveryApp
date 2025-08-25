import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fooddeliveryapp/providers/cart_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../restaurant/screens/confirm_order_screen.dart';

import '../../discovery/order_tracking_screen.dart';
import '../widgets/orders_list_widgets.dart';

class OrdersHistoryScreen extends StatefulWidget {
  const OrdersHistoryScreen({super.key});

  @override
  State<OrdersHistoryScreen> createState() => _OrdersHistoryScreenState();
}

class _OrdersHistoryScreenState extends State<OrdersHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        backgroundColor: const Color(0xFFF9F9F9),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            },
          ),
          title: const Text('My Orders', style: TextStyle(color: Colors.black)),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [Tab(text: 'Ongoing'), Tab(text: 'History')],
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.orange,
            indicatorWeight: 3.0,
            indicatorSize: TabBarIndicatorSize.label,
          ),
        ),
        body: TabBarView(
          children: [
            OrderListWidget(statuses: const ['Placed', 'Preparing', 'On The Way']),
            OrderListWidget(statuses: const ['Delivered', 'Cancelled']),
          ],
        ),
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final Map<String, dynamic> orderData;
  final bool isOngoing;

  const OrderCard({
    super.key,
    required this.orderData,
    required this.isOngoing,
  });

  void _handleReOrder(BuildContext context, Map<String, dynamic> orderData) {
    final cart = Provider.of<CartProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Re-Order Items?'),
        content: const Text('This will clear your current cart and add items from this past order. Do you want to continue?'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
          ElevatedButton(
            child: const Text('Continue'),
            onPressed: () {
              Navigator.of(ctx).pop();

              cart.clearCart();

              final String restaurantName = orderData['restaurantName'] ?? 'Unknown Restaurant';
              final String restaurantImage = orderData['restaurantImage'] ?? '';
              final List<dynamic> itemsToReorder = orderData['items'] ?? [];

              if (itemsToReorder.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Could not find items to re-order.')),
                );
                return;
              }

              for (var item in itemsToReorder) {
                final String name = item['name'] ?? 'Unknown Item';
                final double price = (item['price'] as num?)?.toDouble() ?? 0.0;
                final String image = item['image'] ?? '';
                final int quantity = (item['quantity'] as num?)?.toInt() ?? 1;

                for (int i = 0; i < quantity; i++) {
                  cart.addItem(
                    name,
                    price,
                    name,
                    image,
                    restaurantName: restaurantName,
                    restaurantImage: restaurantImage,
                  );
                }
              }

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ConfirmOrderScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String restaurantName = orderData['restaurantName'] ?? 'N/A';
    final String address = orderData['deliveryAddress'] ?? 'Address not available';
    final double price = orderData['totalAmount']?.toDouble() ?? 0.0;
    final int itemCount = (orderData['items'] as List?)?.length ?? 0;
    final String imagePath = orderData['restaurantImage'] ?? '';
    final Timestamp orderTimestamp = orderData['orderDate'] ?? Timestamp.now();
    final String status = orderData['status'] ?? 'N/A';
    final String orderId = orderData['orderId'] ?? '';

    String statusText;
    Color statusColor;
    switch (status) {
      case 'Delivered':
        statusText = 'Completed';
        statusColor = Colors.green.shade600;
        break;
      case 'Cancelled':
        statusText = 'Cancelled';
        statusColor = Colors.red;
        break;
      default:
        statusText = status;
        statusColor = Colors.orange;
    }

    return GestureDetector(
      onTap: () {
        if (isOngoing && orderId.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => OrderTrackingScreen(orderId: orderId)),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              spreadRadius: 5,
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    (orderData['items'] as List?)?.isNotEmpty ?? false
                        ? (orderData['items'][0]['name'] ?? 'Food')
                        : 'Food',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  restaurantName,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
                Row(
                  children: [
                    Text(statusText, style: TextStyle(color: statusColor, fontSize: 13, fontWeight: FontWeight.w500)),
                    const SizedBox(width: 8),
                    Text(DateFormat('dd MMM').format(orderTimestamp.toDate()), style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                  ],
                ),
              ],
            ),
            const Divider(height: 24, thickness: 0.5),
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: (orderData['items'] as List?)?.isNotEmpty ?? false
                      ? Image.asset(
                      orderData['items'][0]['image'] ?? '',
                      width: 65,
                      height: 65,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(width: 65, height: 65, color: Colors.grey.shade200, child: const Icon(Icons.fastfood))
                  )
                      : Container(width: 65, height: 65, color: Colors.grey.shade200, child: const Icon(Icons.fastfood)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (orderData['items'] as List?)?.isNotEmpty ?? false
                            ? (orderData['items'][0]['name'] ?? 'Food Item')
                            : 'Food Item',
                        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text('\$${price.toStringAsFixed(2)}', style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 13)),
                          Text('  •  $itemCount items', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (!isOngoing) ...[
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) {
                            return Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
                              ),
                              child: const RateDriverSheet(),
                            );
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade200,
                        foregroundColor: Colors.black87,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Rate', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _handleReOrder(context, orderData),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF3A938),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Re-Order', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ]
          ],
        ),
      ),
    );
  }
}

class RateDriverSheet extends StatefulWidget {
  const RateDriverSheet({super.key});

  @override
  State<RateDriverSheet> createState() => _RateDriverSheetState();
}

class _RateDriverSheetState extends State<RateDriverSheet> {
  final Set<String> _selectedTags = {'On Time'};
  final List<String> _allTags = ['Good Service', 'On Time', 'Clean', 'Carefull', 'Work Hard', 'Polite'];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 24,
        right: 24,
        top: 12,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Rate Driver',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          const CircleAvatar(
            radius: 40,
            backgroundImage:  AssetImage("assets/Images/person_profile.png"),
          ),
          const SizedBox(height: 12),
          const Text(
            'Philippe Troussier',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.star, color: Colors.amber, size: 28),
              Icon(Icons.star, color: Colors.amber, size: 28),
              Icon(Icons.star, color: Colors.amber, size: 28),
              Icon(Icons.star, color: Colors.amber, size: 28),
              Icon(Icons.star, color: Colors.amber, size: 28),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Excellent',
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 24),
          Wrap(
            spacing: 12.0,
            runSpacing: 12.0,
            alignment: WrapAlignment.center,
            children: _allTags.map((tag) {
              final isSelected = _selectedTags.contains(tag);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedTags.remove(tag);
                    } else {
                      _selectedTags.add(tag);
                    }
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFFF3A938) : Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    tag,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: TextField(
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Do you have something to share with Cook? Leave a review now! Your rating and comments will be displayed anonymously.',
                hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              ),
            ),
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF3A938),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Next', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}