import 'package:delhi_golf_federation/screens/homepage.dart';
import 'package:delhi_golf_federation/screens/leaderboard_screen.dart';
import 'package:delhi_golf_federation/screens/event_screen.dart';
import 'package:delhi_golf_federation/screens/bookteetime.dart';
import 'package:delhi_golf_federation/screens/about.dart';
import 'package:delhi_golf_federation/screens/bookingscreen.dart';
import 'package:delhi_golf_federation/screens/slot_details.dart';
import 'package:delhi_golf_federation/screens/payment_screen.dart';
import 'package:delhi_golf_federation/screens/myprofile.dart';
import 'package:delhi_golf_federation/components/topnavigationbar.dart';
import 'package:delhi_golf_federation/components/customdrawer.dart';
import 'package:delhi_golf_federation/services/navigation_service.dart';
import 'package:flutter/material.dart';

class CustomBottomNav extends StatefulWidget {
  final int initialIndex;

  const CustomBottomNav({super.key, this.initialIndex = 0});

  @override
  State<CustomBottomNav> createState() => _CustomBottomNavState();
}

class _CustomBottomNavState extends State<CustomBottomNav> {
  late int _currentIndex;
  String _bookingFlow = 'main'; // 'main', 'booking', 'slot-details', 'payment'
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void updateIndex(int index) {
    setState(() {
      _currentIndex = index;
      _bookingFlow = 'main'; // Reset booking flow when changing tabs
    });
  }

  // void navigateToBookingFlow(String flow) {
  //   setState(() {
  //     _bookingFlow = flow;
  //     _currentIndex = 3; // Keep Book Tee Time tab selected
  //   });
  // }

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    // Register the navigation service
    // NavigationService.instance.setBookingFlowNavigator(navigateToBookingFlow);
    NavigationService.instance.setTabNavigator(updateIndex);
  }

  Widget _getCurrentScreen() {
    final List<Widget> _screens = const [
      HomePage(),
      LeaderboardScreen(),
      EventsScreen(),
      AboutScreen(),
    ];
    return _screens[_currentIndex];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: CustomDrawer(
        onItemTap: (index) {
          updateIndex(index);
        },
      ),
      appBar: TopNavigationBar(
        onMenuTap: () {
          _scaffoldKey.currentState?.openDrawer();
        },
        onSettingsTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => _ProfileWithNavigation()),
          );
        },
        onNotificationTap: () {
          // Handle notification tap
        },
      ),
      body: _getCurrentScreen(),

      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
              // Reset booking flow when changing tabs, especially for Book Tee Time
              if (index == 3) {
                _bookingFlow = 'main'; // Ensure we go to BookTeeTimeScreen
              } else {
                _bookingFlow = 'main';
              }
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xFF12563C), // ✅ Using #12563C
          elevation: 8,
          selectedItemColor: Colors.white, // ✅ White for selected items
          unselectedItemColor:
              Colors.white70, // ✅ Slightly faded for unselected
          showUnselectedLabels: true,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(
              icon: Icon(Icons.emoji_events),
              label: "Leaderboard",
            ),
            BottomNavigationBarItem(icon: Icon(Icons.event), label: "Events"),
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.golf_course),
            //   label: "Book Tee Time",
            // ),
            BottomNavigationBarItem(icon: Icon(Icons.info), label: "About"),
          ],
        ),
      ),
    );
  }
}

// Helper widget to wrap MyProfile with navigation
class _ProfileWithNavigation extends StatefulWidget {
  @override
  State<_ProfileWithNavigation> createState() => _ProfileWithNavigationState();
}

class _ProfileWithNavigationState extends State<_ProfileWithNavigation> {
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void updateIndex(int index) {
    setState(() {
      _currentIndex = index;
    });

    // Navigate to the corresponding screen based on bottom nav selection
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => CustomBottomNav(initialIndex: index),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: CustomDrawer(
        onItemTap: (index) {
          updateIndex(index);
        },
      ),
      appBar: TopNavigationBar(
        onMenuTap: () {
          _scaffoldKey.currentState?.openDrawer();
        },
        onSettingsTap: () {
          // Already on profile screen, do nothing or refresh
        },
        onNotificationTap: () {
          // Handle notification tap
        },
      ),
      body: const MyProfile(),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: updateIndex,
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xFF12563C),
          elevation: 8,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          showUnselectedLabels: true,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(
              icon: Icon(Icons.emoji_events),
              label: "Leaderboard",
            ),
            BottomNavigationBarItem(icon: Icon(Icons.event), label: "Events"),
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.golf_course),
            //   label: "Book Tee Time",
            // ),
            BottomNavigationBarItem(icon: Icon(Icons.info), label: "About"),
          ],
        ),
      ),
    );
  }
}
