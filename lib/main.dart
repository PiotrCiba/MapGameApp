// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_game_flutter/core/services/auth_service.dart';
import 'package:map_game_flutter/core/services/route_service.dart';
import 'package:map_game_flutter/core/services/gps_service.dart';
import 'package:map_game_flutter/core/utils/cache_manager.dart';
import 'package:map_game_flutter/features/auth/bloc/auth_bloc.dart';
import 'package:map_game_flutter/features/map_screen.dart';
import 'package:map_game_flutter/features/auth/login_screen.dart';
import 'package:map_game_flutter/features/auth/register_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final authService = AuthService();
  final cacheManager = CacheManager();
  final gpsService = GPSService();
  final routeService = RouteService(
    authService: authService,
    cacheManager: cacheManager,
    gpsService: gpsService,
  );

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(
            authService,
            cacheManager,
          ),
        ),
      ],
      child: MyApp(
        authService: authService,
        routeService: routeService,
        gpsService: gpsService,
        cacheManager: cacheManager,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final AuthService authService;
  final RouteService routeService;
  final GPSService gpsService;
  final CacheManager cacheManager;

  const MyApp({
    super.key,
    required this.authService,
    required this.routeService,
    required this.gpsService,
    required this.cacheManager,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'City Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
      ),
      home: MapScreen(
        authService: authService,
        routeService: routeService,
        gpsService: gpsService,
        cacheManager: cacheManager,
      ),
      routes: {
        LoginScreen.routeName: (context) => LoginScreen(
              authService: authService,
              cacheManager: cacheManager,
            ),
        RegisterScreen.routeName: (context) => RegisterScreen(
              authService: authService,
              cacheManager: cacheManager,
            ),
      },
    );
  }
}