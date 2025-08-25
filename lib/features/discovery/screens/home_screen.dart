import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fooddeliveryapp/features/discovery/screens/all_categories_screen.dart';
import 'package:fooddeliveryapp/features/discovery/screens/best_partner_screen.dart';
import 'package:fooddeliveryapp/features/order_history/screens/orders_history_screen.dart';
import 'package:fooddeliveryapp/features/profile/screens/profilescreen.dart';
import 'package:fooddeliveryapp/features/restaurant/screens/restaurant_KFC_screen.dart';
import 'package:fooddeliveryapp/features/restaurant/screens/restaurant_subway_screen.dart';
import '../../../providers/location_providers.dart';
import '../../../providers/orders_provider.dart';
import '../../explore/screens/explore_screen..dart';
import '../../restaurant/screens/restaurant_burgerking_screen.dart';
import '../../restaurant/screens/restaurant_tacobell_screen.dart';
import '../order_tracking_screen.dart';

class MenuItem {
  final String name;
  final double price;
  MenuItem({required this.name, required this.price});
}

class Restaurant {
  final String name;
  final String image;
  final String categories;
  final bool isOpen;
  final double rating;
  final double distance;
  final String reviewsCount;
  final int deliveryTime;
  final List<MenuItem> menu;

  Restaurant({
    required this.name,
    required this.image,
    required this.categories,
    required this.isOpen,
    required this.rating,
    required this.distance,
    required this.reviewsCount,
    required this.deliveryTime,
    required this.menu,
  });
}

class FilteredFoodItem {
  final MenuItem menuItem;
  final Restaurant parentRestaurant;
  FilteredFoodItem({required this.menuItem, required this.parentRestaurant});
}

// ==========================================================
// PARENT WIDGET: HomeScreen
// ==========================================================
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _mainNavIndex = 0;
  RangeValues _activePriceRange = const RangeValues(10, 80);
  Set<String> _activeDiets = {'Vegetarian'};
  String _activeSortBy = 'Top Rated';
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreenContent(onShowFilterSheet: () => _showFilterSheet(context)),
      const ExploreScreen(),
      const OrdersHistoryScreen(),
      const ProfileScreen(),
    ];
  }

  void _onItemTapped(int index) => setState(() => _mainNavIndex = index);

  void _showFilterSheet(BuildContext context) async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterSheet(
        initialPriceRange: _activePriceRange,
        initialDiets: _activeDiets,
        initialSortBy: _activeSortBy,
      ),
    );
    if (result != null) {
      setState(() {
        _activePriceRange = result['priceRange'];
        _activeDiets = result['diets'];
        _activeSortBy = result['sortBy'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _mainNavIndex, children: _screens),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() => Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(35), topRight: Radius.circular(35)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -5))
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
                icon: Icons.home_outlined, selectedIcon: Icons.home, index: 0),
            _buildNavItem(
                icon: Icons.explore_outlined,
                selectedIcon: Icons.explore,
                index: 1),
            _buildNavItem(
                icon: Icons.receipt_long_outlined,
                selectedIcon: Icons.receipt_long,
                index: 2),
            _buildNavItem(
                icon: Icons.person_outline,
                selectedIcon: Icons.person,
                index: 3),
          ],
        ),
      );

  Widget _buildNavItem(
          {required IconData icon,
          required IconData selectedIcon,
          required int index}) =>
      IconButton(
        icon: Icon(_mainNavIndex == index ? selectedIcon : icon,
            color: _mainNavIndex == index
                ? const Color(0xFFF3A938)
                : Colors.grey.shade400,
            size: 28),
        onPressed: () => _onItemTapped(index),
      );
}

// ==========================================================
// HomeScreenContent WIDGET (YAHAN CHANGES HAIN)
// ==========================================================
class HomeScreenContent extends StatefulWidget {
  final VoidCallback onShowFilterSheet;
  const HomeScreenContent({super.key, required this.onShowFilterSheet});

