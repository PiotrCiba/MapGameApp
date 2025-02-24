// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:map_game_flutter/core/services/auth_service.dart';
import 'package:map_game_flutter/core/services/gps_service.dart';
import 'package:map_game_flutter/core/services/route_service.dart';
import 'package:map_game_flutter/core/utils/cache_manager.dart';

import 'package:map_game_flutter/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(
      authService: AuthService(),
      gpsService: GPSService(),
      cacheManager: CacheManager(),
      routeService: RouteService(
        authService: AuthService(),
        cacheManager: CacheManager(),
        gpsService: GPSService(),
      ),
    ));

    //write tests for the login screen
    //write tests for the register screen
    //write tests for the map screen
  });
}
