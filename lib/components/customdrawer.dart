import 'package:delhi_golf_federation/bloc/auth/auth_bloc.dart';
import 'package:delhi_golf_federation/bloc/auth/auth_event.dart';
import 'package:delhi_golf_federation/bloc/auth/auth_state.dart';
import 'package:delhi_golf_federation/config/routes_name.dart';
import 'package:delhi_golf_federation/database/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:delhi_golf_federation/screens/mybookings.dart';
import 'package:delhi_golf_federation/screens/gallery.dart';
import 'package:delhi_golf_federation/screens/video.dart';
import 'package:delhi_golf_federation/screens/news.dart';
import 'package:delhi_golf_federation/screens/myprofile.dart';
import 'package:delhi_golf_federation/screens/eventreport.dart';
import 'package:delhi_golf_federation/components/bottomnavigation.dart';
import 'package:delhi_golf_federation/components/topnavigationbar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomDrawer extends StatelessWidget {
  final Function(int)? onItemTap;

  const CustomDrawer({super.key, this.onItemTap});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: FractionallySizedBox(
        widthFactor: 0.75,
        heightFactor: 0.92,
        child: Material(
          color: Colors.transparent,
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF30946E), Color(0xFF12563C)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.only(bottomRight: Radius.circular(20)),
            ),
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                /// Logo Header
                SizedBox(
                  height: 130,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
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
                _buildDrawerItem(
                  context,
                  Icons.info_outline,
                  "About",
                  "/about",
                ),
                // _buildDrawerItem(
                //   context,
                //   Icons.sports_golf,
                //   "Book Tee Time",
                //   "/bookTee",
                // ),
                _buildDrawerItem(context, Icons.book, "Booking", "/booking"),
                _buildDrawerItem(
                  context,
                  Icons.sports_golf,
                  "ScoreCard",
                  "/eventreport",
                ),
                _buildDrawerItem(
                  context,
                  Icons.emoji_events,
                  "Leader board",
                  "/leaderboard",
                ),
                _buildDrawerItem(context, Icons.photo, "Photos", "/photos"),
                _buildDrawerItem(
                  context,
                  Icons.video_library,
                  "Videos",
                  "/videos",
                ),
                _buildDrawerItem(context, Icons.event, "Events", "/events"),
                _buildDrawerItem(context, Icons.article, "News", "/news"),

                const Divider(
                  color: Colors.white38,
                  indent: 20,
                  endIndent: 20,
                  thickness: 0.7,
                ),

                // Logout Button at bottom right
                Padding(
                  padding: const EdgeInsets.only(right: 16.0, bottom: 16.0),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: BlocConsumer<LogoutBloc, LogoutState>(
                      listener: (context, state) async {
                        if (state is LogoutSuccess) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.message)),
                          );

                          // ✅ Navigate to login screen and clear all previous routes
                          Navigator.of(
                            context,
                            rootNavigator: true,
                          ).pushNamedAndRemoveUntil(
                            RoutesName.loginScreen,
                            (route) => false,
                          );
                        } else if (state is LogoutFailure) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text(state.error)));
                        }
                      },
                      builder: (context, state) {
                        if (state is LogoutLoading) {
                          return const SizedBox(
                            height: 40,
                            width: 40,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          );
                        }

                        return ElevatedButton.icon(
                          onPressed: () {
                            context.read<LogoutBloc>().add(LogoutRequested());
                          },
                          icon: const Icon(Icons.logout, color: Colors.white),
                          label: const Text(
                            'Logout',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context,
    IconData icon,
    String title,
    String route,
  ) {
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
        if (onItemTap != null) onItemTap!(4);
        break;

      case "/eventreport":
        if (onItemTap != null) onItemTap!(3);
        break;

      case "/leaderboard":
        if (onItemTap != null) onItemTap!(1);
        break;

      case "/events":
        if (onItemTap != null) onItemTap!(2);
        break;

      case "/booking":
        _pushSimpleScreen(context, const MyBookingsScreen(), "My Bookings");
        break;

      case "/photos":
        _pushSimpleScreen(context, const GalleryScreen(), "Gallery");
        break;

      case "/videos":
        _pushSimpleScreen(context, const VideoScreen(), "Videos");
        break;

      case "/news":
        _pushSimpleScreen(context, const NewsScreen(), "News");
        break;

      // case "/eventreport":
      //   _pushSimpleScreen(context, const EventReportScreen(), "Event Report");
      //   break;

      default:
        if (onItemTap != null) onItemTap!(0);
    }
  }

  /// ✅ Reusable method to open drawer-only pages with TopNavigationBar and Bottom Navigation
  void _pushSimpleScreen(BuildContext context, Widget child, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _ScreenWithNavigation(child: child, title: title),
      ),
    );
  }
}

// ✅ Main Navigation Wrapper (unchanged)
class _ScreenWithNavigation extends StatefulWidget {
  final Widget child;
  final String title;

  const _ScreenWithNavigation({required this.child, required this.title});

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
        showBackButton: true,
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
        onNotificationTap: () {},
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
            BottomNavigationBarItem(
              icon: Icon(Icons.sports_golf),
              label: 'Scorecard',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.info), label: "About"),
          ],
        ),
      ),
    );
  }
}