  @override
  State<HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<HomeScreenContent> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  int _innerTabIndex = 0;
  final List<String> _tabs = ['Nearby', 'Sales', 'Rates', 'Fast'];
  bool _isSearching = false;
  List<String> _searchHistory = ['Burger King', 'Pizza', 'Salads'];

  final List<String> _allCategories = [
    'Sandwich',
    'Pizza',
    'Burgers',
    'Salads',
    'Drinks',
    'Noodles'
  ];
  final List<Restaurant> _allRestaurants = [
    Restaurant(
        name: 'Burger King',
        image: 'assets/Images/burgerking_card.png',
        categories: 'Fastfood ⋅ Chicken ⋅ Burgers',
        isOpen: true,
        rating: 4.8,
        distance: 2.6,
        reviewsCount: '1.8k Reviews',
        deliveryTime: 25,
        menu: [
          MenuItem(name: 'Whopper Burger', price: 5.99),
          MenuItem(name: 'Chicken Fries', price: 3.49)
        ]),
    Restaurant(
        name: 'KFC',
        image: 'assets/Images/kfc_card.png',
        categories: 'Fastfood ⋅ Chicken ⋅ Rice',
        isOpen: true,
        rating: 4.0,
        distance: 3.0,
        reviewsCount: '2.2k Reviews',
        deliveryTime: 20,
        menu: [
          MenuItem(name: 'Zinger Burger', price: 4.99),
          MenuItem(name: 'Fried Chicken Bucket', price: 12.99)
        ]),
    Restaurant(
        name: 'Subway',
        image: 'assets/Images/subway.png',
        categories: 'Sandwich ⋅ Healthy',
        isOpen: true,
        rating: 4.5,
        distance: 1.5,
        reviewsCount: '1.2k Reviews',
        deliveryTime: 15,
        menu: [
          MenuItem(name: 'Veggie Delight Sandwich', price: 6.50),
          MenuItem(name: 'Chicken Teriyaki Sandwich', price: 7.80)
        ]),
    Restaurant(
        name: 'Taco Bell',
        image: 'assets/Images/tacobell1.png',
        categories: 'Mexican ⋅ Fastfood',
        isOpen: true,
        rating: 4.2,
        distance: 0.2,
        reviewsCount: '980 Reviews',
        deliveryTime: 22,
        menu: [
          MenuItem(name: 'Crunchy Taco', price: 1.89),
          MenuItem(name: 'Burrito Supreme', price: 4.50)
        ]),
  ];

