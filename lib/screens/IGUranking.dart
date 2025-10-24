import 'package:delhi_golf_federation/components/color_constants.dart';
import 'package:delhi_golf_federation/components/topnavigationbar.dart';
import 'package:delhi_golf_federation/widgets/commonwebpage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IGURankingScreen extends StatefulWidget {
  const IGURankingScreen({Key? key}) : super(key: key);

  @override
  State<IGURankingScreen> createState() => _IGURankingScreenState();
}

class _IGURankingScreenState extends State<IGURankingScreen> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.urbanistTextTheme(Theme.of(context).textTheme)
            .copyWith(
              bodyMedium: const TextStyle(fontSize: 15),
              titleLarge: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
      ),
      home: Scaffold(
        backgroundColor: Colors.white,
        // appBar: TopNavigationBar(
        //   showBackButton: true,
        //   onBackTap: () => Navigator.pop(context),
        // ),
        body: Column(
          children: [
            // 🔹 HEADER SECTION
            

            // 🔹 WEBVIEW SECTION
            Expanded(
              child: CommonWebPageScreen(
                title: "IGU Ranking",
                url: "https://indiangolfunion.org/order-of-merit-2025/",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
