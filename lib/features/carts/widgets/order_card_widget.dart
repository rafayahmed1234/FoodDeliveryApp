import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderCard extends StatelessWidget {
  final Map<String, dynamic> orderData;
  final bool isOngoing;

  const OrderCard({
    super.key,
    required this.orderData,
    required this.isOngoing,
  });

  @override
  Widget build(BuildContext context) {
    final String restaurantName =
        orderData['restaurantName'] ?? 'Restaurant Not Found';
    final String address =
        orderData['deliveryAddress'] ?? 'Address not available';
    final double price = (orderData['totalAmount']?.toDouble() ?? 0.0).abs();
    final int itemCount = (orderData['items'] as List?)?.length ?? 0;
    final String imagePath = orderData['restaurantImage'] ?? '';
    final Timestamp orderTimestamp = orderData['orderDate'] ?? Timestamp.now();
    final String status = orderData['status'] ?? 'N/A';

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
        break;
    }

    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 3))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  restaurantName,
                  style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text(statusText,
                  style: TextStyle(
                      color: statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              Text(
                DateFormat('dd MMM').format(orderTimestamp.toDate()),
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
            ],
          ),
          const Divider(height: 24, thickness: 0.5),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: imagePath.isEmpty
                    ? Container(
                    width: 65,
                    height: 65,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.restaurant, color: Colors.grey))
                    : Image.asset(
                    imagePath,
                    width: 65,
                    height: 65,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                        width: 65,
                        height: 65,
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.broken_image,
                            color: Colors.grey))),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (itemCount > 0 && orderData['items'][0]['name'] != null)
                          ? orderData['items'][0]['name']
                          : address,
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Text('\$${price.toStringAsFixed(2)}',
                            style: const TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                                fontSize: 13)),
                        Text('  •  $itemCount items',
                            style: TextStyle(
                                color: Colors.grey.shade600, fontSize: 13)),
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
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade200,
                            foregroundColor: Colors.black87,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 14)),
                        child: const Text('Rate',
                            style: TextStyle(fontWeight: FontWeight.bold)))),
                const SizedBox(width: 12),
                Expanded(
                    child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF3A938),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 14)),
                        child: const Text('Re-Order',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)))),
              ],
            ),
          ]
        ],
      ),
    );
  }
}