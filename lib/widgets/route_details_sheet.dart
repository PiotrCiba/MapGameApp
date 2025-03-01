// widgets/route_details_sheet.dart
import 'package:flutter/material.dart';
import 'package:map_game_flutter/core/models/route_model.dart' as route_model;
import 'package:map_game_flutter/core/services/gps_service.dart';

class RouteDetailsSheet extends StatelessWidget {
  final route_model.Route route;
  final VoidCallback onBeginRoute;
  final GPSService gpsService;

  const RouteDetailsSheet({
    super.key,
    required this.route,
    required this.onBeginRoute,
    required this.gpsService,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            route.title,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(route.title),
          Text('Distance: [placeholder] km'),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: onBeginRoute,
            child: Text('Begin Route'),
          ),
        ],
      ),
    );
  }
}