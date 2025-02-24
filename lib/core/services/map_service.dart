// core/services/map_service.dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:map_game_flutter/core/models/point_model.dart';

class MapService {
  final String _osmTileUrl = 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png';
  
  Widget buildMapWidget(LatLng centerPoint) {
    return FlutterMap(
      options: MapOptions(
        initialCenter: centerPoint,
        initialZoom: 13.0,
      ),
      children: [
        TileLayer(
          urlTemplate: _osmTileUrl,
          subdomains: ['a', 'b', 'c'],
          maxZoom: 19,
          minZoom: 2,
        ),
      ],
    );
  }

  List<Marker> createRouteMarkers(List<Point> points) {
    return points.map((point) => Marker(
      width: 40.0,
      height: 40.0,
      point: point.coordinates,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
          color: Colors.blue,
        ),
        child: Icon(Icons.place, color: Colors.white),
      ),
    )).toList();
  }
}