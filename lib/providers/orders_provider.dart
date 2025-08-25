// FILE: lib/providers/order_provider.dart (NEW FILE)

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OrderProvider with ChangeNotifier {
  Map<String, dynamic>? _ongoingOrder;
  StreamSubscription? _orderSubscription;
  bool _isLoading = true;

  Map<String, dynamic>? get ongoingOrder => _ongoingOrder;
  bool get isLoading => _isLoading;

  OrderProvider() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        checkForOngoingOrders();
      } else {
        _clearOrder();
      }
    });
  }

  void checkForOngoingOrders() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _clearOrder();
      return;
    }

    _isLoading = true;
    notifyListeners();

    _orderSubscription?.cancel();
    _orderSubscription = FirebaseFirestore.instance
        .collection('orders')
        .where('userId', isEqualTo: user.uid)
        .where('status', whereIn: ['Placed', 'Preparing', 'On The Way'])
        .orderBy('orderDate', descending: true)
        .limit(1)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        _ongoingOrder = snapshot.docs.first.data();
      } else {
        _ongoingOrder = null;
      }
      _isLoading = false;
      notifyListeners();
    }, onError: (error) {
      _ongoingOrder = null;
      _isLoading = false;
      notifyListeners();
    });
  }

  void _clearOrder() {
    _ongoingOrder = null;
    _orderSubscription?.cancel();
    _isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _orderSubscription?.cancel();
    super.dispose();
  }
}