import 'package:delhi_golf_federation/bloc/auth/auth_bloc.dart';
import 'package:delhi_golf_federation/bloc/auth/auth_event.dart';
import 'package:delhi_golf_federation/bloc/auth/auth_state.dart';
import 'package:delhi_golf_federation/config/routes_name.dart';
import 'package:delhi_golf_federation/database/shared_preferences.dart';
import 'package:delhi_golf_federation/widgets/commonwebpage.dart';
import 'package:flutter/material.dart';
import 'package:delhi_golf_federation/screens/mybookings.dart';
import 'package:delhi_golf_federation/screens/gallery.dart';
import 'package:delhi_golf_federation/screens/video.dart';
import 'package:delhi_golf_federation/screens/news.dart';
import 'package:delhi_golf_federation/screens/myprofile.dart';
import 'package:delhi_golf_federation/screens/eventreport.dart';
import 'package:delhi_golf_federation/components/bottomnavigation.dart';
import 'package:delhi_golf_federation/components/topnavigationbar.dart';
import 'package:delhi_golf_federation/services/navigation_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomDrawer extends StatefulWidget {
  final Function(int)? onItemTap;

  const CustomDrawer({super.key, this.onItemTap});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  bool _indiaGolfExpanded = false; // <-- for collapsible section

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
                  height: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      Image.asset(
                        "assets/images/logo.png",
                        height: 50,
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

                Theme(
                  data: Theme.of(
                    context,
                  ).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                    title: Row(
                      children: const [
                        Icon(
                          Icons.golf_course, // 🏌️‍♂️ golf icon before title
                          color: Colors.white,
                          size: 22,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "India Golf Rankings",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    trailing: Icon(
                      _indiaGolfExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: Colors.white,
                    ),
                    onExpansionChanged: (expanded) {
                      setState(() {
                        _indiaGolfExpanded = expanded;
                      });
                    },
                    children: [
                      // 🌍 International Rankings
                      ExpansionTile(
                        tilePadding: const EdgeInsets.only(left: 32, right: 16),
                        title: const Text(
                          "International Rankings",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                        trailing: const Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.white,
                          size: 20,
                        ),
                        children: [
                          ListTile(
                            contentPadding: const EdgeInsets.only(
                              left: 48,
                              right: 16,
                            ),
                            title: const Text(
                              "Elite Golfer",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.pushNamed(
                                context,
                                RoutesName.eliteGolferScreen,
                              );
                            },
                          ),
                          ListTile(
                            contentPadding: const EdgeInsets.only(
                              left: 48,
                              right: 16,
                            ),
                            title: const Text(
                              "Club Golfer",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.pushNamed(
                                context,
                                RoutesName.clubGolferScreen,
                              );
                            },
                          ),
                        ],
                      ),

                      // 🇮🇳 National Rankings
                      ExpansionTile(
                        tilePadding: const EdgeInsets.only(left: 32, right: 16),
                        title: const Text(
                          "National Rankings",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                        trailing: const Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.white,
                          size: 20,
                        ),
                        children: [
                          ListTile(
                            contentPadding: const EdgeInsets.only(
                              left: 48,
                              right: 16,
                            ),
                            title: const Text(
                              "IGU Ranking",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.pushNamed(
                                context,
                                RoutesName.iguRankingScreen,
                              );
                            },
                          ),
                        ],
                      ),

                      // 🏠 State Rankings
                      ExpansionTile(
                        tilePadding: const EdgeInsets.only(left: 32, right: 16),
                        title: const Text(
                          "State Rankings",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                        trailing: const Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.white,
                          size: 20,
                        ),
                        children: [
                          ListTile(
                            contentPadding: const EdgeInsets.only(
                              left: 48,
                              right: 16,
                            ),
                            title: const Text(
                              "Delhi Golf Ranking",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.pushNamed(
                                context,
                                RoutesName.delhiGolfRankingScreen,
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                /// Menu Items
                // _buildDrawerItem(
                //   context,
                //   Icons.info_outline,
                //   "About",
                //   "/about",
                // ),
                // _buildDrawerItem(
                //   context,
                //   Icons.sports_golf,
                //   "Book Tee Time",
                //   "/bookTee",
                // ),
                // _buildDrawerItem(context, Icons.book, "Booking", "/booking"),
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
                // Theme(
                //   data: Theme.of(
                //     context,
                //   ).copyWith(dividerColor: Colors.transparent),
                //   child: ExpansionTile(
                //     tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                //     title: Row(
                //       children: const [
                //         Icon(
                //           Icons.golf_course, // 🏌️‍♂️ golf icon before text
                //           color: Colors.white,
                //           size: 22,
                //         ),
                //         SizedBox(width: 10),
                //         Text(
                //           "India Golf Rankings",
                //           style: TextStyle(
                //             color: Colors.white,
                //             fontSize: 16,
                //             fontWeight: FontWeight.w500,
                //           ),
                //         ),
                //       ],
                //     ),
                //     trailing: Icon(
                //       _indiaGolfExpanded
                //           ? Icons.keyboard_arrow_up
                //           : Icons.keyboard_arrow_down,
                //       color: Colors.white,
                //     ),
                //     onExpansionChanged: (expanded) {
                //       setState(() {
                //         _indiaGolfExpanded = expanded;
                //       });
                //     },
                //     children: [
                //       ListTile(
                //         title: const Text(
                //           "International Rankings",
                //           style: TextStyle(color: Colors.white70, fontSize: 15),
                //         ),
                //         onTap: () {
                //           Navigator.pop(context);
                //           _pushSimpleScreen(
                //             context,
                //             Placeholder(),
                //             "International Rankings",
                //           );
                //         },
                //       ),
                //       ListTile(
                //         title: const Text(
                //           "National Rankings",
                //           style: TextStyle(color: Colors.white70, fontSize: 15),
                //         ),
                //         onTap: () {
                //           Navigator.pop(context);
                //           _pushSimpleScreen(
                //             context,
                //             Placeholder(),
                //             "National Rankings",
                //           );
                //         },
                //       ),
                //       ListTile(
                //         title: const Text(
                //           "State Ranking",
                //           style: TextStyle(color: Colors.white70, fontSize: 15),
                //         ),
                //         onTap: () {
                //           Navigator.pop(context);
                //           _pushSimpleScreen(
                //             context,
                //             Placeholder(),
                //             "State Ranking",
                //           );
                //         },
                //       ),
                //     ],
                //   ),
                // ),
                _buildDrawerItem(
                  context,
                  Icons.video_library,
                  "Videos",
                  "/videos",
                ),
                _buildDrawerItem(context, Icons.event, "Events", "/events"),
                _buildDrawerItem(context, Icons.article, "News", "/news"),
                _buildDrawerItem(
                  context,
                  Icons.info_outline,
                  "About",
                  "/about",
                ),

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
        NavigationService.instance.navigateToTab(4);
        break;

      case "/eventreport":
        NavigationService.instance.navigateToTab(3);
        break;

      case "/leaderboard":
        NavigationService.instance.navigateToTab(1);
        break;

      case "/events":
        NavigationService.instance.navigateToTab(2);
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
        NavigationService.instance.navigateToTab(0);
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
