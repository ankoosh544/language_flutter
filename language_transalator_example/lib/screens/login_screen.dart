import 'package:flutter/material.dart';
import 'package:language_transalator_example/components/my_list_tile.dart';
import 'package:language_transalator_example/components/text_field.dart';
import 'package:language_transalator_example/screens/home_screen.dart';
import '../components/mybutton.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart' as gen;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

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
      )),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: _page(),
      ),
    );
  }

  Widget _page() {
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
              obscureText: true,
            ),
            const SizedBox(
              height: 50,
            ),
            MyButton(
              onTap:
                  performLogin, // Call the login function when the button is tapped
              text: gen.AppLocalizations.of(context)!.login,
            ),
          ],
        ),
      ),
    );
  }

  Widget _icon() {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 2),
          shape: BoxShape.circle),
      child: const Icon(Icons.person, color: Colors.white, size: 120),
    );
  }
}