  List<String> _filteredCategories = [];
  List<Restaurant> _filteredRestaurants = [];
  List<FilteredFoodItem> _filteredFoodItems = [];

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus != _isSearching) {
        setState(() => _isSearching = _focusNode.hasFocus);
      }
    });
  }

  void _navigateToRestaurantScreen(Restaurant restaurant) {
    Widget screen;
    switch (restaurant.name) {
      case 'Burger King':
        screen = const RestaurantBurgerkingScreen();
        break;
      case 'Taco Bell':
        screen = const RestaurantTacobellScreen();
        break;
      case 'KFC':
        screen = const RestaurantKfcScreen();
        break;
      case 'Subway':
        screen = const RestaurantSubwayScreen();
        break;
      default:
        screen = RestaurantDetailScreen(restaurant: restaurant);
        break;
    }
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredCategories.clear();
        _filteredRestaurants.clear();
        _filteredFoodItems.clear();
      });
      return;
    }
    setState(() {
      final lq = query.toLowerCase();
      _filteredCategories =
          _allCategories.where((c) => c.toLowerCase().contains(lq)).toList();
      _filteredRestaurants = _allRestaurants
          .where((r) =>
              r.name.toLowerCase().contains(lq) ||
              r.categories.toLowerCase().contains(lq))
          .toList();
      _filteredFoodItems = [];
      for (var res in _allRestaurants) {
        for (var item in res.menu) {
          if (item.name.toLowerCase().contains(lq)) {
            _filteredFoodItems
                .add(FilteredFoodItem(menuItem: item, parentRestaurant: res));
          }
        }
      }
    });
  }

  void _addToHistory(String term) {
    if (term.isEmpty) return;
    setState(() {
      _searchHistory.remove(term);
      _searchHistory.insert(0, term);
      if (_searchHistory.length > 5) _searchHistory.removeLast();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: Stack(
        children: [
          GestureDetector(
            onTap: () => _focusNode.unfocus(),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _buildHeader(context)),
                _buildNormalContent(),
              ],
            ),
          ),
          if (_isSearching) _buildFloatingSearchResults(),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final locationProvider = Provider.of<LocationProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 25),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(40.0),
              bottomRight: Radius.circular(40.0)),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 8)
          ]),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        // ONGOING ORDER BANNER
        if (orderProvider.isLoading)
          const SizedBox(
              height: 20,
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)))
        else if (orderProvider.ongoingOrder != null)
          GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => OrderTrackingScreen(
                          orderId: orderProvider.ongoingOrder!['orderId']))),
              child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green[200]!)),
                  child: Row(children: [
                    const Icon(Icons.delivery_dining_outlined,
                        color: Colors.green),
                    const SizedBox(width: 16),
                    Expanded(
                        child: Text(
                            'Your order is ${orderProvider.ongoingOrder!['status']}. Tap to track.',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green))),
                    const Icon(Icons.arrow_forward_ios,
                        size: 16, color: Colors.green)
                  ]))),

        // SEARCH BAR
        TextFormField(
            controller: _searchController,
            focusNode: _focusNode,
            onChanged: _performSearch,
            onFieldSubmitted: _addToHistory,
            decoration: InputDecoration(
                hintText: "Search on Coody",
                hintStyle: const TextStyle(color: Color(0xFFBCC7D3)),
                prefixIcon:
                    const Icon(Icons.location_on_sharp, color: Colors.grey),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () => _searchController.clear())
                    : null,
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none))),
        const SizedBox(height: 25),

        // DELIVERY TO & FILTER
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(children: [
                  const Icon(Icons.navigation, color: Colors.grey, size: 30),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Delivery to",
                              style: TextStyle(
                                  color: Color(0xFFF3A938), fontSize: 14)),
                          // YAHAN LOCATION PROVIDER SE DATA AA RAHA HAI
                          if (locationProvider.isLoading)
                            const Text("Loading...",
                                style: TextStyle(fontWeight: FontWeight.bold))
                          else
                            Text(
                              locationProvider.selectedLocation?['address'] ??
                                  "Select an address",
                              style: const TextStyle(
                                  fontSize: 18,
                                  color: Color(0xFF3A4F6A),
                                  fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                        ]),
                  )
                ]),
              ),
              ElevatedButton(
                  onPressed: widget.onShowFilterSheet,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEFF2F5),
                      foregroundColor: const Color(0xFF3A4F6A),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12)),
                  child: Row(children: const [
                    Icon(Icons.tune, size: 20),
                    SizedBox(width: 8),
                    Text("Filter",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold))
                  ]))
            ])
      ]),
    );
  }

  Widget _buildSearchResultsList() => ListView(
        padding: const EdgeInsets.all(8.0),
        shrinkWrap: true,
        children: [
          if (_filteredCategories.isNotEmpty) ...[
            _buildResultHeader('Categories'),
            ..._filteredCategories.map((cat) => ListTile(
                  leading:
                      const Icon(Icons.category_outlined, color: Colors.orange),
                  title: Text(cat,
                      style: const TextStyle(fontWeight: FontWeight.w500)),
                  onTap: () {
                    _addToHistory(cat);
                    _focusNode.unfocus();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const AllCategoriesScreen()));
                  },
                )),
            const Divider(),
          ],
          if (_filteredRestaurants.isNotEmpty) ...[
            _buildResultHeader('Restaurants'),
            ..._filteredRestaurants.map((res) => ListTile(
                  leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(res.image,
                          width: 40, height: 40, fit: BoxFit.cover)),
                  title: Text(res.name,
                      style: const TextStyle(fontWeight: FontWeight.w500)),
                  subtitle: Text(res.categories),
                  onTap: () {
                    _addToHistory(res.name);
                    _focusNode.unfocus();
                    _navigateToRestaurantScreen(res);
                  },
                )),
            const Divider(),
          ],
          if (_filteredFoodItems.isNotEmpty) ...[
            _buildResultHeader('Food Items'),
            ..._filteredFoodItems.map((item) => ListTile(
                  leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(item.parentRestaurant.image,
                          width: 40, height: 40, fit: BoxFit.cover)),
                  title: Text(item.menuItem.name,
                      style: const TextStyle(fontWeight: FontWeight.w500)),
                  subtitle: Text("from ${item.parentRestaurant.name}"),
                  trailing: Text("\$${item.menuItem.price.toStringAsFixed(2)}",
                      style: const TextStyle(
                          color: Colors.green, fontWeight: FontWeight.bold)),
                  onTap: () {
                    _addToHistory(item.menuItem.name);
                    _focusNode.unfocus();
                    _navigateToRestaurantScreen(item.parentRestaurant);
                  },
                )),
          ],
        ],
      );

  Widget _buildPartnerCard(Restaurant res) {
    return GestureDetector(
        onTap: () => _navigateToRestaurantScreen(res),
        child: SizedBox(
            width: 230,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: Image.asset(res.image,
                      height: 130, width: double.infinity, fit: BoxFit.cover)),
              const SizedBox(height: 10),
              Row(children: [
                Text(res.name,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3A4F6A))),
                const SizedBox(width: 5),
                const Icon(Icons.check_circle, color: Colors.green, size: 18)
              ]),
              const SizedBox(height: 5),
              Row(children: [
                Text(res.isOpen ? "Open" : "Close",
                    style: TextStyle(
                        color: res.isOpen ? Colors.green : Colors.red,
                        fontSize: 14)),
                const Text("  ·  Santa Nella, CA 95322",
                    style: TextStyle(color: Colors.grey, fontSize: 14))
              ]),
              const SizedBox(height: 8),
              Row(children: [
                _buildRatingBadge(res.rating.toString()),
                Text("  ·  ${res.distance}km",
                    style: TextStyle(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.bold,
                        fontSize: 14)),
                Text("  ·  Free shipping",
                    style: TextStyle(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.bold,
                        fontSize: 14))
              ])
            ])));
  }

  Widget _buildNearbyCard(Restaurant res) => GestureDetector(
        onTap: () => _navigateToRestaurantScreen(res),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Image.asset(
                  res.image,
                  width: double.infinity,
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 10),
              Row(children: [
                Text(res.name,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3A4F6A))),
                const SizedBox(width: 6),
                const Icon(Icons.check_circle, size: 18, color: Colors.green)
              ]),
              const SizedBox(height: 6),
              Row(children: [
                Text(res.isOpen ? "Open" : "Closed",
                    style: TextStyle(
                        fontSize: 14,
                        color: res.isOpen ? Colors.green : Colors.red,
                        fontWeight: FontWeight.w500)),
                _buildDotSeparator(),
                Text(res.categories,
                    style: const TextStyle(color: Colors.grey, fontSize: 14))
              ]),
              const SizedBox(height: 13),
              Row(children: [
                _buildRatingBadge(res.rating.toString()),
                _buildDotSeparator(),
                const Icon(Icons.location_on_sharp,
                    size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text("${res.distance} km",
                    style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                _buildDotSeparator(),
                const Icon(Icons.attach_money, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text("Free Shipping",
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]))
              ]),
            ],
          ),
        ),
      );

  Widget _buildFloatingSearchResults() {
    bool showHistory = _searchController.text.isEmpty;
    final hasResults = _filteredCategories.isNotEmpty ||
        _filteredRestaurants.isNotEmpty ||
        _filteredFoodItems.isNotEmpty;
    return Positioned(
        top: 155,
        left: 20,
        right: 20,
        child: Material(
            elevation: 10.0,
            borderRadius: BorderRadius.circular(20),
            child: Container(
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.5),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: showHistory
                    ? _buildSearchHistoryList()
                    : !hasResults
                        ? const Center(
                            child: Padding(
                                padding: EdgeInsets.all(20.0),
                                child: Text('No results found.')))
                        : _buildSearchResultsList())));
  }

  Widget _buildSearchHistoryList() =>
      ListView(padding: const EdgeInsets.all(8.0), shrinkWrap: true, children: [
        const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text('Search History',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54))),
        ..._searchHistory.map((term) => ListTile(
            leading: const Icon(Icons.history, color: Colors.grey),
            title: Text(term),
            onTap: () {
              _searchController.text = term;
              _searchController.selection =
                  TextSelection.fromPosition(TextPosition(offset: term.length));
              _performSearch(term);
            }))
      ]);
  Widget _buildNormalContent() => SliverList(
          delegate: SliverChildListDelegate([
        const SizedBox(height: 20),
        _buildCategorySection(),
        _buildBestPartnersSection(),
        const SizedBox(height: 20),
        _buildRestaurantsSection(_allRestaurants)
      ]));

  Widget _buildCategorySection() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22.0),
        child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 8)
                ]),
            child: Column(children: [
              Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 10, 10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Category",
                            style: TextStyle(
                                color: Color(0xFF3A4F6A),
                                fontWeight: FontWeight.bold,
                                fontSize: 20)),
                        TextButton(
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const AllCategoriesScreen())),
                            child: const Text("See all",
                                style: TextStyle(
                                    color: Color(0xFF3A4F6A),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600)))
                      ])),
              Divider(
                  color: Colors.grey.withOpacity(0.2),
                  thickness: 1,
                  indent: 20,
                  endIndent: 20),
              const SizedBox(height: 20),
              SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(children: [
                    _buildCategoryItem(
                        "Sandwich", "assets/Images/sandwich.png"),
                    const SizedBox(width: 20),
                    _buildCategoryItem("Pizza", "assets/Images/pizza.png"),
                    const SizedBox(width: 20),
                    _buildCategoryItem("Burgers", "assets/Images/burgers.png")
                  ])),
              const SizedBox(height: 20)
            ])));
  }

  Widget _buildCategoryItem(String name, String imagePath) {
    return Column(children: [
      Container(
          height: 130,
          width: 130,
          padding: const EdgeInsets.all(25),
          decoration: const BoxDecoration(
              color: Color(0xFFFFF9E5), shape: BoxShape.circle),
          child: Image.asset(imagePath)),
      const SizedBox(height: 10),
      Text(name,
          style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF3A4F6A),
              fontWeight: FontWeight.w600))
    ]);
  }

  Widget _buildBestPartnersSection() {
    return Padding(
        padding: const EdgeInsets.all(22.0),
        child: Container(
            padding: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 8)
                ]),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 10, 10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Best Partners",
                            style: TextStyle(
                                color: Color(0xFF3A4F6A),
                                fontWeight: FontWeight.bold,
                                fontSize: 20)),
                        TextButton(
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const BestPartnerScreen())),
                            child: const Text("See all",
                                style: TextStyle(
                                    color: Color(0xFF3A4F6A),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600)))
                      ])),
              Divider(
                  color: Colors.grey.withOpacity(0.2),
                  thickness: 1,
                  indent: 20,
                  endIndent: 20),
              const SizedBox(height: 20),
              SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(left: 20),
                  child: Row(children: [
                    _buildPartnerCard(_allRestaurants[2]),
                    const SizedBox(width: 20),
                    _buildPartnerCard(_allRestaurants[3])
                  ]))
            ])));
  }

  Widget _buildRestaurantsSection(List<Restaurant> restaurants) {
    return Padding(
        padding: const EdgeInsets.all(22.0),
        child: Container(
            padding: const EdgeInsets.only(top: 10, bottom: 20),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 8)
                ]),
            child: Column(children: [
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(_tabs.length, (index) {
                        bool isSelected = _innerTabIndex == index;
                        return GestureDetector(
                            onTap: () => setState(() => _innerTabIndex = index),
                            child: Container(
                                color: Colors.transparent,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(_tabs[index],
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: isSelected
                                                  ? const Color(0xFFF3A938)
                                                  : const Color(0xFF3A4F6A))),
                                      const SizedBox(height: 8),
                                      AnimatedContainer(
                                          duration:
                                              const Duration(milliseconds: 300),
                                          height: 3,
                                          width: 50,
                                          color: isSelected
                                              ? const Color(0xFFF3A938)
                                              : Colors.transparent)
                                    ])));
                      }))),
              Divider(
                  height: 1, thickness: 2, color: Colors.grey.withOpacity(0.2)),
              const SizedBox(height: 20),
              IndexedStack(index: _innerTabIndex, children: [
                _buildNearbyContent(restaurants),
                _buildSalesContent(restaurants),
                _buildRatesContent(restaurants),
                _buildFastContent(restaurants)
              ])
            ])));
  }

  Widget _buildSaleCard(Restaurant res) {
    return GestureDetector(
        onTap: () => _navigateToRestaurantScreen(res),
        child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Column(children: [
              Stack(children: [
                Image.asset(res.image),
                Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(20)),
                        child: const Text("SALE",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 10))))
              ]),
              const SizedBox(height: 10),
              Row(children: [
                Text(res.name,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3A4F6A))),
                const SizedBox(width: 6),
                const Icon(Icons.check_circle, size: 18, color: Colors.green)
              ]),
              const SizedBox(height: 6),
              Row(children: [
                Text(res.isOpen ? "Open" : "Closed",
                    style: TextStyle(
                        fontSize: 14,
                        color: res.isOpen ? Colors.green : Colors.red,
                        fontWeight: FontWeight.w500)),
                _buildDotSeparator(),
                Expanded(
                    child: Text(res.categories,
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 14),
                        overflow: TextOverflow.ellipsis))
              ]),
              const SizedBox(height: 13),
              Row(children: [
                _buildRatingBadge(res.rating.toString()),
                _buildDotSeparator(),
                const Icon(Icons.location_on_sharp,
                    size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text("${res.distance} km",
                    style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                _buildDotSeparator(),
                const Icon(Icons.attach_money, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text("Free Shipping",
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]))
              ])
            ])));
  }

  Widget _buildRateCard(Restaurant res, int rank) {
    return GestureDetector(
        onTap: () => _navigateToRestaurantScreen(res),
        child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: Row(children: [
              Text("#$rank",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color:
                          rank == 1 ? const Color(0xFFF3A938) : Colors.grey)),
              const SizedBox(width: 16),
              ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(res.image,
                      width: 60, height: 60, fit: BoxFit.cover)),
              const SizedBox(width: 12),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text(res.name,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Row(children: [
                      const Icon(Icons.star,
                          color: Color(0xFFF3A938), size: 16),
                      const SizedBox(width: 4),
                      Text(res.rating.toString(),
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(width: 6),
                      Text("(${res.reviewsCount})",
                          style: const TextStyle(color: Colors.grey))
                    ])
                  ])),
              const Icon(Icons.chevron_right, color: Colors.grey)
            ])));
  }

  Widget _buildFastCard(Restaurant res) {
    return GestureDetector(
        onTap: () => _navigateToRestaurantScreen(res),
        child: Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!)),
            child: Row(children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(res.image,
                      width: 70, height: 70, fit: BoxFit.cover)),
              const SizedBox(width: 12),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text(res.name,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Row(children: [
                      const Icon(Icons.location_on,
                          color: Colors.grey, size: 14),
                      const SizedBox(width: 4),
                      Text("${res.distance} km"),
                      const SizedBox(width: 10),
                      const Icon(Icons.star, color: Colors.grey, size: 14),
                      const SizedBox(width: 4),
                      Text(res.rating.toString())
                    ])
                  ])),
              Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8)),
                  child: Column(children: [
                    Text("${res.deliveryTime}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.green[800])),
                    Text("min",
                        style:
                            TextStyle(color: Colors.green[700], fontSize: 12))
                  ]))
            ])));
  }

  Widget _buildNearbyContent(List<Restaurant> restaurants) =>
      ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: restaurants.length,
          itemBuilder: (context, index) => _buildNearbyCard(restaurants[index]),
          separatorBuilder: (context, index) => Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
              child:
                  Divider(thickness: 2, color: Colors.grey.withOpacity(0.2))));

  Widget _buildSalesContent(List<Restaurant> restaurants) => ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: restaurants.length,
      itemBuilder: (context, index) => _buildSaleCard(restaurants[index]),
      separatorBuilder: (context, index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
          child: Divider(thickness: 2, color: Colors.grey.withOpacity(0.2))));

  Widget _buildRatesContent(List<Restaurant> restaurants) {
    List<Restaurant> sorted = List.from(restaurants)
      ..sort((a, b) => b.rating.compareTo(a.rating));
    return Column(
        children: sorted
            .asMap()
            .entries
            .map((e) => _buildRateCard(e.value, e.key + 1))
            .toList());
  }

  Widget _buildFastContent(List<Restaurant> restaurants) {
    List<Restaurant> sorted = List.from(restaurants)
      ..sort((a, b) => a.deliveryTime.compareTo(b.deliveryTime));
    return Column(children: sorted.map((res) => _buildFastCard(res)).toList());
  }

  Widget _buildResultHeader(String title) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Text(title,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black54)));
  }

  Widget _buildRatingBadge(String rating) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
            color: const Color(0xFFF3A938),
            borderRadius: BorderRadius.circular(12)),
        child: Row(children: [
          const Icon(Icons.star, color: Colors.white, size: 14),
          const SizedBox(width: 4),
          Text(rating,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12))
        ]));
  }

  Widget _buildDotSeparator() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0),
        child: Text('•',
            style: TextStyle(color: Colors.grey.shade400, fontSize: 14)));
  }
}

