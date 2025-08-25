import 'package:flutter/material.dart';
import 'package:fooddeliveryapp/features/restaurant/screens/confirm_order_screen.dart';
import 'favorites.manager.dart';
import 'food_details_screen.dart';

class RestaurantSubwayScreen extends StatefulWidget {
  const RestaurantSubwayScreen({super.key});

  @override
  State<RestaurantSubwayScreen> createState() => _RestaurantSubwayScreenState();
}

class _RestaurantSubwayScreenState extends State<RestaurantSubwayScreen> {
  bool isRestaurantFavorite = false;

  final Map<String, List<Map<String, dynamic>>> menu = {
    'Popular Items': [
      {
        'name': 'Extreme cheese whopper JR',
        'price': '5.99',
        'category': 'Burger',
        'image': 'assets/Images/burger_item_1.png',
        'description':
            'A signature flame-grilled beef patty topped with smoked bacon and melted cheese.'
      },
      {
        'name': 'Singles BBQ bacon cheese burger',
        'price': '7.99',
        'category': 'Burger',
        'image': 'assets/Images/burger_item_2.png',
        'description':
            'Our single patty burger with crispy BBQ bacon and a layer of smooth cheese.'
      },
      {
        'name': 'Potatao Chip cheese burger',
        'price': '3.89',
        'category': 'Burger',
        'image': 'assets/Images/b3.png',
        'description':
            'The classic cheeseburger experience with an added crunch of potato chips.'
      },
    ],
    'Hot Burger Combo': [
      {
        'name': 'Combo Spicy Tender',
        'price': '10.15',
        'category': 'Burger combo',
        'image': 'assets/Images/hot_burger_combo.png',
        'description':
            'A full meal with a spicy chicken tender burger, fries, and a refreshing drink.'
      },
      {
        'name': 'Combo Tender Grill...',
        'price': '10.15',
        'category': 'Burger combo',
        'image': 'assets/Images/hot_burger_combo.png',
        'description':
            'A healthier choice featuring a grilled tender chicken burger with sides.'
      },
      {
        'name': 'Combo BBQ Bacon...',
        'price': '10.15',
        'category': 'Burger combo',
        'image': 'assets/Images/hot_burger_combo.png',
        'description':
            'Get the ultimate BBQ bacon flavor in a complete combo meal.'
      },
    ],
    'Fried Chicken': [
      {
        'name': 'Chicken BBQ',
        'price': '10.15',
        'category': 'Burger combo',
        'image': 'assets/Images/fried_chicken_1.png',
        'description':
            'Juicy fried chicken tossed in a sweet and tangy BBQ sauce.'
      },
      {
        'name': 'Combo Chicken Crispy...',
        'price': '10.15',
        'category': 'Burger combo',
        'image': 'assets/Images/fried_chicken_2.png',
        'description':
            'The crunchiest fried chicken you will ever have, served as a full meal.'
      },
    ],
  };

