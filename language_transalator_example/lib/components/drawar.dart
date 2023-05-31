import 'package:flutter/material.dart';
import 'package:language_transalator_example/components/my_list_tile.dart';
import 'package:language_transalator_example/screens/emergencty_contacts_screen.dart';
import 'package:language_transalator_example/screens/home_screen.dart';
import 'package:language_transalator_example/screens/login_screen.dart';

//import 'package:flutter_menu/screens/emergency_contacts_screen.dart';
import 'package:language_transalator_example/screens/profile_screen.dart';
import 'package:language_transalator_example/screens/settings_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:language_transalator_example/utils/session_manager.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    void goToProfilePage() {
      Navigator.pop(context);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileScreen(),
        ),
      );
    }

    void goToHomePage() {
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
    }

    void goToEmergencyContactPage() {
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => EmergencyContactsScreen()),
      );
    }

    void goToSettingsPage() {
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SettingsScreen()),
      );
    }

    Future<void> logout() async {
      List<String> keysToClear = [
        SessionManager.isLoggedInKey,
        SessionManager.isConnectionAudioPlayedKey,
        // Add other keys for values you want to clear
      ];
      await SessionManager.clearSpecificValues(keysToClear);

      // Navigate to the login or home screen after logout
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }

    return Drawer(
      backgroundColor: const Color.fromARGB(255, 8, 50, 85),
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            child: Icon(
              Icons.person,
              color: Colors.white,
              size: 64,
            ),
          ),
          MyListTile(
            icon: Icons.home,
            text: AppLocalizations.of(context)!.home,
            onTap: () {
              goToHomePage();
            },
          ),
          MyListTile(
            icon: Icons.person,
            text: AppLocalizations.of(context)!.profile,
            onTap: () {
              goToProfilePage();
            },
          ),
          MyListTile(
            icon: Icons.phone,
            text: AppLocalizations.of(context)!.emergencycontacts,
            onTap: () {
              goToEmergencyContactPage();
            },
          ),
          MyListTile(
            icon: Icons.settings,
            text: AppLocalizations.of(context)!.settings,
            onTap: () {
              goToSettingsPage();
            },
          ),
          MyListTile(
            icon: Icons.logout,
            text: AppLocalizations.of(context)!.logout,
            onTap: () {
              logout();
            },
          ),
        ],
      ),
    );
  }
}
