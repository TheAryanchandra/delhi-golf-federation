import 'package:flutter/material.dart';


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
      // theme: AppTheme.lightTheme,
      // routes: AppRoutes.routes,
      // initialRoute: AppRoutes.splash,
    );
  }
}
