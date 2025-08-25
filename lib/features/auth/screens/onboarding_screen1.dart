import 'package:flutter/material.dart';
import 'package:fooddeliveryapp/features/auth/screens/onboarding_screen2.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen1 extends StatefulWidget {
  const OnboardingScreen1({super.key});

  @override
  State<OnboardingScreen1> createState() => _OnboardingScreen1State();
}

class _OnboardingScreen1State extends State<OnboardingScreen1> {
  final PageController _controller = PageController(initialPage: 0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
              controller: _controller,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                          "assets/Images/diverse_sparkling_food.png"
                      ),
                      const SizedBox(height: 50,),
                      const Text("Diverse & Sparkling food.", style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black
                      ),),
                      const SizedBox(height: 20,),
                      const Text("We use the best local ingredients to create fresh", style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF6A7B8F),
                      ),),
                      const Text("and delicious food and drinks.", style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF6A7B8F),
                      ),),
                      const SizedBox(height: 150),
                    ],
                  ),
                ),



                Container(),
              ]
          ),


          Align(
            alignment: const Alignment(0, 0.4),
            child: SmoothPageIndicator(
              controller: _controller,
              count: 3,
              effect: ExpandingDotsEffect(
                  activeDotColor: Color(0xFFF3A938),
                  dotColor: Colors.grey.shade300,
                  dotHeight: 10,
                  dotWidth: 10
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 150.0, left: 20, right: 20),
                child: SizedBox(
                  height: 55,
                  width: 340,
                  child: ElevatedButton(
                    onPressed: (){
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => OnboardingScreen2()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFF3A938),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text("Get Started", style: TextStyle(
                      color: Colors.white,
                      fontSize: 18
                    ),),
                  ),

                ),


            ),
          )
        ],

      ),
    );
  }
}