// core/models/route_model.dart
import 'package:geolocator_platform_interface/src/models/position.dart';
import 'package:latlong2/latlong.dart';
import 'package:map_game_flutter/core/models/point_model.dart';

import 'base_model.dart';

class Route implements BaseModel, Identifiable {
  @override
  String id;
  String title;
  List<Point> points;
  bool isCompleted = false;

  Route({
    required this.id,
    required this.title,
    required this.points,
  });

  factory Route.fromJson(Map<String, dynamic> json) {
    return Route(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      points: (json['points'] as List)
      .map((point) => Point.fromJson(point))
      .toList(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'points': points.map((point) => point.toJson()).toList(),
    };
  }

  distanceTo(Position location) {
    //calculate the closest distance between the route and the location
    final point = points.map((point) => point.distanceTo(location))
                        .reduce((value, element) => value < element ? value : element);
    Distance distance = Distance();
    return distance(
      LatLng(location.latitude, location.longitude),
      point.coordinates,
    );
  }
}