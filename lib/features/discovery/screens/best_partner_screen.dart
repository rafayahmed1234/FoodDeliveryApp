import 'package:flutter/material.dart';
import 'package:fooddeliveryapp/features/restaurant/screens/restaurant_KFC_screen.dart';
import 'package:fooddeliveryapp/features/restaurant/screens/restaurant_burgerking_screen.dart';
import 'package:fooddeliveryapp/features/restaurant/screens/restaurant_subway_screen.dart';
import 'package:fooddeliveryapp/features/restaurant/screens/restaurant_tacobell_screen.dart';

class BestPartnerScreen extends StatefulWidget {
  const BestPartnerScreen({super.key});

  @override
  State<BestPartnerScreen> createState() => _BestPartnerScreenState();
}

class _BestPartnerScreenState extends State<BestPartnerScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.black),
        ),
      ),
      backgroundColor: Color(0xFFF9F9F9),
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
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
                "Best Partners",
                style: TextStyle(
                  color: Color(0xFF3A4F6A),
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: GestureDetector(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RestaurantSubwayScreen()),
                      );
                    },
                    child: Image.asset(
                      "assets/Images/subway.png",
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Row(
                  children: [
                    Text(
                      "Subway",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3A4F6A),
                      ),
                    ),
                    SizedBox(width: 5),
                    Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 18,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Row(
                  children: [
                    const Text(
                      "Open",
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Text(
                      "  ·  ",
                      style: TextStyle(color: Color(0xFF6A7B8F)),
                    ),
                    const Text(
                      "Coffee",
                      style: TextStyle(
                        color: Color(0xFF6A7B8F),
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      "  ·  ",
                      style: TextStyle(color: Color(0xFF6A7B8F)),
                    ),
                    Text(
                      "Tea",
                      style: TextStyle(
                        color: Color(0xFF6A7B8F),
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      "  ·  ",
                      style: TextStyle(color: Color(0xFF6A7B8F)),
                    ),
                    Text(
                      "Cake",
                      style: TextStyle(
                        color: Color(0xFF6A7B8F),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFFF3A938),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.white,
                            size: 14,
                          ),
                          SizedBox(width: 4),
                          Text(
                            "4.5",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      "  ·  1.5km",
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      "  ·  Free shipping",
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: GestureDetector(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RestaurantTacobellScreen()),
                      );
                    },
                    child: Image.asset(
                      "assets/Images/tacobell1.png",
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Row(
                  children: [
                    Text(
                      "Taco Bell",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3A4F6A),
                      ),
                    ),
                    SizedBox(width: 5),
                    Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 18,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Row(
                  children: [
                    const Text(
                      "Open",
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Text(
                      "  ·  ",
                      style: TextStyle(color: Color(0xFF6A7B8F)),
                    ),
                    const Text(
                      "Coffee",
                      style: TextStyle(
                        color: Color(0xFF6A7B8F),
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      "  ·  ",
                      style: TextStyle(color: Color(0xFF6A7B8F)),
                    ),
                    Text(
                      "Tea",
                      style: TextStyle(
                        color: Color(0xFF6A7B8F),
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      "  ·  ",
                      style: TextStyle(color: Color(0xFF6A7B8F)),
                    ),
                    Text(
                      "Cake",
                      style: TextStyle(
                        color: Color(0xFF6A7B8F),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFFF3A938),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.white,
                            size: 14,
                          ),
                          SizedBox(width: 4),
                          Text(
                            "4.5",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      "  ·  1.5km",
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      "  ·  Free shipping",
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: GestureDetector(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RestaurantBurgerkingScreen()),
                      );
                    },
                    child: Image.asset(
                      "assets/Images/burgerking_card.png",
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Row(
                  children: [
                    Text(
                      "Burger King",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3A4F6A),
                      ),
                    ),
                    SizedBox(width: 5),
                    Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 18,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Row(
                  children: [
                    const Text(
                      "Open",
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Text(
                      "  ·  ",
                      style: TextStyle(color: Color(0xFF6A7B8F)),
                    ),
                    const Text(
                      "Coffee",
                      style: TextStyle(
                        color: Color(0xFF6A7B8F),
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      "  ·  ",
                      style: TextStyle(color: Color(0xFF6A7B8F)),
                    ),
                    Text(
                      "Tea",
                      style: TextStyle(
                        color: Color(0xFF6A7B8F),
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      "  ·  ",
                      style: TextStyle(color: Color(0xFF6A7B8F)),
                    ),
                    Text(
                      "Cake",
                      style: TextStyle(
                        color: Color(0xFF6A7B8F),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFFF3A938),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.white,
                            size: 14,
                          ),
                          SizedBox(width: 4),
                          Text(
                            "4.5",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      "  ·  1.5km",
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      "  ·  Free shipping",
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: GestureDetector(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RestaurantKfcScreen()),
                      );
                    },
                    child: Image.asset(
                      "assets/Images/kfc_card.png",
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Row(
                  children: [
                    Text(
                      "KFC",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3A4F6A),
                      ),
                    ),
                    SizedBox(width: 5),
                    Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 18,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Row(
                  children: [
                    const Text(
                      "Open",
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Text(
                      "  ·  ",
                      style: TextStyle(color: Color(0xFF6A7B8F)),
                    ),
                    const Text(
                      "Coffee",
                      style: TextStyle(
                        color: Color(0xFF6A7B8F),
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      "  ·  ",
                      style: TextStyle(color: Color(0xFF6A7B8F)),
                    ),
                    Text(
                      "Tea",
                      style: TextStyle(
                        color: Color(0xFF6A7B8F),
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      "  ·  ",
                      style: TextStyle(color: Color(0xFF6A7B8F)),
                    ),
                    Text(
                      "Cake",
                      style: TextStyle(
                        color: Color(0xFF6A7B8F),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFFF3A938),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.white,
                            size: 14,
                          ),
                          SizedBox(width: 4),
                          Text(
                            "4.5",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      "  ·  1.5km",
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      "  ·  Free shipping",
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}