import 'package:flutter/material.dart';
import 'package:fooddeliveryapp/features/discovery/screens/best_partner_screen.dart';
import 'all_cuisines_screen.dart';

abstract class SearchableItem {
  final String name;
  SearchableItem(this.name);
}

class Restaurant extends SearchableItem {
  final String image;
  final String tags;
  Restaurant({required String name, required this.image, required this.tags}) : super(name);
}

class Cuisine extends SearchableItem {
  final IconData icon;
  Cuisine({required String name, required this.icon}) : super(name);
}


class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();

  List<String> _searchHistory = ['Pizza', 'Burger', 'Sushi', 'Pasta'];
  List<SearchableItem> _searchResults = [];
  bool _isSearching = false;

  final List<Restaurant> _allRestaurants = [
    Restaurant(name: 'Subway', image: 'assets/Images/subway.png', tags: 'Sandwich, Healthy'),
    Restaurant(name: 'Taco Bell', image: 'assets/Images/tacobell1.png', tags: 'Mexican, Fast Food'),
    Restaurant(name: 'Burger King', image: 'assets/Images/burgerking_card.png', tags: 'Burgers, American'),
    Restaurant(name: 'KFC', image: 'path/to/kfc_image.png', tags: 'Chicken, Fried'),
  ];

  final List<Cuisine> _allCuisines = [
    Cuisine(name: 'Italian', icon: Icons.local_pizza_outlined),
    Cuisine(name: 'American', icon: Icons.fastfood_outlined),
    Cuisine(name: 'Asian', icon: Icons.ramen_dining_outlined),
    Cuisine(name: 'Mexican', icon: Icons.bakery_dining_outlined),
    Cuisine(name: 'Desserts', icon: Icons.cake_outlined),
    Cuisine(name: 'Indian', icon: Icons.rice_bowl_outlined),
  ];

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus != _isSearching) {
        setState(() {
          _isSearching = _focusNode.hasFocus;
        });
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() => _searchResults = []);
      return;
    }
    final lowerCaseQuery = query.toLowerCase();
    List<SearchableItem> results = [
      ..._allRestaurants.where((r) => r.name.toLowerCase().contains(lowerCaseQuery)),
      ..._allCuisines.where((c) => c.name.toLowerCase().contains(lowerCaseQuery)),
    ];
    setState(() => _searchResults = results);
  }

  void _addToHistory(String term) {
    if (term.isEmpty) return;
    setState(() {
      _searchHistory.remove(term);
      _searchHistory.insert(0, term);
      if (_searchHistory.length > 10) _searchHistory.removeLast();
    });
  }

  void _clearSearch() {
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> displayRestaurants = [
      {'name': 'Subway', 'image': 'assets/Images/subway.png', 'tags': 'Sandwich, Healthy'},
      {'name': 'Taco Bell', 'image': 'assets/Images/tacobell1.png', 'tags': 'Mexican, Fast Food'},
      {'name': 'Burger King', 'image': 'assets/Images/burgerking_card.png', 'tags': 'Burgers, American'},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F9F9),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Explore', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          GestureDetector(
            onTap: _clearSearch,
            child: SingleChildScrollView(
              physics: _isSearching ? const NeverScrollableScrollPhysics() : null,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSearchBar(),
                  const SizedBox(height: 24),
                  _buildSectionTitle(context, 'Cuisines', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AllCuisinesScreen()))),
                  _buildCuisineList(),
                  const SizedBox(height: 24),
                  _buildSectionTitle(context, 'Today\'s Deals', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BestPartnerScreen()))),
                  _buildRestaurantList(displayRestaurants),
                  const SizedBox(height: 24),
                  _buildSectionTitle(context, 'Popular Near You', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BestPartnerScreen()))),
                  _buildRestaurantList(displayRestaurants),
                ],
              ),
            ),
          ),

          if (_isSearching) _buildFloatingSearchResults(),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextField(
        controller: _searchController,
        focusNode: _focusNode,
        onChanged: _performSearch,
        onSubmitted: (value) => _addToHistory(value),
        decoration: InputDecoration(
          hintText: "Search restaurants, cuisines...",
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Colors.grey.shade200)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Color(0xFFF3A938))),
        ),
      ),
    );
  }

  Widget _buildFloatingSearchResults() {
    bool showHistory = _searchController.text.isEmpty;
    final items = showHistory ? _searchHistory : _searchResults;

    return Positioned(
      top: 65,
      left: 16,
      right: 16,
      child: Material(
        elevation: 8.0,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.4,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: (items.isEmpty && !showHistory)
              ? const Center(child: Padding(padding: EdgeInsets.all(16.0), child: Text("No results found.")))
              : ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            shrinkWrap: true,
            itemCount: items.length,
            itemBuilder: (context, index) {
              return showHistory
                  ? _buildHistoryItem(items[index] as String)
                  : _buildSearchResultItem(items[index] as SearchableItem);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryItem(String term) {
    return ListTile(
      leading: const Icon(Icons.history, color: Colors.grey),
      title: Text(term),
      trailing: IconButton(
        icon: const Icon(Icons.close, size: 20, color: Colors.grey),
        onPressed: () => setState(() => _searchHistory.remove(term)),
      ),
      onTap: () {
        _searchController.text = term;
        _searchController.selection = TextSelection.fromPosition(TextPosition(offset: term.length));
        _performSearch(term);
      },
    );
  }

  Widget _buildSearchResultItem(SearchableItem item) {
    IconData leadingIcon;
    String subtitle;

    if (item is Cuisine) {
      leadingIcon = item.icon;
      subtitle = 'Cuisine';
    } else {
      leadingIcon = Icons.restaurant_outlined;
      subtitle = 'Restaurant';
    }

    return ListTile(
      leading: Icon(leadingIcon, color: const Color(0xFFF3A938)),
      title: Text(item.name),
      subtitle: Text(subtitle),
      onTap: () {
        _addToHistory(item.name);
        _clearSearch();
        if (item is Cuisine) {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const AllCuisinesScreen()));
        } else if (item is Restaurant) {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const BestPartnerScreen()));
        }
      },
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, VoidCallback onViewAll) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF3A4F6A))),
          TextButton(onPressed: onViewAll, child: const Text('See all', style: TextStyle(color: Color(0xFFF3A938), fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  Widget _buildCuisineList() {
    final cuisines = [
      {'icon': Icons.local_pizza_outlined, 'name': 'Italian'},
      {'icon': Icons.fastfood_outlined, 'name': 'American'},
      {'icon': Icons.ramen_dining_outlined, 'name': 'Asian'},
      {'icon': Icons.bakery_dining_outlined, 'name': 'Mexican'},
    ];
    return SizedBox(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 16),
        itemCount: cuisines.length,
        itemBuilder: (context, index) {
          final item = cuisines[index];
          return Container(
            width: 90,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.08), spreadRadius: 2, blurRadius: 8)]),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(item['icon'] as IconData, size: 30, color: const Color(0xFFF3A938)),
                const SizedBox(height: 12),
                Text(item['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF3A4F6A))),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildRestaurantList(List<Map<String, String>> restaurants) {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 16, top: 10),
        itemCount: restaurants.length,
        itemBuilder: (context, index) {
          final item = restaurants[index];
          return Container(
            width: 250,
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), image: DecorationImage(image: AssetImage(item['image']!), fit: BoxFit.cover)),
          );
        },
      ),
    );
  }
}