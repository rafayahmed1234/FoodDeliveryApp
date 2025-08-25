import 'package:flutter/material.dart';
import '../../../models/address_model.dart';

class AddressListScreen extends StatelessWidget {
  AddressListScreen({Key? key}) : super(key: key);

  final List<Address> savedAddresses = [
    Address(id: '1', name: "John's house", fullAddress: '1014 Prospect Vall, New York, USA', phone: '111-222-3333'),
    Address(id: '2', name: 'Hamza house', fullAddress: '456 Park Avenue, Manhattan, New York, 10022', phone: '444-555-6666'),
    Address(id: '3', name: 'Work Office', fullAddress: '1 Infinite Loop, Cupertino, CA', phone: '777-888-9999'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Delivery Location')),
      body: ListView.builder(
        itemCount: savedAddresses.length,
        itemBuilder: (context, index) {
          final address = savedAddresses[index];
          return ListTile(
            leading: Icon(address.name.toLowerCase().contains('house') ? Icons.home : Icons.work),
            title: Text(address.name, style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(address.fullAddress),
            onTap: () {
              Navigator.pop(context, address);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navigate to AddNewAddressScreen here
        },
        label: Text('Add New Location'),
        icon: Icon(Icons.add),
      ),
    );
  }
}