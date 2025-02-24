// features/map_screen.dart
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:map_game_flutter/core/models/route_model.dart' as route_model;
import 'package:map_game_flutter/core/services/auth_service.dart';
import 'package:map_game_flutter/core/services/gps_service.dart';
import 'package:map_game_flutter/core/services/route_service.dart';
import 'package:map_game_flutter/core/utils/cache_manager.dart';
import 'package:map_game_flutter/widgets/app_drawer.dart';
import 'package:map_game_flutter/widgets/route_details_sheet.dart';

class MapScreen extends StatefulWidget {
  final AuthService authService;
  final GPSService gpsService;
  final RouteService routeService;
  final CacheManager cacheManager;

  static final String routename = '/map';

  const MapScreen({
    super.key,
    required this.authService,
    required this.gpsService,
    required this.routeService,
    required this.cacheManager,
  });

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  List<route_model.Route> _routes = [];
  LatLng? _currentLocation;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
    _loadRoutes();
  }

  Future<void> _initializeLocation() async {
    final location = await widget.gpsService.getCurrentLocation();
    setState(() {
      _currentLocation = LatLng(location.latitude, location.longitude);
      _mapController.move(_currentLocation!, 13.0);
    });
  }

  Future<void> _loadRoutes() async {
    try {
      final routes = await widget.routeService.getNearbyRoutes();
      setState(() {
        _routes = routes;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading routes: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Map'),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: LatLng(52.069167, 19.480556),
              initialZoom: 13.0,
              onTap: _handleMapShortPress,
              onLongPress: _handleMapLongPress
            ),
            children: [
              TileLayer(
                urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
              ),
              MarkerLayer(markers: _buildRouteMarkers()),
            ],
          ),
          Positioned(
            top: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: _centerOnLocation,
              child: Icon(Icons.location_searching),
            ),
          ),
        ],
      ),
    );
  }

  List<Marker> _buildRouteMarkers() {
    return _routes.map((route) {
      final point = route.points.first;
      return Marker(
        width: 40.0,
        height: 40.0,
        point: point.coordinates,
        child: GestureDetector(
          onTap: () => _showRouteDetails(route),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              color: Colors.blue,
            ),
            child: Icon(Icons.place, color: Colors.white),
          ),
        ),
      );
    }).toList();
  }

  void _showRouteDetails(route_model.Route route) {
    showModalBottomSheet(
      context: context,
      builder: (context) => RouteDetailsSheet(route: route),
    );
  }

  void _centerOnLocation() {
    if (_currentLocation != null) {
      _mapController.move(_currentLocation!, 13.0);
    }
  }

  void _handleMapShortPress(TapPosition tapPosition, LatLng point) {
    // Handle map short press for route selection
  }

  void _handleMapLongPress(TapPosition tapPosition, LatLng point) {
    // Handle map long press for route creation
  }
}