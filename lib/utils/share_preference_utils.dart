import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceUtils {
  static SharedPreferenceUtils? _instance;
  static SharedPreferences? _preferences;

  // Private constructor
  SharedPreferenceUtils._internal();

  // Singleton instance getter
  static SharedPreferenceUtils instance() {
    _instance ??= SharedPreferenceUtils._internal();
    return _instance!;
  }

  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
    return;
  }

  // Save a string value
  Future<void> putString(String key, String value) async {
    await _preferences?.setString(key, value);
  }

  // Get a string value
  String? getString(String key, {String? defaultValue}) {
    return _preferences?.getString(key) ?? defaultValue;
  }

  // Save an int value
  Future<void> putInt(String key, int value) async {
    await _preferences?.setInt(key, value);
  }

  // Get an int value
  int? getInt(String key, {int? defaultValue}) {
    return _preferences?.getInt(key) ?? defaultValue;
  }

  // Save a boolean value
  Future<void> putBoolean(String key, bool value) async {
    await _preferences?.setBool(key, value);
  }

  // Get a boolean value
  bool? getBoolean(String key, {bool? defaultValue}) {
    return _preferences?.getBool(key) ?? defaultValue;
  }

  // Remove a specific key
  Future<void> remove(String key) async {
    await _preferences?.remove(key);
  }

  // Clear all preferences
  Future<void> clear() async {
    await _preferences?.clear();
  }
}
