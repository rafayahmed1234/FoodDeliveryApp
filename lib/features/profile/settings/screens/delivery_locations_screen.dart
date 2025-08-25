import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'add_new_location_screen.dart';

class DeliveryLocationsScreen extends StatefulWidget {
  const DeliveryLocationsScreen({super.key});

  @override
  State<DeliveryLocationsScreen> createState() =>
      _DeliveryLocationsScreenState();
}

class _DeliveryLocationsScreenState extends State<DeliveryLocationsScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  void _showLocationOptions(String docId, String label) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text('Edit'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Edit screen ka logic yahan aayega
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Edit functionality is coming soon!')));
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: const Text('Delete', style: TextStyle(color: Colors.red)),
              onTap: () async {
                Navigator.pop(context);
                final user = _auth.currentUser;
                if (user != null) {
                  await _firestore
                      .collection('users')
                      .doc(user.uid)
                      .collection('deliveryLocations')
                      .doc(docId)
                      .delete();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F9F9),
        elevation: 0,
        foregroundColor: Colors.black,
        title: const Text('Delivery Locations',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: user == null
                  ? _buildEmptyView()
                  : StreamBuilder<QuerySnapshot>(
                      stream: _firestore
                          .collection('users')
                          .doc(user.uid)
                          .collection('deliveryLocations')
                          .orderBy('addedOn')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return _buildEmptyView();
                        }

                        final locationDocs = snapshot.data!.docs;
                        return _buildLocationsList(locationDocs);
                      },
                    ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddNewLocationScreen()),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('Add New Location'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF3A938),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  textStyle: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationsList(List<QueryDocumentSnapshot> locationDocs) {
    return ListView.builder(
      itemCount: locationDocs.length,
      itemBuilder: (context, index) {
        final doc = locationDocs[index];
        final locationData = doc.data() as Map<String, dynamic>;
        final IconData icon = IconData(locationData['icon_codePoint'],
            fontFamily: locationData['icon_fontFamily']);

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 1.5,
          shadowColor: Colors.grey.withOpacity(0.15),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            leading: Icon(icon, color: const Color(0xFF3A4F6A), size: 30),
            title: Text(locationData['label'],
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            subtitle: Text(locationData['address'],
                style: TextStyle(color: Colors.grey.shade600)),
            trailing: IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.grey),
              onPressed: () {
                _showLocationOptions(doc.id, locationData['label']);
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.location_off_outlined,
              size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text('No Saved Locations',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey)),
          const SizedBox(height: 8),
          const Text(
            'Add a new location to get started with your deliveries.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
