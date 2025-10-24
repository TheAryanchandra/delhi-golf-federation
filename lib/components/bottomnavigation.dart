import 'package:flutter/material.dart';
import 'package:delhi_golf_federation/screens/homepage.dart';
import 'package:delhi_golf_federation/screens/leaderboard_screen.dart';
import 'package:delhi_golf_federation/screens/event_screen.dart';
import 'package:delhi_golf_federation/screens/eventreport.dart';
import 'package:delhi_golf_federation/screens/about.dart';
import 'package:delhi_golf_federation/screens/myprofile.dart';
import 'package:delhi_golf_federation/components/topnavigationbar.dart';
import 'package:delhi_golf_federation/components/customdrawer.dart';
import 'package:delhi_golf_federation/services/navigation_service.dart';

class CustomBottomNav extends StatefulWidget {
  final int initialIndex;

  const CustomBottomNav({super.key, this.initialIndex = 0});

  @override
  State<CustomBottomNav> createState() => _CustomBottomNavState();
}

class _CustomBottomNavState extends State<CustomBottomNav> {
  late int _currentIndex;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void updateIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    NavigationService.instance.setTabNavigator(updateIndex);
  }

  Widget _getCurrentScreen() {
    switch (_currentIndex) {
      case 0:
        return const HomePage();
      case 1:
        return const LeaderboardScreen();
      case 2:
        return const EventsScreen();
      case 3:
        return const EventReportScreen();
      case 4:
        return const AboutScreen();
      default:
        return const HomePage();
    }
  }

  /// Handle Android back button — prevents app from closing accidentally
  Future<bool> _onWillPop() async {
    if (_currentIndex != 0) {
      setState(() {
        _currentIndex = 0;
      });
      return false; // don't exit app
    }
    return true; // exit app only when already on Home
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: _scaffoldKey,
        drawer: CustomDrawer(
          onItemTap: (index) {
            Navigator.pop(context); // close drawer
            updateIndex(index);
          },
        ),
        appBar: TopNavigationBar(
          showBackButton: false,
          onMenuTap: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          onSettingsTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const _ProfileWithNavigation(),
              ),
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
                  icon: Icon(Icons.emoji_events), label: "Leaderboard"),
              BottomNavigationBarItem(icon: Icon(Icons.event), label: "Events"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.sports_golf), label: "Scorecard"),
              BottomNavigationBarItem(icon: Icon(Icons.info), label: "About"),
            ],
          ),
        ),
      ),
    );
  }
}

/// Profile screen wrapped with navigation
class _ProfileWithNavigation extends StatefulWidget {
  const _ProfileWithNavigation({super.key});

  @override
  State<_ProfileWithNavigation> createState() => _ProfileWithNavigationState();
}

class _ProfileWithNavigationState extends State<_ProfileWithNavigation> {
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void updateIndex(int index) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CustomBottomNav(initialIndex: index),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    Navigator.pop(context);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: _scaffoldKey,
        drawer: CustomDrawer(
          onItemTap: (index) {
            Navigator.pop(context);
            updateIndex(index);
          },
        ),
        appBar: TopNavigationBar(
          showBackButton: true,
          onBackTap: () {
            Navigator.pop(context);
          },
          onMenuTap: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          onSettingsTap: () {},
          onNotificationTap: () {},
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
                  icon: Icon(Icons.emoji_events), label: "Leaderboard"),
              BottomNavigationBarItem(icon: Icon(Icons.event), label: "Events"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.sports_golf), label: "Scorecard"),
              BottomNavigationBarItem(icon: Icon(Icons.info), label: "About"),
            ],
          ),
        ),
      ),
    );
  }
}
