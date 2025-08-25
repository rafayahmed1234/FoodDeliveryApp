import 'package:flutter/material.dart';

class LiveOrderTrackerWidget extends StatelessWidget {
  final Map<String, dynamic> orderData;

  const LiveOrderTrackerWidget({super.key, required this.orderData});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          'assets/Images/map_placeholder.png',
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,
          errorBuilder: (context, error, stackTrace) => Container(
            color: Colors.grey[300],
            child: const Center(child: Text("Map will be here")),
          ),
        ),
        DraggableScrollableSheet(
          initialChildSize: 0.45,
          minChildSize: 0.45,
          maxChildSize: 0.8,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(blurRadius: 10, color: Colors.black12)
                  ]),
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.all(20),
                children: [
                  _buildDeliveryStatusCard(),
                  const SizedBox(height: 20),
                  _buildRouteDetailsCard(),
                  const SizedBox(height: 20),
                  _buildDriverInfoCard(),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildDeliveryStatusCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.delivery_dining_outlined,
                    color: Colors.orange),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Delivery Your Order",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  SizedBox(height: 4),
                  Text("Coming within 30 minutes",
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
            ],
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      orderData['items']?[0]?['name'] ?? 'Your Order',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${orderData['totalAmount']?.toStringAsFixed(2) ?? '0.00'} • ${orderData['items']?.length ?? 0} items • ${orderData['paymentMethod'] ?? 'Cash'}',
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Detail"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRouteDetailsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _buildAddressRow(
            icon: Icons.store,
            color: Colors.orange,
            title:
                "${orderData['restaurantName'] ?? 'Restaurant'} - ${orderData['restaurantAddress'] ?? 'Restaurant Address'}",
            subtitle: "Restaurant • ${orderData['deliveryTime'] ?? '13:00 PM'}",
          ),
          Padding(
            padding: const EdgeInsets.only(left: 7),
            child: CustomPaint(
              painter: DottedLinePainter(),
              child: const SizedBox(height: 30, width: 2),
            ),
          ),
          _buildAddressRow(
            icon: Icons.home,
            color: Colors.blue,
            title: "You - ${orderData['deliveryAddress'] ?? 'Your Address'}",
            subtitle: "Home • 13:30 PM",
          ),
        ],
      ),
    );
  }

  Widget _buildAddressRow(
      {required IconData icon,
      required Color color,
      required String title,
      required String subtitle}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(backgroundColor: color, radius: 8),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              const SizedBox(height: 2),
              Text(subtitle,
                  style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDriverInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 24,
            backgroundImage: AssetImage('assets/Images/person_profile.png'),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  orderData['driverName'] ?? 'Driver Name',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  'Delivery - ${orderData['driverPhone'] ?? 'Phone Number'}',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          _buildCircleButton(Icons.call, Colors.green, () {}),
          const SizedBox(width: 12),
          _buildCircleButton(Icons.message, Colors.orange, () {}),
        ],
      ),
    );
  }

  Widget _buildCircleButton(
      IconData icon, Color color, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(25),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Icon(icon, color: color, size: 24),
      ),
    );
  }
}

class DottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 2;
    const dashHeight = 5;
    const dashSpace = 3;
    double startY = 0;
    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
