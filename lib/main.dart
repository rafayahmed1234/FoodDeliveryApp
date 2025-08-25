import 'package:flutter/material.dart';
import 'package:fooddeliveryapp/providers/location_providers.dart';
import 'package:fooddeliveryapp/providers/orders_provider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

// Providers
import 'package:fooddeliveryapp/providers/cart_provider.dart';


// Services and Config
import 'package:fooddeliveryapp/services/notifcation_services.dart';
import 'firebase_options.dart';

// Screens
import 'features/auth/screens/splash_screen.dart';
import 'package:fooddeliveryapp/features/auth/screens/forgot_password_screen.dart';
import 'package:fooddeliveryapp/features/auth/screens/login_screen.dart';
import 'package:fooddeliveryapp/features/auth/screens/onboarding_screen1.dart';
import 'package:fooddeliveryapp/features/auth/screens/onboarding_screen2.dart';
import 'package:fooddeliveryapp/features/auth/screens/onboarding_screens3.dart';
import 'package:fooddeliveryapp/features/auth/screens/register_screen.dart';
import 'package:fooddeliveryapp/features/discovery/screens/all_categories_screen.dart';
import 'package:fooddeliveryapp/features/discovery/screens/best_partner_screen.dart';
import 'package:fooddeliveryapp/features/discovery/screens/home_screen.dart';
import 'package:fooddeliveryapp/features/order_history/screens/orders_history_screen.dart';
import 'package:fooddeliveryapp/features/restaurant/screens/confirm_order_screen.dart';
import 'package:fooddeliveryapp/features/restaurant/screens/restaurant_KFC_screen.dart';
import 'package:fooddeliveryapp/features/restaurant/screens/restaurant_burgerking_screen.dart';
import 'package:fooddeliveryapp/features/restaurant/screens/restaurant_subway_screen.dart';
import 'package:fooddeliveryapp/features/restaurant/screens/restaurant_tacobell_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotificationService().initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => CartProvider()),
        ChangeNotifierProvider(create: (ctx) => OrderProvider()),
        ChangeNotifierProvider(create: (ctx) => LocationProvider()),
      ],
      child: MaterialApp(
          title: 'Food Delivery App',
          debugShowCheckedModeBanner: false,
          initialRoute: '/',
          routes: {
            '/': (context) => const SplashScreen(),
            '/onboarding1':(context) => const OnboardingScreen1(),
            '/onboarding2': (context) => const OnboardingScreen2(),
            '/onboarding3': (context) => const OnboardingScreens3(),
            '/login': (context) => const LoginScreen(),
            '/register': (context) => const RegisterScreen(),
            '/forgotpassword': (context) => const PasswordRecovery(),
            '/home': (context) => const HomeScreen(),
            '/allcategories': (context) => const AllCategoriesScreen(),
            '/bestpartner': (context) => const BestPartnerScreen(),
            '/restaurantsubway': (context) => const RestaurantSubwayScreen(),
            '/restauranttacobell': (context) => const RestaurantTacobellScreen(),
            '/restaurantburgerking': (context) => const RestaurantBurgerkingScreen(),
            '/restaurantkfc': (context) => const RestaurantKfcScreen(),
            '/confirnorder': (context) => const ConfirmOrderScreen(),
            '/ordershistory': (context) => const OrdersHistoryScreen(),
          }),
    );
  }
}