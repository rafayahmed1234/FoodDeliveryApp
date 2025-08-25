import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OrderTrackingScreen extends StatefulWidget {
  final String orderId;
  const OrderTrackingScreen({super.key, required this.orderId});

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _markers = {};
  StreamSubscription? _orderSubscription;

  static const LatLng _restaurantLocation = LatLng(34.0522, -118.2437);

  @override
  void initState() {
    super.initState();
    _setInitialMarkers();
    _listenToOrderUpdates();
  }

  void _setInitialMarkers() {
    _markers.add(
      Marker(
        markerId: const MarkerId('restaurant'),
        position: _restaurantLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        infoWindow: const InfoWindow(title: 'Restaurant'),
      ),
    );
  }

  void _listenToOrderUpdates() {
    final orderRef = FirebaseFirestore.instance.collection('orders').doc(widget.orderId);
    _orderSubscription = orderRef.snapshots().listen((snapshot) {
      if (!snapshot.exists) return;

      final data = snapshot.data()!;
      final geoPoint = data['deliveryPartnerLocation'] as GeoPoint?;

      if (geoPoint != null) {
        final partnerLocation = LatLng(geoPoint.latitude, geoPoint.longitude);
        _updatePartnerMarker(partnerLocation);
        _animateCamera(partnerLocation);
      }

      if (mounted) {
        setState(() {});
      }
    });
  }

  void _updatePartnerMarker(LatLng position) {
    _markers.removeWhere((m) => m.markerId.value == 'deliveryPartner');
    _markers.add(
      Marker(
        markerId: const MarkerId('deliveryPartner'),
        position: position,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: const InfoWindow(title: 'Delivery Partner'),
      ),
    );
  }

  Future<void> _animateCamera(LatLng position) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: position, zoom: 15.5),
    ));
  }

  @override
  void dispose() {
    _orderSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Track Your Order')),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('orders').doc(widget.orderId).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final orderData = snapshot.data!.data() as Map<String, dynamic>;
          final status = orderData['status'] ?? 'Loading...';

          return Stack(
            children: [
              GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: const CameraPosition(
                  target: _restaurantLocation,
                  zoom: 14.5,
                ),
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
                markers: _markers,
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _buildStatusCard(status),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatusCard(String status) {
    IconData icon;
    String message;

    switch (status) {
      case 'Preparing':
        icon = Icons.soup_kitchen_outlined;
        message = "Your order is being prepared.";
        break;
      case 'On The Way':
        icon = Icons.delivery_dining_outlined;
        message = "Your order is on the way!";
        break;
      case 'Delivered':
        icon = Icons.check_circle_outline;
        message = "Your order has been delivered.";
        break;
      default: // Placed
        icon = Icons.receipt_long_outlined;
        message = "Your order has been placed.";
    }

    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Icon(icon, color: Colors.orange, size: 40),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'STATUS',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}