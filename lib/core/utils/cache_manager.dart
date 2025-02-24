// core/utils/cache_manager.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:map_game_flutter/core/models/base_model.dart';

class CacheManager {
  static const String _cacheNamespace = 'game_cache_';

  final SharedPreferences? _prefs;

  CacheManager({SharedPreferences? prefs})
      : _prefs = prefs;

  Future<SharedPreferences> get _sharedPreferences async {
    if (_prefs == null) {
      return await SharedPreferences.getInstance();
    }
    return _prefs;
  }

  // Generic caching methods
  Future<void> set<T>(String key, T value, {Duration? expiration}) async {
    final prefs = await _sharedPreferences;
    final String fullKey = '$_cacheNamespace$key';
    
    if (value is BaseModel) {
      await prefs.setString(fullKey, jsonEncode(value.toJson()));
    } else if (value is List<BaseModel>) {
      final list = value.map((item) => jsonEncode(item.toJson())).toList();
      await prefs.setString(fullKey, jsonEncode(list));
    } else if (value is Map<String, dynamic>) {
      await prefs.setString(fullKey, jsonEncode(value));
    } else {
      await prefs.setString(fullKey, value.toString());
    }

    if (expiration != null) {
      await prefs.setString(
        '$_cacheNamespace${fullKey}_expires',
        (DateTime.now().add(expiration).millisecondsSinceEpoch).toString(),
      );
    }
  }

  Future<T?> get<T>(String key) async {
    final prefs = await _sharedPreferences;
    final String fullKey = '$_cacheNamespace$key';
    
    final expiresAt = prefs.getString('${fullKey}_expires');
    if (expiresAt != null) {
      final expiration = DateTime.fromMillisecondsSinceEpoch(int.parse(expiresAt));
      if (DateTime.now().isAfter(expiration)) {
        await remove(key);
        return null;
      }
    }

    final value = prefs.getString(fullKey);
    if (value == null) return null;

    try {
      if (T == String) {
        return value as T;
      } else if (T == List<BaseModel>) {
        final list = jsonDecode(value) as List;
        return list.map((item) => BaseModel.fromJson(item)).toList() as T;
      } else if (T == Map<String, dynamic>) {
        return jsonDecode(value) as T;
      } else {
        return value as T;
      }
    } catch (e) {
      await remove(key);
      return null;
    }
  }

  Future<void> remove(String key) async {
    final prefs = await _sharedPreferences;
    final String fullKey = '$_cacheNamespace$key';
    
    await prefs.remove(fullKey);
    await prefs.remove('${fullKey}_expires');
  }

  Future<void> clear() async {
    final prefs = await _sharedPreferences;
    final keys = prefs.getKeys();
    
    for (final key in keys) {
      if (key.startsWith(_cacheNamespace)) {
        await prefs.remove(key);
      }
    }
  }

  Future<bool> exists(String key) async {
    final prefs = await _sharedPreferences;
    return prefs.containsKey('$_cacheNamespace$key');
  }
}