import 'package:flutter/material.dart';
import 'package:delhi_golf_federation/screens/mybookings.dart';
import 'package:delhi_golf_federation/screens/gallery.dart';
import 'package:delhi_golf_federation/screens/video.dart';
import 'package:delhi_golf_federation/screens/news.dart';
import 'package:delhi_golf_federation/screens/myprofile.dart';
import 'package:delhi_golf_federation/components/bottomnavigation.dart';
import 'package:delhi_golf_federation/components/topnavigationbar.dart';


class CustomDrawer extends StatelessWidget {
  final Function(int)? onItemTap;
  
  const CustomDrawer({super.key, this.onItemTap});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: FractionallySizedBox(
        widthFactor: 0.75, // ✅ Drawer width
        heightFactor: 0.92, // ✅ Drawer height
        child: Material( // ✅ Gives tap effects without Drawer background
          color: Colors.transparent,
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF30946E), // Top green
                  Color(0xFF12563C), // Bottom green
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(20),
              ),
            ),
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                /// Logo Header
                SizedBox(
                  height: 130, // Increased height to accommodate top padding
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40), // ✅ Added space above logo
                      Image.asset(
                        "assets/images/logo.png",
                        height: 90,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                ),

                const Divider(
                  color: Colors.white38,
                  indent: 20,
                  endIndent: 20,
                  thickness: 0.7,
                ),

                /// Menu Items
                _buildDrawerItem(context, Icons.info_outline, "About", "/about"),
                _buildDrawerItem(context, Icons.sports_golf, "Book Tee Time", "/bookTee"),
                _buildDrawerItem(context, Icons.book, "Booking", "/booking"),
                _buildDrawerItem(context, Icons.emoji_events, "Leader board", "/leaderboard"),
                _buildDrawerItem(context, Icons.photo, "Photos", "/photos"),
                _buildDrawerItem(context, Icons.video_library, "Videos", "/videos"),
                _buildDrawerItem(context, Icons.event, "Events", "/events"),
                _buildDrawerItem(context, Icons.article, "News", "/news"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
      BuildContext context, IconData icon, String title, String route) {
    return ListTile(
      leading: Icon(icon, color: Colors.white, size: 22),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      onTap: () {
        Navigator.pop(context); // Close drawer
        _navigateToTab(context, route);
      },
    );
  }

  void _navigateToTab(BuildContext context, String route) {
    switch (route) {
      case "/about":
        if (onItemTap != null) {
          onItemTap!(4);
        }
        break;
      case "/bookTee":
        if (onItemTap != null) {
          onItemTap!(3);
        }
        break;
      case "/booking":
        // Navigate to MyBookings with bottom and top navigation
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => _ScreenWithNavigation(
              child: const MyBookingsScreen(),
              title: "My Bookings",
            ),
          ),
        );
        break;
      case "/leaderboard":
        if (onItemTap != null) {
          onItemTap!(1);
        }
        break;
      case "/photos":
        // Navigate to Gallery with bottom and top navigation
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => _ScreenWithNavigation(
              child: const GalleryScreen(),
              title: "Gallery",
            ),
          ),
        );
        break;
      case "/videos":
        // Navigate to Video with bottom and top navigation
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => _ScreenWithNavigation(
              child: const VideoScreen(),
              title: "Videos",
            ),
          ),
        );
        break;
      case "/events":
        if (onItemTap != null) {
          onItemTap!(2);
        }
        break;
      case "/news":
        // Navigate to News with bottom and top navigation
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => _ScreenWithNavigation(
              child: const NewsScreen(),
              title: "News",
            ),
          ),
        );
        break;
      default:
        if (onItemTap != null) {
          onItemTap!(0); // Default to home
        }
    }
  }
}

// Helper widget to wrap screens with navigation
class _ScreenWithNavigation extends StatefulWidget {
  final Widget child;
  final String title;

  const _ScreenWithNavigation({
    required this.child,
    required this.title,
  });

  @override
  State<_ScreenWithNavigation> createState() => _ScreenWithNavigationState();
}

class _ScreenWithNavigationState extends State<_ScreenWithNavigation> {
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void updateIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
    
    // Navigate to the corresponding screen based on bottom nav selection
    switch (index) {
      case 0:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const CustomBottomNav()),
          (route) => false,
        );
        break;
      case 1:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const CustomBottomNav()),
          (route) => false,
        );
        break;
      case 2:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const CustomBottomNav()),
          (route) => false,
        );
        break;
      case 3:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const CustomBottomNav()),
          (route) => false,
        );
        break;
      case 4:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const CustomBottomNav()),
          (route) => false,
        );
        break;
    }
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
            MaterialPageRoute(
              builder: (context) => _ScreenWithNavigation(
                child: const MyProfile(),
                title: "Profile",
              ),
            ),
          );
        },
        onNotificationTap: () {
          // Handle notification tap
        },
      ),
      body: widget.child,
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
        ),
      ),
    );
  }
}
