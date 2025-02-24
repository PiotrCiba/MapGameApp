// core/models/route_model.dart
import 'package:geolocator_platform_interface/src/models/position.dart';
import 'package:latlong2/latlong.dart';

import 'base_model.dart';

class Point implements BaseModel, Identifiable {
  @override
  String id;
  String name;
  String description;
  LatLng coordinates;
  double radius;
  bool isVisible;
  String unlockCode;
  List<Map<String, dynamic>> requirements;
  List<Map<String, dynamic>> tasks;

  Point({
    required this.id,
    required this.name,
    required this.description,
    required this.coordinates,
    required this.radius,
    required this.isVisible,
    required this.unlockCode,
    required this.requirements,
    required this.tasks,
  });

  factory Point.fromJson(Map<String, dynamic> json) {
    final location = json['location'] as Map<String, dynamic>;
    final coordinates = location['coordinates'] != null
        ? LatLng(location['coordinates'][1], location['coordinates'][0])
        : LatLng(0.0, 0.0);
    return Point(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      coordinates: coordinates,
      radius: json['radius'] ?? 0.0,
      isVisible: json['isVisible'] ?? false,
      unlockCode: json['unlockCode'] ?? '',
      requirements: json['requirements'] != null
          ? (json['requirements'] as List).map((req) => req as Map<String, dynamic>).toList()
          : [],
      tasks: json['tasks'] != null
          ? (json['tasks'] as List).map((task) => task as Map<String, dynamic>).toList()
          : [],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'coordinates': coordinates,
      'radius': radius,
      'isVisible': isVisible,
      'unlockCode': unlockCode,
      'requirements': requirements,
      'tasks': tasks,
    };
  }

  distanceTo(Position location) {
    final Distance distance = Distance();
    return distance(coordinates, LatLng(location.latitude, location.longitude));
  }
}