// ==========================================================
// PLACEHOLDER RESTAURANT DETAIL SCREEN (FALLBACK)
// ==========================================================
class RestaurantDetailScreen extends StatelessWidget {
  final Restaurant restaurant;
  const RestaurantDetailScreen({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(restaurant.name,
                  style: const TextStyle(
                      color: Colors.white,
                      shadows: [Shadow(color: Colors.black, blurRadius: 2)])),
              background: Image.asset(restaurant.image, fit: BoxFit.cover),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(restaurant.categories,
                      style: const TextStyle(fontSize: 16, color: Colors.grey)),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  const Text('Menu',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final menuItem = restaurant.menu[index];
                return ListTile(
                  title: Text(menuItem.name,
                      style: const TextStyle(fontWeight: FontWeight.w500)),
                  trailing: Text('\$${menuItem.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                          fontSize: 16)),
                );
              },
              childCount: restaurant.menu.length,
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================================
// FILTER SHEET (No changes)
// ==========================================================
class FilterSheet extends StatefulWidget {
  final RangeValues initialPriceRange;
  final Set<String> initialDiets;
  final String initialSortBy;
  const FilterSheet(
      {super.key,
      required this.initialPriceRange,
      required this.initialDiets,
      required this.initialSortBy});
  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  late RangeValues _priceRange;
  late Set<String> _selectedDiets;
  late String _selectedSortBy;
  final List<String> _sortByOptions = ['Top Rated', 'Fastest', 'Most Popular'];
  @override
  void initState() {
    super.initState();
    _priceRange = widget.initialPriceRange;
    _selectedDiets = Set.from(widget.initialDiets);
    _selectedSortBy = widget.initialSortBy;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25.0)),
        child: SingleChildScrollView(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 24,
                right: 24,
                top: 12),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                      child: Container(
                          width: 40,
                          height: 5,
                          decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(12)))),
                  const SizedBox(height: 20),
                  _buildHeader(),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Sort by'),
                  _buildSortByChips(),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Dietary'),
                  _buildDietaryChips(),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Price Range'),
                  _buildPriceRangeSlider(),
                  const SizedBox(height: 40),
                  _buildApplyButton(),
                  const SizedBox(height: 20)
                ])));
  }

  Widget _buildHeader() =>
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        const Text('Filters',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        TextButton(
            onPressed: () => setState(() {
                  _priceRange = const RangeValues(10, 80);
                  _selectedDiets.clear();
                  _selectedSortBy = 'Top Rated';
                }),
            child: const Text('Reset',
                style: TextStyle(color: Color(0xFFF3A938), fontSize: 16)))
      ]);
  Widget _buildSectionTitle(String title) => Text(title,
      style: const TextStyle(
          fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF3A4F6A)));
  Widget _buildSortByChips() {
    return Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: Wrap(
            spacing: 12.0,
            children: _sortByOptions.map((option) {
              final isSelected = _selectedSortBy == option;
              return ChoiceChip(
                  label: Text(option),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) setState(() => _selectedSortBy = option);
                  },
                  selectedColor: const Color(0xFFFFF1DC),
                  labelStyle: TextStyle(
                      color:
                          isSelected ? const Color(0xFFF3A938) : Colors.black87,
                      fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  avatar: isSelected
                      ? const Icon(Icons.check,
                          color: Color(0xFFF3A938), size: 16)
                      : null,
                  showCheckmark: false,
                  side: BorderSide(
                      color: isSelected
                          ? const Color(0xFFF3A938)
                          : Colors.grey.shade300),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10));
            }).toList()));
  }

  Widget _buildDietaryChips() {
    final options = ['Vegetarian', 'Vegan', 'Gluten-Free', 'Halal'];
    return Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: Wrap(
            spacing: 12.0,
            children: options.map((diet) {
              final isSelected = _selectedDiets.contains(diet);
              return FilterChip(
                  label: Text(diet),
                  selected: isSelected,
                  onSelected: (selected) => setState(() {
                        if (selected)
                          _selectedDiets.add(diet);
                        else
                          _selectedDiets.remove(diet);
                      }),
                  selectedColor: const Color(0xFFFFF1DC),
                  labelStyle: TextStyle(
                      color:
                          isSelected ? const Color(0xFFF3A938) : Colors.black87,
                      fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  avatar: isSelected
                      ? const Icon(Icons.check,
                          color: Color(0xFFF3A938), size: 16)
                      : null,
                  showCheckmark: false,
                  side: BorderSide(
                      color: isSelected
                          ? const Color(0xFFF3A938)
                          : Colors.grey.shade300),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10));
            }).toList()));
  }

  Widget _buildPriceRangeSlider() => Column(children: [
        RangeSlider(
            values: _priceRange,
            min: 0,
            max: 100,
            divisions: 10,
            activeColor: const Color(0xFFF3A938),
            inactiveColor: Colors.orange.withOpacity(0.2),
            labels: RangeLabels('\$${_priceRange.start.round()}',
                '\$${_priceRange.end.round()}'),
            onChanged: (RangeValues values) =>
                setState(() => _priceRange = values)),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('\$${_priceRange.start.round()}'),
                  Text('\$${_priceRange.end.round()}')
                ]))
      ]);
  Widget _buildApplyButton() {
    return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
            onPressed: () {
              final result = {
                'priceRange': _priceRange,
                'diets': _selectedDiets,
                'sortBy': _selectedSortBy
              };
              Navigator.pop(context, result);
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF3A938),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12))),
            child: const Text('Apply Filters',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))));
  }
}
