import 'package:flutter/material.dart';
import 'package:fooddeliveryapp/features/auth/screens/onboarding_screens3.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen2 extends StatefulWidget {
  const OnboardingScreen2({super.key});

  @override
  State<OnboardingScreen2> createState() => _OnboardingScreen2State();
}

class _OnboardingScreen2State extends State<OnboardingScreen2> {
  final PageController _controller = PageController(initialPage: 1);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
              controller: _controller,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Container(),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                          "assets/Images/shipping_orders.png"
                      ),
                      const SizedBox(height: 50,),
                      const Text("Free Shipping on all orders.", style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black
                      ),),
                      const SizedBox(height: 20,),
                      const Text("Free Shipping on primary order whilst the", style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF6A7B8F),
                      ),),
                      const Text("usage of CaPay fee method.", style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF6A7B8F),

                      ),),
                      const SizedBox(height: 180),
                    ],
                  ),
                ),

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
                      MaterialPageRoute(builder: (context) => OnboardingScreens3()),
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
