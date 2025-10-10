import 'dart:async';
import 'package:delhi_golf_federation/bloc/event/bloc/event_bloc.dart';
import 'package:delhi_golf_federation/bloc/eventregister/bloc/eventregister_bloc.dart';
import 'package:delhi_golf_federation/bloc/getdata/bloc/getdata_bloc.dart';
import 'package:delhi_golf_federation/bloc/getdata/bloc/getdata_event.dart';
import 'package:delhi_golf_federation/config/network/dio_client.dart';
import 'package:delhi_golf_federation/config/network/web_constant.dart';
import 'package:delhi_golf_federation/data/auth_repository.dart';
import 'package:delhi_golf_federation/data/eventregister_repository.dart';
import 'package:delhi_golf_federation/data/events_repository.dart';
import 'package:delhi_golf_federation/data/getdatarepository.dart';
import 'package:delhi_golf_federation/database/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'config/routes.dart';
import 'config/routes_name.dart';

// Import your blocs & repositories

import 'bloc/auth/auth_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize DioClient
  final dioClient = DioClient();
  await dioClient.init(baseUrl: baseUrl);

  // Listen for auth failures
  dioClient.authFailureController.stream.listen((failed) {
    if (failed) {
      // Navigate to login screen using navigator key
      navigatorKey.currentState?.pushNamedAndRemoveUntil(
        RoutesName.loginScreen,
        (route) => false,
      );
    }
  });

  final bool isLoggedIn = await SharedPreferencesHelper.isLoggedIn();
  final String? storedToken = await SharedPreferencesHelper.getUserToken();

  debugPrint('🔐 Stored auth token: $storedToken');

  // Token refresh is now handled automatically by DioClient interceptor
  // when a 401/403 response is received

  // 🧪 UNCOMMENT TO TEST TOKEN REFRESH:
  // await DioClient().testTokenRefresh();
  // debugPrint('🧪 Token corrupted for testing. Next API call will trigger refresh.');

  runApp(GolfApp(isLoggedIn: isLoggedIn, storedToken: storedToken));
}

// Add global navigator key
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class GolfApp extends StatelessWidget {
  const GolfApp({super.key, required this.isLoggedIn, this.storedToken});

  final bool isLoggedIn;
  final String? storedToken;

  @override
  Widget build(BuildContext context) {
    final bool hasToken = storedToken != null && storedToken!.isNotEmpty;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => RegistrationBloc(RegistrationRepository())),
        BlocProvider<LoginBloc>(
          create: (context) => LoginBloc(LoginRepository()),
        ),
        BlocProvider(create: (_) => LogoutBloc(LogoutRepository())),
        BlocProvider(create: (_) => IndustryBloc(IndustryRepository())),
        BlocProvider(create: (_) => RefreshTokenBloc(RefreshTokenRepository())),
        BlocProvider(
          create: (_) => EventsBloc(EventsRepository()), // positional argument
        ),
        BlocProvider(
          create: (_) =>
              UserDataBloc(authRepository: AuthRepository())
                ..add(FetchUserDataEvent()),
        ),
        BlocProvider(
          create: (_) => EventRegistrationBloc(EventRegistrationRepository()),
        ),
      ],
      child: SafeArea(
        bottom: true,
        left: false,
        right: false,
        top: false,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Delhi Golf Federation",
          initialRoute: isLoggedIn && hasToken
              ? RoutesName.homeScreen
              : RoutesName.loginScreen,
          routes: appRoutes,
          theme: ThemeData(
            textTheme:
                GoogleFonts.urbanistTextTheme(
                  Theme.of(context).textTheme,
                ).copyWith(
                  bodyMedium: const TextStyle(fontSize: 15),
                  titleLarge: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
          ),
        ),
      ),
    );
  }
}
