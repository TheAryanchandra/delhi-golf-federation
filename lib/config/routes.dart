import 'package:flutter/material.dart';
import 'package:delhi_golf_federation/components/bottomnavigation.dart';
import '../screens/finalscorecard.dart'; // Add this import

// Screens
import '../screens/login_screen.dart';
import '../screens/about.dart';
import '../screens/slot_details.dart'; // Add this import
import '../screens/payment_screen.dart'; // Add this import
import '../screens/bookingscreen.dart'; // Add this import
import '../screens/registerscreen.dart'; // Update this import path
// import '../screens/splash_screen.dart';
// import '../screens/register_screen.dart';
// import '../screens/profile_screen.dart';

import 'routes_name.dart';

final Map<String, WidgetBuilder> appRoutes = {
  /// Auth Screens
  RoutesName.loginScreen: (context) => const LoginScreen(),
  RoutesName.registerScreen: (context) =>
      const RegisterScreen(), // Uncomment this line
  /// Main App Navigation (with bottom nav wrapper)
  RoutesName.homeScreen: (context) => const CustomBottomNav(),

  /// Other Screens
  '/about': (context) => const AboutScreen(),

  /// Add when ready
  // RoutesName.splashScreen: (context) => const SplashScreen(),
  // RoutesName.registerScreen: (context) => const RegisterScreen(),
  // RoutesName.bookingScreen: (context) => const BookingScreen(),
  // RoutesName.profileScreen: (context) => const ProfileScreen(),
  RoutesName.finalScorecard: (context) => ConfirmUploadScoreScreen(
    holes: ModalRoute.of(context)!.settings.arguments as List<Map<String, dynamic>>,
  ),
};
