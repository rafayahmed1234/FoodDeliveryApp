import 'package:flutter/material.dart';
import 'package:fooddeliveryapp/features/auth/screens/onboarding_screen1.dart'; // Apni pehli screen (Onboarding) ka path dein
import 'package:fooddeliveryapp/firebase_api.dart'; // Apni FirebaseApi file ka path dein
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fooddeliveryapp/features/discovery/screens/home_screen.dart'; // HomeScreen ka path

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeAppAndNavigate();
  }

  Future<void> _initializeAppAndNavigate() async {
    await FirebaseApi().initNotifications();
    await Future.delayed(const Duration(seconds: 3));
    User? user = FirebaseAuth.instance.currentUser;
    if (mounted) {
      if (user != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const OnboardingScreen1()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Example Logo
            Icon(Icons.fastfood_rounded, size: 100, color: Colors.orange),
            SizedBox(height: 20),
            CircularProgressIndicator(
              color: Colors.orange,
            ),
            SizedBox(height: 16),
            Text("Loading...", style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}