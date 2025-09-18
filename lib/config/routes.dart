import 'package:flutter/material.dart';
import '../Screens/login_screen.dart';
import 'routes_name.dart';

final Map<String, WidgetBuilder> appRoutes = {
  RoutesName.loginScreen: (context) => const LoginScreen(),
  // RoutesName.splashScreen: (context) => const SplashScreen(),
  // RoutesName.registerScreen: (context) => const RegisterScreen(),
  // RoutesName.homeScreen: (context) => const HomeScreen(),
  // RoutesName.bookingScreen: (context) => const BookingScreen(),
  // RoutesName.profileScreen: (context) => const ProfileScreen(),
};
