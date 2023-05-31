import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart' as gen;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:language_transalator_example/utils/session_manager.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? userName;
  String? email;
  String? phoneNumber;

  @override
  void initState() {
    super.initState();
    loadProfileData();
  }

  Future<void> loadProfileData() async {
    userName = await SessionManager.getUsername();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      email = prefs.getString('email');
      phoneNumber = prefs.getString('phoneNumber');
    });
  }

  Future<void> saveProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', userName!);
    await prefs.setString('email', email!);
    await prefs.setString('phoneNumber', phoneNumber!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(gen.AppLocalizations.of(context)!.profile),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 64.0,
              backgroundImage: AssetImage('assets/profile_image.png'),
            ),
            SizedBox(height: 16.0),
            Text(
              userName ?? 'UserName',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            SizedBox(height: 16.0),
            ListTile(
              leading: Icon(Icons.email),
              title: Text(email ?? 'Email'),
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text(phoneNumber ?? 'PhoneNumber'),
            ),
            SizedBox(height: 16.0),
            // ElevatedButton(
            //   onPressed: () {
            //     // Navigate to the edit profile screen
            //   },
            //   child: Text('Edit Profile'),
            // ),
          ],
        ),
      ),
    );
  }
}
