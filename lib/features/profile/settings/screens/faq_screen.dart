import 'package:flutter/material.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FAQ'),
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          ExpansionTile(
            title: Text('How do I place an order?', style: TextStyle(fontWeight: FontWeight.bold)),
            children: <Widget>[
              ListTile(title: Text('You can place an order by selecting items from your favorite restaurant and proceeding to checkout.')),
            ],
          ),
          ExpansionTile(
            title: Text('How can I track my order?', style: TextStyle(fontWeight: FontWeight.bold)),
            children: <Widget>[
              ListTile(title: Text('Go to the "Ongoing Orders" tab to see the live status and track your delivery.')),
            ],
          ),
          ExpansionTile(
            title: Text('Is cash on delivery available?', style: TextStyle(fontWeight: FontWeight.bold)),
            children: <Widget>[
              ListTile(title: Text('Yes, we support cash on delivery along with various online payment methods.')),
            ],
          ),
        ],
      ),
    );
  }
}