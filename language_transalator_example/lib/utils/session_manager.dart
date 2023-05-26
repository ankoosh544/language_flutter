import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static final String _isLoggedInKey = 'isLoggedIn';
  final rememberMeValueKey = 'rememberMe';
  static final String _username = "";
  static final String _password = "";

  static Future<void> setLoggedIn(bool isLoggedIn) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_isLoggedInKey, isLoggedIn);

    //wait preferences.setString(_username);
  }

  static Future<bool> isLoggedIn() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getBool(_isLoggedInKey) ?? false;
  }
}
