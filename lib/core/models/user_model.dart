// core/models/player_model.dart
import 'package:map_game_flutter/core/models/base_model.dart';

class User implements BaseModel, Identifiable {
  @override
  String id;
  String username;
  String email;
  List<String> completedPoints = [];

  User({
    required this.id,
    required this.username,
    required this.email,
  });


  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
    );
  }
  
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
    };
  }
}