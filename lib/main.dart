import 'package:delhi_golf_federation/data/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'config/routes.dart';
import 'config/routes_name.dart';

// Import your blocs & repositories

import 'bloc/auth/auth_bloc.dart';


void main() {
  runApp(const GolfApp());
}

class GolfApp extends StatelessWidget {
  const GolfApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
       
        BlocProvider(create: (_) => RegistrationBloc(RegistrationRepository())),
      ],
      child: SafeArea(
        bottom: true,
        left: false,
        right: false,
        top: false,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Delhi Golf Federation",
          initialRoute: RoutesName.loginScreen, // 👈 start with Login
          routes: appRoutes, // 👈 routes are defined in routes.dart
          theme: ThemeData(
            textTheme: GoogleFonts.urbanistTextTheme(
              Theme.of(context).textTheme,
            ).copyWith(
              bodyMedium: const TextStyle(fontSize: 15),
              titleLarge:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
