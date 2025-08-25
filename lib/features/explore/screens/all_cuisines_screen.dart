import 'package:flutter/material.dart';

class AllCuisinesScreen extends StatelessWidget {
  const AllCuisinesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Yeh hamari saari cuisines ki list hai
    final allCuisines = [
      {'icon': Icons.local_pizza_outlined, 'name': 'Italian'},
      {'icon': Icons.fastfood_outlined, 'name': 'American'},
      {'icon': Icons.ramen_dining_outlined, 'name': 'Asian'},
      {'icon': Icons.bakery_dining_outlined, 'name': 'Mexican'},
      {'icon': Icons.cake_outlined, 'name': 'Desserts'},
      {'icon': Icons.local_cafe_outlined, 'name': 'Cafe'},
      {'icon': Icons.kebab_dining_outlined, 'name': 'Middle East'},
      {'icon': Icons.rice_bowl_outlined, 'name': 'Indian'},
      {'icon': Icons.set_meal_outlined, 'name': 'Thai'},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('All Cuisines', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // Ek line mein 3 items
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.9,
        ),
        itemCount: allCuisines.length,
        itemBuilder: (context, index) {
          final cuisine = allCuisines[index];
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.08), spreadRadius: 2, blurRadius: 8)],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(cuisine['icon'] as IconData, size: 35, color: const Color(0xFFF3A938)),
                const SizedBox(height: 12),
                Text(cuisine['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF3A4F6A))),
              ],
            ),
          );
        },
      ),
    );
  }
}