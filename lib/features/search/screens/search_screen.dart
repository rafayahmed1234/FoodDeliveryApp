import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  // TODO: Add dummy data for search results

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // The real search text field is here
        title: TextField(
          controller: _searchController,
          autofocus: true, // Keyboard aate hi open ho jayega
          decoration: InputDecoration(
            hintText: 'Search for restaurants, dishes...',
            border: InputBorder.none,
          ),
          onChanged: (value) {
            // TODO: Jaise user type kare, yahan search results filter karne ka logic likhein
            setState(() {});
          },
        ),
      ),
      body: Center(
        // TODO: Yahan par suggestions ya search results dikhayein
        child: Text('Search results will appear here.'),
      ),
    );
  }
}