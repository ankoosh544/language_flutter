// import 'package:flutter/material.dart';
// import 'package:language_transalator_example/components/my_list_tile.dart';
// import 'package:language_transalator_example/components/text_field.dart';
// import 'package:language_transalator_example/screens/emergencty_contacts_screen.dart';
// import 'package:language_transalator_example/screens/home_screen.dart';
// import 'package:language_transalator_example/screens/registration_screen.dart';
// import '../components/mybutton.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart' as gen;

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({Key? key}) : super(key: key);

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final emailTextController = TextEditingController();
//   final passwordTextController = TextEditingController();
//   PageController pageController = PageController(initialPage: 0);

//   void _homePage() {
//     Navigator.pop(context);

//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => HomeScreen(),
//       ),
//     );
//   }

//   void performLogin() {
//     // Retrieve entered email and password
//     String email = emailTextController.text;
//     String password = passwordTextController.text;

//     // Perform login logic here (e.g., calling an API, validating credentials)

//     // If login is successful, navigate to the homepage
//     if (email.isNotEmpty && password.isNotEmpty) {
//       _homePage();
//     } else {
//       // Handle invalid login credentials or other error cases
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: Text(gen.AppLocalizations.of(context)!.error),
//           content: Text(gen.AppLocalizations.of(context)!.loginerrormsg),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: Text('OK'),
//             ),
//           ],
//         ),
//       );
//     }
//   }

//   void _registerPage() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => RegistrationScreen(),
//       ),
//     );
//   }

//   void _emergencyContactsPage() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => EmergencyContactsScreen(),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     pageController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topRight,
//           end: Alignment.bottomLeft,
//           colors: [
//             Colors.blue,
//             Colors.pink,
//           ],
//         ),
//       ),
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         body: PageView(
//           controller: pageController,
//           children: [
//             _buildLoginScreen(),
//             _buildEmergencyContactScreen(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildLoginScreen() {
//     bool isPasswordVisible = false;

//     return Padding(
//       padding: const EdgeInsets.all(32.0),
//       child: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             _icon(),
//             const SizedBox(
//               height: 50,
//             ),
//             MyTextField(
//               controller: emailTextController,
//               hintText: 'Email',
//               obscureText: false,
//             ),
//             const SizedBox(
//               height: 10,
//             ),
//             MyTextField(
//               controller: passwordTextController,
//               hintText: 'Password',
//               obscureText: !isPasswordVisible,
//               suffixIcon: IconButton(
//                 icon: Icon(
//                   isPasswordVisible ? Icons.visibility_off : Icons.visibility,
//                   color: Colors.white,
//                 ),
//                 onPressed: () {
//                   setState(() {
//                     isPasswordVisible = !isPasswordVisible;
//                   });
//                 },
//               ),
//             ),
//             const SizedBox(
//               height: 50,
//             ),
//             MyButton(
//               onTap: performLogin,
//               text: gen.AppLocalizations.of(context)!.login,
//             ),
//             const SizedBox(
//               height: 15,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Text(
//                   "Not Remember Password?",
//                   style: TextStyle(color: Colors.white),
//                 ),
//                 const SizedBox(
//                   width: 5,
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     _registerPage();
//                   },
//                   child: const Text(
//                     "Register Now",
//                     style: TextStyle(
//                         fontWeight: FontWeight.bold, color: Colors.white),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildEmergencyContactScreen() {
//     return Center(
//       child: EmergencyContactsScreen(),
//     );
//   }

//   Widget _icon() {
//     return Container(
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.white, width: 2),
//         shape: BoxShape.circle,
//       ),
//       child: const Icon(Icons.person, color: Colors.white, size: 120),
//     );
//   }
// }
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

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final usernameTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  PageController pageController = PageController(initialPage: 0);
  bool isPasswordVisible = false;
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
      if (username == "public" && password == "public") {
        SessionManager.setLoggedIn(true); // Set the login status

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

  void showValidationError(String message, String title) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
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
            const SizedBox(
              height: 50,
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
              color: Colors.black,
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
