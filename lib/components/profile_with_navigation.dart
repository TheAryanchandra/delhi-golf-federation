import 'package:flutter/material.dart';
import 'package:delhi_golf_federation/screens/homepage.dart';
import 'package:delhi_golf_federation/screens/leaderboard_screen.dart';
import 'package:delhi_golf_federation/screens/event_screen.dart';
import 'package:delhi_golf_federation/screens/eventreport.dart';
import 'package:delhi_golf_federation/screens/about.dart';
import 'package:delhi_golf_federation/screens/myprofile.dart';
import 'package:delhi_golf_federation/components/topnavigationbar.dart';
import 'package:delhi_golf_federation/components/customdrawer.dart';
import 'package:delhi_golf_federation/components/bottomnavigation.dart';
import 'package:delhi_golf_federation/services/navigation_service.dart';

/// Profile screen wrapped with navigation
class ProfileWithNavigation extends StatefulWidget {
  const ProfileWithNavigation({super.key});

  @override
  State<ProfileWithNavigation> createState() => ProfileWithNavigationState();
}

class ProfileWithNavigationState extends State<ProfileWithNavigation> {
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void updateIndex(int index) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => CustomBottomNav(initialIndex: index),
      ),
      (route) => false,
    );
  }

  Future<bool> _onWillPop() async {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const CustomBottomNav()),
      (route) => false,
    );
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
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const CustomBottomNav()),
              (route) => false,
            );
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
                icon: Icon(Icons.emoji_events),
                label: "Leaderboard",
              ),
              BottomNavigationBarItem(icon: Icon(Icons.event), label: "Events"),
              BottomNavigationBarItem(
                icon: Icon(Icons.sports_golf),
                label: "Scorecard",
              ),
              BottomNavigationBarItem(icon: Icon(Icons.info), label: "About"),
            ],
          ),
        ),
      ),
    );
  }
}
