import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';  // 👈 Add this
import 'config/routes.dart';
import 'config/routes_name.dart';

void main() {
  runApp(const GolfApp());
}

class GolfApp extends StatelessWidget {
  const GolfApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Delhi Golf Federation",
      initialRoute: RoutesName.loginScreen, // 👈 start with Login
      routes: appRoutes, // 👈 routes are defined in routes.dart
      theme: ThemeData(
        textTheme: GoogleFonts.urbanistTextTheme( // ✅ Global Urbanist font
          Theme.of(context).textTheme,
        ).copyWith(
          bodyMedium: const TextStyle(fontSize: 15),
          titleLarge: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
