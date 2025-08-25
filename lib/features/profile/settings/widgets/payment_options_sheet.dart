import 'package:flutter/material.dart';


import '../screens/add_cards_screen.dart';

class PaymentOptionsSheet extends StatelessWidget {
  // Yeh function parent se milega (yeh hamari "chitthi" hai)
  final Function(Map<String, dynamic>) onMethodSelected;

  const PaymentOptionsSheet({super.key, required this.onMethodSelected});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(25.0)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 5, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(12))),
            const SizedBox(height: 20),
            const Text('Add Payment Method', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),

            _buildOptionTile(
              context: context,
              iconPath: 'assets/Images/paypal.png',
              title: 'PayPal',
              onTap: () {
                // Hum chitthi par "PayPal" likh kar wapas bhej rahe hain
                onMethodSelected({
                  'name': 'PayPal',
                  'iconPath': 'assets/Images/paypal.png',
                });
                Navigator.pop(context); // Sheet ko band kiya
              },
            ),
            const Divider(),
            _buildOptionTile(
              context: context,
              iconPath: 'assets/Images/master_card.png',
              title: 'Credit or Debit Card',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AddCardScreen()));
              },
            ),
            const Divider(),
            _buildOptionTile(
              context: context,
              icon: Icons.money,
              title: 'Cash',
              onTap: () {
                // Hum chitthi par "Cash" likh kar wapas bhej rahe hain
                onMethodSelected({
                  'name': 'Cash',
                  'icon': Icons.money,
                });
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile({ required BuildContext context, String? iconPath, IconData? icon, required String title, required VoidCallback onTap}) {
    return ListTile(
      leading: iconPath != null ? Image.asset(iconPath, width: 40) : Icon(icon, color: const Color(0xFF3A4F6A), size: 30),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }
}