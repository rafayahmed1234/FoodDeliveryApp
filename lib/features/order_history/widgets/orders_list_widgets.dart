import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/orders_history_screen.dart';

class OrderListWidget extends StatelessWidget {
  final List<String> statuses;

  const OrderListWidget({super.key, required this.statuses});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Center(child: Text("Please log in to see your orders."));
    }

    final bool isOngoingList = statuses.contains('Placed');

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('orders')
          .where('userId', isEqualTo: user.uid)
          .where('status', whereIn: statuses)
          .orderBy('orderDate', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Something went wrong: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(
              isOngoingList ? 'No ongoing orders right now.' : 'You have no past orders.',
              style: const TextStyle(color: Colors.grey, fontSize: 16),
            ),
          );
        }

        final orderDocs = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          itemCount: orderDocs.length,
          itemBuilder: (context, index) {
            final orderData = orderDocs[index].data() as Map<String, dynamic>;

            return OrderCard(
              orderData: orderData,
              isOngoing: isOngoingList,
            );
          },
        );
      },
    );
  }
}