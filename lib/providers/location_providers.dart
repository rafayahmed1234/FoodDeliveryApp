import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LocationProvider with ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Map<String, dynamic>? _selectedLocation;
  bool _isLoading = true;

  Map<String, dynamic>? get selectedLocation => _selectedLocation;
  bool get isLoading => _isLoading;

  LocationProvider() {
    loadUserLocations();
  }

  Future<void> loadUserLocations() async {
    final user = _auth.currentUser;
    if (user == null) {
      _selectedLocation = null;
      _isLoading = false;
      notifyListeners();
      return;
    }

    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('deliveryLocations')
          .orderBy('addedOn', descending: true)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final data = snapshot.docs.first.data();
        _selectedLocation = {
          'docId': snapshot.docs.first.id,
          'label': data['label'] ?? 'N/A',
          'address': data['address'] ?? 'No address',
        };
      } else {
        _selectedLocation = null;
      }
    } catch (e) {
      _selectedLocation = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateSelectedLocation(Map<String, dynamic> newLocation) {
    _selectedLocation = newLocation;
    notifyListeners();
  }
}