import 'package:flutter/material.dart';
import 'package:language_transalator_example/components/mybutton.dart';
import 'package:language_transalator_example/components/text_field.dart';
import 'package:language_transalator_example/screens/home_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:language_transalator_example/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:language_transalator_example/utils/constants.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();
  PageController pageController = PageController(initialPage: 0);
  bool isPasswordVisible =
      false; // Moved outside the _buildLoginScreen() method

  void _homePage() {
    Navigator.pop(context);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(),
      ),
    );
  }

  void _gotoLoginPage() {
    Navigator.pop(context);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ),
    );
  }

  Future<void> _registerUser(BuildContext context) async {
    String username = usernameController.text;
    String email = emailController.text;
    String password = passwordController.text;
    if (username.isEmpty && email.isEmpty && password.isEmpty) {
      showValidationError('Validation Error', "Required Fields are missing");
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', usernameController.text);
    await prefs.setString('email', emailController.text);
    await prefs.setString('phoneNumber', phoneNumberController.text);
    await prefs.setString('password', passwordController.text);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

  void showValidationError(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Constants.PRIMARY_COLOR,
        title: Text(
          title,
          style: const TextStyle(
            color: Constants.WHITE,
          ),
        ),
        content: Text(
          message,
          style: const TextStyle(
            color: Constants.WHITE,
            fontSize: 18,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'OK',
              style: TextStyle(
                color: Constants.WHITE,
              ),
            ),
          ),
        ],
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
            Color.fromARGB(255, 8, 50, 85),
            Colors.grey,
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: PageView(
          controller: pageController,
          children: [
            _buildLoginScreen(),
          ],
        ),
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
              controller: usernameController,
              hintText: AppLocalizations.of(context)!.username,
              obscureText: false,
            ),
            const SizedBox(
              height: 10,
            ),
            MyTextField(
              controller: emailController,
              hintText: AppLocalizations.of(context)!.email,
              obscureText: false,
            ),
            const SizedBox(
              height: 10,
            ),
            MyTextField(
              controller: passwordController,
              hintText: AppLocalizations.of(context)!.password,
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
              height: 10,
            ),
            MyTextField(
              controller: phoneNumberController,
              hintText: AppLocalizations.of(context)!.phone,
              obscureText: false,
            ),
            const SizedBox(
              height: 50,
            ),
            MyButton(
              onTap: () => _registerUser(context),
              text: AppLocalizations.of(context)!.register,
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Already hava an Account?",
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(
                  width: 5,
                ),
                GestureDetector(
                  onTap: () {
                    _gotoLoginPage();
                  },
                  child: const Text(
                    "Login",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ],
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
        shape: BoxShape.rectangle,
      ),
      child: const Icon(Icons.app_registration, color: Colors.white, size: 120),
    );
  }
}
