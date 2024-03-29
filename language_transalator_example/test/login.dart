import 'package:flutter/material.dart';
import 'package:language_transalator_example/components/mybutton.dart';
import 'package:language_transalator_example/components/text_field.dart';
import 'package:language_transalator_example/screens/emergencty_contacts_screen.dart';
import 'package:language_transalator_example/screens/home_screen.dart';
import 'package:language_transalator_example/screens/registration_screen.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart' as gen;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  bool isPasswordVisible = false;

  void _homePage() {
    Navigator.pop(context);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(),
      ),
    );
  }

  void performLogin() {
    // Retrieve entered email and password
    String email = emailTextController.text;
    String password = passwordTextController.text;

    // Perform login logic here (e.g., calling an API, validating credentials)

    // If login is successful, navigate to the homepage
    if (email.isNotEmpty && password.isNotEmpty) {
      _homePage();
    } else {
      // Handle invalid login credentials or other error cases
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(gen.AppLocalizations.of(context)!.error),
          content: Text(gen.AppLocalizations.of(context)!.loginerrormsg),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void _registerPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegistrationScreen(),
      ),
    );
  }

  void _emergencyContactsPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EmergencyContactsScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Colors.blue,
            Colors.pink,
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: _buildLoginScreen(),
      ),
    );
  }

  Widget _buildLoginScreen() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _icon(),
            const SizedBox(
              height: 50,
            ),
            MyTextField(
              controller: emailTextController,
              hintText: 'Email',
              obscureText: false,
            ),
            const SizedBox(
              height: 10,
            ),
            MyTextField(
              controller: passwordTextController,
              hintText: 'Password',
              obscureText: !isPasswordVisible,
              suffixIcon: IconButton(
                icon: Icon(
                  isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    isPasswordVisible = !isPasswordVisible;
                  });
                },
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            MyButton(
              onTap: performLogin,
              text: gen.AppLocalizations.of(context)!.login,
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Not Remember Password?",
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(
                  width: 5,
                ),
                GestureDetector(
                  onTap: _registerPage,
                  child: const Text(
                    "Register Now",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 100,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: _emergencyContactsPage,
                  child: const Text(
                    "EmergencyContacts",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _icon() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 2),
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.person, color: Colors.white, size: 120),
    );
  }
}
