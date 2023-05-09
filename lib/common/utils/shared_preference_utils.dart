import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

abstract class IStorageService<T> {
  String key = "";
  IStorageService(this.key);
  Future<void> set({
    required T data,
  });

  Future<T?> get({
    required T Function(Map<String, dynamic>) fromJson,
  });

  Future<List<T>?> getList({
    required T Function(Map<String, dynamic>) fromJson,
  });

  Future<bool> remove();
}

class SharedPreferencesService<T> extends IStorageService<T> {
  SharedPreferencesService(key) : super(key);

  Future<void> set({
    required T data,
    // Map<String, dynamic> Function(T)? toJson,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (T == bool) {
      prefs.setBool(key, data as bool);
      return;
    }
    if (T == int) {
      prefs.setInt(key, data as int);
      return;
    }
    if (T == double) {
      prefs.setDouble(key, data as double);
      return;
    }
    if (T == String) {
      prefs.setString(key, data as String);
      return;
    }
    prefs.setString(key, json.encode(data));
  }

  Future<T?> get({
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (T == bool) {
      final dataBool = prefs.getBool(key);
      return dataBool as T?;
    }
    if (T == int) {
      final dataInt = prefs.getInt(key);
      return dataInt as T?;
    }
    if (T == double) {
      final dataDouble = prefs.getDouble(key);
      return dataDouble as T?;
    }
    final dataStr = prefs.getString(key);
    if (dataStr == null) {
      return null;
    }
    if (T == String || fromJson == null) {
      return dataStr as T?;
    }
    try {
      final data = fromJson(json.decode(dataStr));
      return data;
    } catch (err) {
      return null;
    }
  }

  @override
  Future<List<T>?> getList({
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final dataStr = prefs.getString(key);
    if (dataStr == null) {
      return null;
    }
    try {
      return (jsonDecode(dataStr) as List<dynamic>)
          .map((item) => fromJson(item))
          .toList();
    } catch (err) {
      return null;
    }
  }

  Future<bool> remove() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove(key);
  }
}