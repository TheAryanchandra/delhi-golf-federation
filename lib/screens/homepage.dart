import 'package:delhi_golf_federation/components/topnavigationbar.dart';
import 'package:delhi_golf_federation/components/customdrawer.dart';
import 'package:delhi_golf_federation/widgets/homepagewidget.dart';
import 'package:flutter/material.dart';
// <-- import your reusable TopNavigationBar

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: const [
            /// Banner
            _TopBanner(),

            SizedBox(height: 15),

            /// Sponsors Section
            SponsorsSection(),

            SizedBox(height: 20),

            /// Golf Club Facilities
            GolfClubFacilities(),

            SizedBox(height: 20),

            /// Upcoming Events + Team Section
            UpcomingEventsSection(),

            SizedBox(height: 20),

            /// Bottom Banner
            BottomBanner(),
          ],
        ),
      ),
    );
  }
}

class _TopBanner extends StatelessWidget {
  const _TopBanner();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background Image
          Image.asset(
            "assets/images/welcome.png",
            height: 140,
            width: double.infinity,
            fit: BoxFit.contain,
          ),

          // Dark overlay for better text visibility
          Container(
            height: 140,
            width: double.infinity,
            color: Colors.black.withOpacity(0.4),
          ),

          // Text overlay
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                "Welcome to the",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              SizedBox(height: 4),
              Text(
                "Delhi Golf Federation",
                style: TextStyle(
                  color: Color(0xFFD6B686), // gold-like color
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
