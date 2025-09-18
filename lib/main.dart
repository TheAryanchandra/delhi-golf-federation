import 'package:flutter/material.dart';

import 'config/routes.dart'; // 👈 correct import
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
      initialRoute: RoutesName.loginScreen,
      routes: appRoutes, // 👈 all routes available
    );
  }
}
