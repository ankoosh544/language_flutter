import 'package:flutter/material.dart';

import 'package:language_transalator_example/components/text_field.dart';
import 'package:language_transalator_example/main.dart';
import 'package:language_transalator_example/screens/emergencty_contacts_screen.dart';
import 'package:language_transalator_example/screens/home_screen.dart';
import 'package:language_transalator_example/screens/registration_screen.dart';
import 'package:language_transalator_example/utils/session_manager.dart';
import '../components/language.dart';
import '../components/mybutton.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:language_transalator_example/utils/constants.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final usernameTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  PageController pageController = PageController(initialPage: 0);

  final rememberMeValueKey = 'rememberMe';
  late SharedPreferences sharedPreferences;
  bool rememberMe = false;
  bool isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    initializeSharedPreferences();
    _loadLoginData(); // Load login data when the screen initializes
  }

  Future<void> _loadLoginData() async {
    final prefs = await SharedPreferences.getInstance();
    if (rememberMe) {
      setState(() {
        usernameTextController.text = prefs.getString('username') ?? '';
        passwordTextController.text = prefs.getString('password') ?? '';
      });
    }
  }

  Future<void> initializeSharedPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      rememberMe = sharedPreferences.getBool(rememberMeValueKey) ?? false;
      if (rememberMe) {
        usernameTextController.text =
            sharedPreferences.getString('username') ?? '';
        passwordTextController.text =
            sharedPreferences.getString('password') ?? '';
      }
    });
  }

  void saveLoginData() async {
    final prefs = await SharedPreferences.getInstance();

    if (rememberMe) {
      await prefs.setBool(rememberMeValueKey, true);
      await prefs.setString('username', usernameTextController.text);
      await prefs.setString('password', passwordTextController.text);
    } else {
      await prefs.remove(rememberMeValueKey);
      await prefs.remove('username');
      await prefs.remove('password');
    }
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void _homePage() async {
    Navigator.pop(context);
    await SessionManager.setLoggedIn(true); // Set the login status
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(),
      ),
    );
  }

  void performLogin() {
    // Retrieve entered email and password
    String username = usernameTextController.text;
    String password = passwordTextController.text;

    // Perform login logic here (e.g., calling an API, validating credentials)

    // If login is successful, set the session data and navigate to the homepage
    if (username.isNotEmpty && password.isNotEmpty) {
      if (username == "shek" && password == "shek") {
        SessionManager.setLoggedIn(true); // Set the login status

        saveLoginData(); // Save the login data if "Remember Me" is checked

        _homePage();
      } else {
        showValidationError(
          AppLocalizations.of(context)!.error,
          AppLocalizations.of(context)!.loginerrormsg,
        );
      }
    } else {
      showValidationError(
        AppLocalizations.of(context)!.error,
        AppLocalizations.of(context)!.loginerrormsg,
      );
    }
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
        body: PageView(
          controller: pageController,
          children: [
            _buildLoginScreen(),
            _buildEmergencyContactScreen(),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginScreen() {
    return FutureBuilder<Widget>(
      future: _buildLoginContent(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading indicator while the content is being built
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // Show an error message if an error occurred
          return Text('Error: ${snapshot.error}');
        } else {
          // Show the login content once it's built
          return Stack(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _globe(),
                ),
              ),
              snapshot.data!,
            ],
          );
        }
      },
    );
  }

  Future<Widget> _buildLoginContent() async {
    if (rememberMe &&
        usernameTextController.text.isEmpty &&
        passwordTextController.text.isEmpty) {
      usernameTextController.text =
          sharedPreferences.getString('username') ?? '';
      passwordTextController.text =
          sharedPreferences.getString('password') ?? '';
    }

    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 10,
            ),
            _icon(),
            const SizedBox(
              height: 50,
            ),
            MyTextField(
              controller: usernameTextController,
              hintText: AppLocalizations.of(context)!.username,
              obscureText: false,
            ),
            const SizedBox(
              height: 10,
            ),
            MyTextField(
              controller: passwordTextController,
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
            CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
              title: Text(
                'Remember Me',
                style: TextStyle(color: Colors.white),
              ),
              value: rememberMe,
              onChanged: (value) {
                setState(() {
                  rememberMe = value ?? false;
                });
              },
            ),
            MyButton(
              onTap: performLogin,
              text: AppLocalizations.of(context)!.login,
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context)!.nothaveaccount,
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(
                  width: 5,
                ),
                GestureDetector(
                  onTap: () {
                    _registerPage();
                  },
                  child: Text(
                    AppLocalizations.of(context)!.register,
                    style: const TextStyle(
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

  Widget _buildEmergencyContactScreen() {
    return Center(
      child: EmergencyContactsScreen(),
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

  Widget _globe() {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: DropdownButton<Language>(
            underline: SizedBox(),
            icon: Icon(
              Icons.language,
              color: Colors.white,
            ),
            onChanged: (Language? language) {
              if (language != null) {
                MyApp.setLocale(context, Locale(language.languageCode, ''));
              }
            },
            items: Language.languageList()
                .map<DropdownMenuItem<Language>>(
                  (e) => DropdownMenuItem<Language>(
                    value: e,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text(
                          e.flag,
                          style: TextStyle(fontSize: 30),
                        ),
                        Text(e.name),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
