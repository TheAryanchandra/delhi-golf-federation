import 'package:flutter/material.dart';
import 'config/routes.dart'; // 👈 your central route file
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
    );
  }
}
