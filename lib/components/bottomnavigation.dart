import 'package:delhi_golf_federation/screens/homepage.dart';
import 'package:delhi_golf_federation/screens/leaderboard_screen.dart';
import 'package:delhi_golf_federation/screens/event_screen.dart';
import 'package:delhi_golf_federation/screens/bookteetime.dart';
import 'package:delhi_golf_federation/screens/about.dart';
import 'package:delhi_golf_federation/components/topnavigationbar.dart';
import 'package:delhi_golf_federation/components/customdrawer.dart';
import 'package:flutter/material.dart';

class CustomBottomNav extends StatefulWidget {
  const CustomBottomNav({super.key});

  @override
  State<CustomBottomNav> createState() => _CustomBottomNavState();
}

class _CustomBottomNavState extends State<CustomBottomNav> {
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void updateIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  final List<Widget> _screens = const [
    HomePage(), // ✅ Homepage
    LeaderboardScreen(),
    EventsScreen(),
    BookTeeTimeScreen(),
    AboutScreen(),
  ];

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
          // Handle settings tap
        },
        onNotificationTap: () {
          // Handle notification tap
        },
      ),
      body: _screens[_currentIndex],

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
    });
  },
  type: BottomNavigationBarType.fixed,
  backgroundColor: const Color(0xFF12563C), // ✅ Using #12563C
  elevation: 8,
  selectedItemColor: Colors.white, // ✅ White for selected items
  unselectedItemColor: Colors.white70, // ✅ Slightly faded for unselected
  showUnselectedLabels: true,
  items: const [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: "Home",
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.emoji_events),
      label: "Leaderboard",
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.event),
      label: "Events",
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.golf_course),
      label: "Book Tee Time",
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.info),
      label: "About",
    ),
  ],
)

      ),
    );
  }
}