  // === YAHAN DATA ADD KIYA GAYA HAI ===
  final List<Map<String, dynamic>> reviewsData = [
    {
      'name': 'Eleanor Summers',
      'avatar': 'assets/Images/p1.png',
      'time': 'Today, 16:40',
      'rating': 5.0,
      'text':
          "What can I say it's fast food, it's Subway. No different to any of the other Subways, nice with adequate seating",
      'likes': 68,
      'images': [],
    },
    {
      'name': 'Victoria Champain',
      'avatar': 'assets/Images/p2.png',
      'time': 'Today, 09:12',
      'rating': 5.0,
      'text':
          "Food, as always, is good both upstairs and downstairs is always clean (download the app for deals etc.) sit upstairs every time, more relaxed feel.",
      'likes': 132,
      'images': [
        'assets/Images/burger_item_1.png',
        'assets/Images/burger_item_2.png',
        'assets/Images/b3.png',
        'assets/Images/hot_burger_combo.png',
        'assets/Images/fried_chicken_1.png',
        'assets/Images/fried_chicken_2.png',
      ],
    },
    {
      'name': 'Laura Smith',
      'avatar': 'assets/Images/p3.png',
      'time': 'Yesterday, 16:40',
      'rating': 4.0,
      'text':
          "Amazing food. Lots of choice. We took a while to choose as everything sounded amazing on the menu! All cooked to perfection. Portions were large. Service excellent. Definitely plan to go again and often!",
      'likes': 32,
      'images': [],
    },
    {
      'name': 'Dora Perry',
      'avatar': 'assets/Images/p4.png',
      'time': 'Yesterday, 16:40',
      'rating': 2.0,
      'text':
          "I popped in for a late lunch on Friday after a long morning working. The staff member was rude and unhelpful and the toilets were closed. I will not be returning and suggest others do not either.",
      'likes': 99,
      'images': [],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Stack(
          children: [
            SizedBox(
              height: 280,
              width: double.infinity,
              child: Image.asset(
                "assets/Images/subway_cover.png",
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Container(color: Colors.green[200]),
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 250),
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(30.0)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Container(
                              width: 50,
                              height: 5,
                              margin: const EdgeInsets.only(bottom: 20),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(children: [
                                      Text("Subway",
                                          style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold)),
                                      SizedBox(width: 8),
                                      Icon(Icons.verified,
                                          color: Colors.green, size: 22)
                                    ]),
                                    SizedBox(height: 4),
                                    Text(
                                        "Open ⋅ 1453 W Manchester Ave Los Angeles CA 90047",
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 14),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                          color: Colors.orange.withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(16)),
                                      child: const Text("Take Away",
                                          style: TextStyle(
                                              color: Colors.orange,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12))),
                                  const SizedBox(width: 8),
                                  IconButton(
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                      icon: Icon(
                                          isRestaurantFavorite
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color: isRestaurantFavorite
                                              ? Colors.orange[700]
                                              : Colors.grey,
                                          size: 24),
                                      onPressed: () {
                                        setState(() {
                                          isRestaurantFavorite =
                                              !isRestaurantFavorite;
                                        });
                                      }),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              _buildInfoBadge(
                                  icon: Icons.star,
                                  text: '4.5',
                                  isRating: true),
                              _buildDotSeparator(),
                              _buildInfoBadge(
                                  icon: Icons.access_time, text: '15 Mins'),
                              _buildDotSeparator(),
                              _buildInfoBadge(
                                  icon: Icons.delivery_dining,
                                  text: 'Free shipping'),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 10),
                              decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(children: [
                                const Icon(Icons.percent,
                                    color: Colors.orange, size: 20),
                                const SizedBox(width: 8),
                                Text("Save \$15.00 with code Total Dish",
                                    style: TextStyle(
                                        color: Colors.grey[800],
                                        fontWeight: FontWeight.w500))
                              ])),
                          const SizedBox(height: 20),
                          const TabBar(
                              tabs: [
                                Tab(text: 'Delivery'),
                                Tab(text: 'Review')
                              ],
                              labelColor: Color(0xFFF3A938),
                              unselectedLabelColor: Colors.grey,
                              indicatorColor: Color(0xFFF3A938),
                              indicatorWeight: 3),
                          Divider(
                              height: 1,
                              thickness: 1,
                              color: Colors.grey.withOpacity(0.2)),
                          SizedBox(
                            height: 1200,
                            child: TabBarView(
                              children: [
                                ListView(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  physics: const NeverScrollableScrollPhysics(),
                                  children: [
                                    _buildPopularItemsSection(),
                                    _buildFoodListSection('Hot Burger Combo'),
                                    _buildFoodListSection('Fried Chicken'),
                                  ],
                                ),
                                _buildReviewList(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 50.0,
              left: 16.0,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  color: Colors.white,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBadge(
      {required IconData icon, required String text, bool isRating = false}) {
    return Container(
      padding: isRating
          ? const EdgeInsets.symmetric(horizontal: 8, vertical: 4)
          : null,
      decoration: isRating
          ? BoxDecoration(
              color: const Color(0xFFF3A938),
              borderRadius: BorderRadius.circular(12))
          : null,
      child: Row(
        children: [
          Icon(icon, color: isRating ? Colors.white : Colors.grey, size: 16),
          const SizedBox(width: 4),
          Text(text,
              style: TextStyle(
                  color: isRating ? Colors.white : Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildDotSeparator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Text('·',
          style: TextStyle(
              color: Colors.grey.shade400, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildPopularItemsSection() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Popular Items',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF323232))),
          const SizedBox(height: 12),
          SizedBox(
            height: 230,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: menu['Popular Items']!.length,
              itemBuilder: (context, index) {
                final item = menu['Popular Items']![index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FoodDetailScreen(
                          foodItem: item,
                          restaurantName: 'Subway',
                          restaurantImage: 'assets/Images/subway_logo.png',
                        ),
                      ),
                    );
                  },
                  child: SizedBox(
                    width: 160,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                height: 120,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: const Color(0xFFF7F2E8),
                                    borderRadius: BorderRadius.circular(16)),
                                child: Center(
                                    child: Image.asset(item['image']!,
                                        fit: BoxFit.contain,
                                        errorBuilder: (c, e, s) => const Icon(
                                            Icons.fastfood,
                                            color: Colors.grey)))),
                            const SizedBox(height: 10),
                            Text(item['name']!,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 16),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 4),
                            if (item['price'] != null &&
                                item['price']!.isNotEmpty)
                              Text('\$${item['price']!}',
                                  style: const TextStyle(
                                      color: Colors.teal,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                            const SizedBox(height: 2),
                            Text(item['category']!,
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 14)),
                          ]),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodListSection(String categoryTitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(categoryTitle,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF323232))),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: menu[categoryTitle]!.length,
            itemBuilder: (context, index) {
              final item = menu[categoryTitle]![index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FoodDetailScreen(
                        foodItem: item,
                        restaurantName: 'Subway',
                        restaurantImage: 'assets/Images/subway_logo.png',
                      ),
                    ),
                  );
                },
                child: Container(
                  color: Colors.transparent,
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Row(
                    children: [
                      Container(
                          height: 80,
                          width: 80,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: const Color(0xFFF7F2E8),
                              borderRadius: BorderRadius.circular(12)),
                          child: Image.asset(item['image']!,
                              fit: BoxFit.contain,
                              errorBuilder: (c, e, s) =>
                                  const Icon(Icons.fastfood))),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item['name']!,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Row(children: [
                              Text('\$${item['price']!}',
                                  style: const TextStyle(
                                      color: Colors.orange,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(width: 8),
                              Text('·',
                                  style: TextStyle(
                                      color: Colors.grey.shade400,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(width: 8),
                              Text(item['category']!,
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 12)),
                            ]),
                          ],
                        ),
                      ),
                      ValueListenableBuilder<Set<String>>(
                        valueListenable: FavoritesManager.favoritesNotifier,
                        builder: (context, favoriteIds, child) {
                          final bool isFavorite = FavoritesManager.isFavorite(
                              'Subway', item['name']!);
                          return IconButton(
                            icon: Icon(
                                isFavorite ? Icons.star : Icons.star_border,
                                color: isFavorite ? Colors.orange : Colors.grey,
                                size: 20),
                            onPressed: () {
                              FavoritesManager.toggleFavorite(
                                  'Subway', item['name']!);
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // === YAHAN WIDGETS UPDATE KIYE GAYE HAIN ===
  Widget _buildReviewList() {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 20.0),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: reviewsData.length,
      itemBuilder: (context, index) {
        final review = reviewsData[index];
        return _buildReviewItem(review);
      },
    );
  }

  Widget _buildReviewItem(Map<String, dynamic> review) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage(review['avatar']!),
                radius: 20,
                onBackgroundImageError: (e, s) => const Icon(Icons.person),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(review['name']!,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(width: 8),
                        Text(review['time']!,
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    _buildStarRating(review['rating']!),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(review['text']!,
              style: TextStyle(color: Colors.grey[700], height: 1.5)),
          const SizedBox(height: 12),
          if (review['images'] != null && review['images'].isNotEmpty)
            _buildReviewImages(review['images']),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.favorite, color: Colors.red[400], size: 20),
                  const SizedBox(width: 6),
                  Text('${review['likes']} likes',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[800])),
                ],
              ),
              const Icon(Icons.flag_outlined, color: Colors.grey, size: 20),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReviewImages(List<String> images) {
    const double imageSize = 60.0;
    const int maxImagesToShow = 5;
    final bool hasMoreImages = images.length > maxImagesToShow;
    final int itemCount = hasMoreImages ? maxImagesToShow : images.length;

    return SizedBox(
      height: imageSize,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: itemCount,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          if (hasMoreImages && index == maxImagesToShow - 1) {
            return Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(images[index],
                        width: imageSize,
                        height: imageSize,
                        fit: BoxFit.cover)),
                Container(
                    width: imageSize,
                    height: imageSize,
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(8))),
                Text('+${images.length - maxImagesToShow + 1}',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
              ],
            );
          } else {
            return ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(images[index],
                    width: imageSize, height: imageSize, fit: BoxFit.cover));
          }
        },
      ),
    );
  }

  Widget _buildStarRating(double rating) {
    List<Widget> stars = [];
    for (int i = 1; i <= 5; i++) {
      stars.add(Icon(
          i <= rating ? Icons.star_rounded : Icons.star_border_rounded,
          color: const Color(0xFFF3A938),
          size: 20));
    }
    return Row(children: stars);
  }
}
