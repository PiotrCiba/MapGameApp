// core/services/route_service.dart
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:map_game_flutter/core/constants/constants.dart';
import 'package:map_game_flutter/core/models/route_model.dart';
import 'package:map_game_flutter/core/services/gps_service.dart';
import 'package:map_game_flutter/core/utils/cache_manager.dart';
import 'package:map_game_flutter/core/services/auth_service.dart';

class RouteService {
  final AuthService _authService;
  final CacheManager _cacheManager;
  final GPSService _gpsService;

  RouteService({
    required AuthService authService,
    required CacheManager cacheManager,
    required GPSService gpsService,
  })  : _authService = authService,
        _cacheManager = cacheManager,
        _gpsService = gpsService;


  Future<List<Route>> getNearbyRoutes() async {
    final cachedRoutes = await _cacheManager.get<List<Route>>('nearby_routes');
    if (cachedRoutes != null) {
      return cachedRoutes;
    }

    final location = await _gpsService.getCurrentLocation();

    final response = await _authService.authenticatedQueryRequest(
      nearbyRoutesEndpoint,
      null,
      {
        'latitude': location.latitude.toString(),
        'longitude': location.longitude.toString(),
        'radius': nearbyRouteRadius.toString(),
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final body = data['body'];

      if(body is! List){
        throw Exception('Invalid response body');
      }

      final routes = body
        .map<Route>((routeData) => Route.fromJson(routeData))
        .toList();

      if(kDebugMode){
        //print the routes
        routes.forEach((route) {
          print('Route: ${route.title}');
        });
      }

      await _cacheManager.set(
        'nearby_routes',
        routes,
        expiration: Duration(hours: 1),
      );

      return routes;
    }

    throw Exception('Failed to fetch nearby routes');
  }


}