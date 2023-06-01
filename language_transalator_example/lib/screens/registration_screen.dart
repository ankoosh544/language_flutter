import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:language_transalator_example/components/mybutton.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:language_transalator_example/screens/home_screen.dart';
import 'package:language_transalator_example/screens/login_screen.dart';
import 'package:language_transalator_example/utils/constants.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;
  String selectedPrefix = '+39';

  void _gotoLoginPage() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  Future<void> _registerUser(BuildContext context) async {
    String username = usernameController.text;
    String email = emailController.text;
    String password = passwordController.text;
    String phoneNumber = selectedPrefix + phoneNumberController.text;

    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      showValidationError('Validation Error', 'Required fields are missing');
      return;
    }

    if (!validateEmail(email)) {
      showValidationError('Validation Error', 'Invalid email address');
      return;
    }

    // if (!validatePhoneNumber(phoneNumber)) {
    //   showValidationError('Validation Error', 'Invalid phone number');
    //   return;
    // }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', usernameController.text);
    await prefs.setString('email', emailController.text);
    await prefs.setString('phoneNumber', phoneNumber);
    await prefs.setString('password', passwordController.text);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

  bool validateEmail(String email) {
    String emailRegex = r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$';
    RegExp regex = RegExp(emailRegex);
    return regex.hasMatch(email);
  }

  // bool validatePhoneNumber(String phoneNumber) {
  //   String phoneRegex = r'^\+\d{1,3}-\d{6,16}$';
  //   RegExp regex = RegExp(phoneRegex);
  //   return regex.hasMatch(phoneNumber);
  // }

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
            const SizedBox(height: 50),
            TextField(
              controller: usernameController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.username,
                hintStyle: TextStyle(color: Colors.grey),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                prefixIcon: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: emailController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.email,
                hintStyle: TextStyle(color: Colors.grey),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                prefixIcon: Icon(
                  Icons.email,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: passwordController,
              obscureText: !isPasswordVisible,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.password,
                hintStyle: TextStyle(color: Colors.grey),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                prefixIcon: Icon(
                  Icons.lock,
                  color: Colors.white,
                ),
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
            ),
            SizedBox(height: 10),
            Row(
              children: [
                DropdownButton<String>(
                  value: selectedPrefix,
                  onChanged: (newValue) {
                    setState(() {
                      selectedPrefix = newValue!;
                    });
                  },
                  items: <String>['+39', '+34'].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: TextStyle(color: Colors.grey)),
                    );
                  }).toList(),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: phoneNumberController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.phone,
                      hintStyle: TextStyle(color: Colors.grey),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 50),
             MyButton(
  onTap: () => _registerUser(context),
  text: AppLocalizations.of(context)!.register,
),

              
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already have an Account?',
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(width: 5),
                GestureDetector(
                  onTap: _gotoLoginPage,
                  child: Text(
                    'Login',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
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
      child: Image.asset(
        'assets/images/Sofia2.png',
        scale: 1.0,
      ),
    );
  }
}
