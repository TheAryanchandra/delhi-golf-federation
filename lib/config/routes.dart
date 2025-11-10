import 'package:delhi_golf_federation/screens/membershipscreen.dart';
import 'package:flutter/material.dart';
import 'package:delhi_golf_federation/components/bottomnavigation.dart';
import '../screens/finalscorecard.dart'; // Add this import

// Screens
import '../screens/login_screen.dart';
import '../screens/about.dart';
import '../screens/slot_details.dart'; // Add this import
import '../screens/paymentscreen.dart'; // Add this import
import '../screens/bookingscreen.dart'; // Add this import
import '../screens/registerscreen.dart'; // Update this import path
import '../screens/viewscore.dart'; // Add this import
import '../screens/event_details_screen.dart'; // Add this import
import '../screens/elitegolfer.dart'; // Add this import
import '../screens/clubgolfer.dart'; // Add this import
import '../screens/IGUranking.dart'; // Add this import
import '../screens/delhi_golf_ranking.dart'; // Add this import
import '../screens/paymentsuccessscreen.dart';
import '../screens/paymentsuccess2.dart';
import '../screens/newsviewmore.dart'; // Add this import for NewsDetailsScreen
// import '../screens/splash_screen.dart';
// import '../screens/register_screen.dart';
// import '../screens/profile_screen.dart';

// Models
import '../model/eventmodel.dart'; // Add this import
import '../model/login_model.dart'; // Add this import

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
  RoutesName.eliteGolferScreen: (context) => const EliteGolferScreen(),
  RoutesName.clubGolferScreen: (context) => const ClubGolferScreen(),
  RoutesName.iguRankingScreen: (context) => const IGURankingScreen(),
  RoutesName.delhiGolfRankingScreen: (context) =>
      const DelhiGolfRankingScreen(),
  // RoutesName.paymentScreen: (context) => const PaymentScreen(),
  RoutesName.membershipScreen: (context) {
    final args = ModalRoute.of(context)?.settings.arguments as LoginResponse?;
    return MembershipScreen(loginResponse: args);
  },
  RoutesName.paymentSuccessScreen: (context) => const PaymentSuccessScreen(),
  RoutesName.paymentSuccess2Screen: (context) => const PaymentDoneScreen(),
  RoutesName.eventScreen: (context) => const CustomBottomNav(initialIndex: 2),

  /// Add when ready
  // RoutesName.splashScreen: (context) => const SplashScreen(),
  // RoutesName.registerScreen: (context) => const RegisterScreen(),
  // RoutesName.bookingScreen: (context) => const BookingScreen(),
  // RoutesName.profileScreen: (context) => const ProfileScreen(),
};

Route<dynamic>? onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case RoutesName.confirmUploadScore:
      final args = settings.arguments as List<Map<String, dynamic>>;
      return MaterialPageRoute(
        builder: (_) => ConfirmUploadScoreScreen(holes: args),
      );
    case RoutesName.viewScoreScreen:
      // Check if arguments are passed
      final args = settings.arguments as Map<String, dynamic>?;
      return MaterialPageRoute(
        builder: (_) =>
            EventScoreViewScreen(eventRefNo: args?['eventRefNo'] ?? ''),
      );
    case RoutesName.eventDetailsScreen:
      final args = settings.arguments as Map<String, String>?;
      final refNo = args?['refNo'] ?? '';
      return MaterialPageRoute(
        builder: (_) => EventDetailsScreen(refNo: refNo),
      );
    case RoutesName.newsDetailsScreen:
      final args = settings.arguments as Map<String, Object?>?;
      final refNo = args?['refNo'] as String? ?? '';
      return MaterialPageRoute(builder: (_) => NewsDetailsScreen(refNo: refNo));

    default:
      return MaterialPageRoute(builder: (_) => const CustomBottomNav());
  }
}
