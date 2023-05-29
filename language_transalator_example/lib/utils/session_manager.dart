import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class SessionManager {
  static final String _isLoggedInKey = 'isLoggedIn';
  static final String _rememberMeKey = 'rememberMe';
  static final String _usernameKey = 'username';
  static final String _passwordKey = 'password';

  static final String _isAudioEnabledKey = 'isAudioEnabled';
  static final String _isVisualEnabledKey = 'isVisualEnabled';
  static final String _isNotificationsEnabledKey = 'isNotificationsEnabled';
  static final String _isDarkModeEnabledKey = 'isDarkModeEnabled';
  static final String _isPresidentEnabledKey = 'isPresidentEnabled';
  static final String _isDisablePeopleEnabledKey = 'isDisablePeopleEnabled';
  static const String _connectedDeviceKey = 'connectedDevice';

  static Future<String?> getConnectedDeviceId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_connectedDeviceKey);
  }

  static Future<void> setConnectedDeviceId(String deviceId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_connectedDeviceKey, deviceId);
  }

  static Future<void> clearConnectedDevice() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_connectedDeviceKey);
  }

  static Future<void> setLoggedIn(bool isLoggedIn) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_isLoggedInKey, isLoggedIn);
  }

  static Future<bool> isLoggedIn() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getBool(_isLoggedInKey) ?? false;
  }

  static Future<void> setRememberMe(bool rememberMe) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_rememberMeKey, rememberMe);
  }

  static Future<bool> getRememberMe() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getBool(_rememberMeKey) ?? false;
  }

  static Future<void> saveCredentials(String username, String password) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_usernameKey, username);
    await preferences.setString(_passwordKey, password);
  }

  static Future<String?> getUsername() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(_usernameKey);
  }

  static Future<String?> getPassword() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(_passwordKey);
  }

  static Future<void> setSettings({
    bool isAudioEnabled = false,
    bool isVisualEnabled = false,
    bool isNotificationsEnabled = false,
    bool isDarkModeEnabled = false,
    bool isPresidentEnabled = false,
    bool isDisablePeopleEnabled = false,
  }) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_isAudioEnabledKey, isAudioEnabled);
    await preferences.setBool(_isVisualEnabledKey, isVisualEnabled);
    await preferences.setBool(
      _isNotificationsEnabledKey,
      isNotificationsEnabled,
    );
    await preferences.setBool(_isDarkModeEnabledKey, isDarkModeEnabled);
    await preferences.setBool(_isPresidentEnabledKey, isPresidentEnabled);
    await preferences.setBool(
      _isDisablePeopleEnabledKey,
      isDisablePeopleEnabled,
    );
  }

  static Future<Map<String, dynamic>> getSettings() async {
    final preferences = await SharedPreferences.getInstance();
    return {
      'isAudioEnabled': preferences.getBool(_isAudioEnabledKey) ?? false,
      'isVisualEnabled': preferences.getBool(_isVisualEnabledKey) ?? false,
      'isNotificationsEnabled':
          preferences.getBool(_isNotificationsEnabledKey) ?? false,
      'isDarkModeEnabled': preferences.getBool(_isDarkModeEnabledKey) ?? false,
      'isPresidentEnabled':
          preferences.getBool(_isPresidentEnabledKey) ?? false,
      'isDisablePeopleEnabled':
          preferences.getBool(_isDisablePeopleEnabledKey) ?? false,
    };
  }

  initialize() {}

  // static Future<void> clearSession() async {
  //   // Clear session information here
  //   // For example, you can clear stored user credentials or settings
  //   // using shared preferences or other storage mechanisms
  //   // Example using shared preferences:
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.clear();
  // }
}
