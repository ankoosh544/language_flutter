import 'package:flutter/material.dart';
import 'package:language_transalator_example/screens/emergencty_contacts_screen.dart';
import 'package:language_transalator_example/screens/home_screen.dart';
import 'package:language_transalator_example/screens/login_screen.dart';
import 'package:language_transalator_example/screens/profile_screen.dart';
import 'package:language_transalator_example/screens/settings_screen.dart';
import 'package:language_transalator_example/router/route_constants.dart';

class CustomRouter {
  static Route<dynamic> generatedRoute(RouteSettings settings) {
    switch (settings.name) {
      case loginRoute:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case homeRoute:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case settingRoute:
        return MaterialPageRoute(builder: (_) => SettingsScreen());
      case profileRoute:
        return MaterialPageRoute(builder: (_) => ProfileScreen());
      case emergencycontactsRoute:
        return MaterialPageRoute(builder: (_) => EmergencyContactsScreen());
      default:
        // Handle unknown routes here
        throw Exception('Invalid route: ${settings.name}');
      // Alternatively, you can return a default route
      // return MaterialPageRoute(builder: (_) => NotFoundScreen());
    }
  }
}
