import 'package:flutter/material.dart';


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
    if (onItemTap != null) {
      int targetIndex;
      switch (route) {
        case "/about":
          targetIndex = 4;
          break;
        case "/bookTee":
          targetIndex = 3;
          break;
        case "/leaderboard":
          targetIndex = 1;
          break;
        case "/events":
          targetIndex = 2;
          break;
        default:
          targetIndex = 0; // Default to home
      }
      onItemTap!(targetIndex);
    }
  }
}
