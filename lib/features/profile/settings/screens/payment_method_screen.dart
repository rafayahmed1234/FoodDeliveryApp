import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  void _showAddPaymentMethodSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 40, height: 5, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(12))),
              const SizedBox(height: 24),
              const Text("Add Payment Method", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              _buildSheetOption(
                  iconPath: 'assets/Images/paypal.png', // Correct filename
                  text: "PayPal",
                  onTap: () {
                    _addPaymentMethod('PayPal', 'user_paypal@example.com', 'assets/Images/paypal.png'); // Correct filename
                    Navigator.pop(context);
                  }),
              _buildSheetOption(
                  icon: Icons.credit_card,
                  text: "Credit or Debit Card",
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Credit/Debit Card coming soon!")));
                  }),
              _buildSheetOption(
                  icon: Icons.money_outlined,
                  text: "Cash",
                  onTap: () {
                    _addPaymentMethod('Cash', 'Cash on delivery', null);
                    Navigator.pop(context);
                  }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSheetOption({String? iconPath, IconData? icon, required String text, required VoidCallback onTap}) {
    return ListTile(
      leading: iconPath != null
          ? Image.asset(iconPath, width: 24, height: 24)
          : Icon(icon, color: const Color(0xFF3A4F6A)),
      title: Text(text, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }

  Future<void> _addPaymentMethod(String type, String details, String? iconPath) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore.collection('users').doc(user.uid).collection('paymentMethods').add({
      'name': type,
      'iconPath': iconPath,
      'addedOn': Timestamp.now(),
    });
  }

  Future<void> _showDeleteConfirmation(String docId) async {
    final bool? confirmDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Remove Method'),
          content: const Text('Are you sure you want to remove this payment method?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Remove', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      final user = _auth.currentUser;
      if (user != null) {
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('paymentMethods')
            .doc(docId)
            .delete();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Payment Methods", style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: user == null
            ? const Center(child: Text("Please log in to see payment methods."))
            : StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection('users').doc(user.uid).collection('paymentMethods').orderBy('addedOn').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return _buildEmptyState();
            }
            final methods = snapshot.data!.docs;
            return _buildMethodsList(methods);
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(20)),
              child: const Icon(Icons.payment_outlined, size: 48, color: Color(0xFF3A4F6A)),
            ),
            const SizedBox(height: 24),
            const Text("Don't have any card", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF3A4F6A))),
            const SizedBox(height: 12),
            Text("It looks like you don't have a credit or debit card yet. Please add your cards.", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey.shade600, fontSize: 16, height: 1.5)),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _showAddPaymentMethodSheet,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF3A938),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Add Cards", style: TextStyle(fontSize: 16)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildMethodsList(List<QueryDocumentSnapshot> methods) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: methods.length,
              itemBuilder: (context, index) {
                final methodDoc = methods[index];
                final methodData = methodDoc.data() as Map<String, dynamic>;
                final String type = methodData['name'];
                final String? iconPath = methodData['iconPath'];

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    leading: iconPath != null
                        ? Image.asset(iconPath, width: 30)
                        : Icon(type == 'Cash' ? Icons.money_outlined : Icons.error, color: const Color(0xFF3A4F6A)),
                    title: Text(type, style: const TextStyle(fontWeight: FontWeight.bold)),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                    onTap: () {
                      _showDeleteConfirmation(methodDoc.id);
                    },
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: _showAddPaymentMethodSheet,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF3A938),
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text("Add New Method", style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}