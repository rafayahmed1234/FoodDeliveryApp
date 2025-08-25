import 'package:flutter/material.dart';

class AllCategoriesScreen extends StatefulWidget {
  const AllCategoriesScreen({super.key});

  @override
  State<AllCategoriesScreen> createState() => _AllCategoriesScreenState();
}

class _AllCategoriesScreenState extends State<AllCategoriesScreen> {
  final List<Map<String, String>> categories = [
    {'name': 'Sandwich', 'image': 'assets/Images/sandwich.png'},
    {'name': 'Pizza', 'image': 'assets/Images/pizza.png'},
    {'name': 'Burgers', 'image': 'assets/Images/burgers.png'},
    {'name': 'Salads', 'image': 'assets/Images/salads.png'},
    {'name': 'Drinks', 'image': 'assets/Images/drinks.png'},
    {'name': 'Noodles', 'image': 'assets/Images/noodles.png'},
    {'name': 'Tacos', 'image': 'assets/Images/tacos.png'},
    {'name': 'Ice cream', 'image': 'assets/Images/ice_cream.png'},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
      ),
      backgroundColor: Color(0xFFF9F9F9),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40.0),
                    topRight: Radius.circular(40.0),
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 15),
                    Container(
                      height: 7,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    SizedBox(height: 20),
                     Text(
                      "Categories",
                      style: TextStyle(
                        color: Color(0xFF3A4F6A),
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: GridView.builder(
                          padding: const EdgeInsets.all(20.0),
                          gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20,
                            childAspectRatio: 0.9,
                          ),
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 130,
                                  width: 130,
                                  padding: const EdgeInsets.all(25),
                                  decoration: BoxDecoration(
                                    color: Colors.yellow.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Image.asset(
                                    categories[index]['image']!,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  categories[index]['name']!,
                                  style: const TextStyle(
                                    color: Color(0xFF3A4F6A),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            );
                          }),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}