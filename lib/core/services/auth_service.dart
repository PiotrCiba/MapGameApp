// core/services/auth_service.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:map_game_flutter/core/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:map_game_flutter/core/models/user_model.dart';

class AuthService {
  final http.Client _client;

  AuthService({http.Client? client})
      : _client = client ?? http.Client();

  // Helper method to make authenticated requests
  Future<http.Response> authenticatedRequest(
    String url,
    Map<String, String>? headers,
  ) async {
    final token = await _getToken();
    final authHeaders = {
      'Authorization': 'Bearer $token',
      ...?headers,
    };

    //log the request
    if (kDebugMode) {
      print('Requesting: $url');
      print('Headers: $authHeaders');
    }

    return _client.get(
      Uri.parse('$baseUrl$url'),
      headers: authHeaders,
    );
  }

  //authenticatedQueryRequest
  Future<http.Response> authenticatedQueryRequest(
    String url,
    Map<String, String>? headers,
    Map<String, String>? queryParameters,
  ) async {
    final token = await _getToken();
    final authHeaders = {
      'Authorization': 'Bearer $token',
      ...?headers,
    };

    //log the request
    if (kDebugMode) {
      print('Requesting: $url');
      print('Headers: $authHeaders');
      print('Query Parameters: $queryParameters');
    }

    final uri = Uri.parse('$baseUrl$url').replace(queryParameters: queryParameters);
    return _client.get(
      uri,
      headers: authHeaders,
    );
  }


  // Authentication methods
  Future<User> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl$loginEndpoint'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> databody = jsonDecode(jsonDecode(response.body)['body']);
        final token = databody['token'];
        final player = User.fromJson(databody['user']);

        await _storeToken(token);
        await _storeCurrentUser(player);

        return player;
      } else {
        throw Exception('Login failed: ${response.body}');
      }
    } catch (e) {
      throw Exception('Login error: $e');
    }
  }

  Future<User> register({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl$registerEndpoint'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final token = data['token'];
        final player = User.fromJson(data['user']);

        await _storeToken(token);
        await _storeCurrentUser(player);

        return player;
      } else {
        throw Exception('Registration failed: ${response.body}');
      }
    } catch (e) {
      throw Exception('Registration error: $e');
    }
  }

  // Token management
  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(authTokenKey);
    
    if (token == null) {
      throw Exception('No authentication token found');
    }

    return token;
  }

  Future<void> _storeToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(authTokenKey, token);
  }

  // Current user management
  Future<User?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(userKey);
      
      if (userJson == null) {
        return null;
      }

      return User.fromJson(jsonDecode(userJson));
    } catch (e) {
      throw Exception('Error getting current user: $e');
    }
  }

  Future<void> _storeCurrentUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(userKey, jsonEncode(user.toJson()));
  }

  // Logout functionality
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(authTokenKey);
    await prefs.remove(userKey);
  }
}