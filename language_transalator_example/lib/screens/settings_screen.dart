import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../components/language.dart';
import '../main.dart';

// // class SettingsScreen extends StatefulWidget {
// //   @override
// //   _SettingsScreenState createState() => _SettingsScreenState();
// // }

// // class _SettingsScreenState extends State<SettingsScreen> {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text(AppLocalizations.of(context)!.settings),
// //         actions: <Widget>[
// //           Container(
// //             child: Padding(
// //               padding: EdgeInsets.all(10.0),
// //               child: DropdownButton<Language>(
// //                 underline: SizedBox(),
// //                 icon: Icon(
// //                   Icons.language,
// //                   color: Colors.black,
// //                 ),
// //                 onChanged: (Language? language) {
// //                   if (language != null) {
// //                     MyApp.setLocale(context, Locale(language.languageCode, ''));
// //                   }
// //                 },
// //                 items: Language.languageList()
// //                     .map<DropdownMenuItem<Language>>(
// //                       (e) => DropdownMenuItem<Language>(
// //                         value: e,
// //                         child: Row(
// //                           mainAxisAlignment: MainAxisAlignment.spaceAround,
// //                           children: <Widget>[
// //                             Text(
// //                               e.flag,
// //                               style: TextStyle(fontSize: 30),
// //                             ),
// //                             Text(e.name),
// //                           ],
// //                         ),
// //                       ),
// //                     )
// //                     .toList(),
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //       body: const Padding(
// //         padding: EdgeInsets.all(16.0),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Text(
// //               'Language',
// //               style: TextStyle(
// //                 fontSize: 18,
// //                 fontWeight: FontWeight.bold,
// //               ),
// //             ),
// //             SizedBox(height: 8),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// import '../components/language.dart';
// import '../main.dart';

// class SettingsScreen extends StatefulWidget {
//   @override
//   _SettingsScreenState createState() => _SettingsScreenState();
// }

// class _SettingsScreenState extends State<SettingsScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(AppLocalizations.of(context)!.settings),
//         actions: <Widget>[
//           Container(
//             child: Padding(
//               padding: EdgeInsets.all(10.0),
//               child: DropdownButton<Language>(
//                 underline: SizedBox(),
//                 icon: Icon(
//                   Icons.language,
//                   color: Colors.black,
//                 ),
//                 onChanged: (Language? language) {
//                   if (language != null) {
//                     MyApp.setLocale(context, Locale(language.languageCode, ''));
//                   }
//                 },
//                 items: Language.languageList()
//                     .map<DropdownMenuItem<Language>>(
//                       (e) => DropdownMenuItem<Language>(
//                         value: e,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                           children: <Widget>[
//                             Text(
//                               e.flag,
//                               style: TextStyle(fontSize: 30),
//                             ),
//                             Text(e.name),
//                           ],
//                         ),
//                       ),
//                     )
//                     .toList(),
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [],
//         ),
//       ),
//     );
//   }
// }

class Settings {
  bool isAudioEnabled;
  bool isVisualEnabled;
  bool isNotificationsEnabled;
  bool isDarkModeEnabled;
  bool isPresidentEnabled;
  bool isDisablePeopleEnabled;

  Settings({
    required this.isAudioEnabled,
    required this.isVisualEnabled,
    required this.isNotificationsEnabled,
    required this.isDarkModeEnabled,
    required this.isPresidentEnabled,
    required this.isDisablePeopleEnabled,
  });
}

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Settings settings = Settings(
    isAudioEnabled: false,
    isVisualEnabled: false,
    isNotificationsEnabled: false,
    isDarkModeEnabled: false,
    isPresidentEnabled: false,
    isDisablePeopleEnabled: false,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings),
        actions: <Widget>[
          Container(
            child: Padding(
              padding: EdgeInsets.all(10.0),
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
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            _buildSectionTitle('Messages from Smartphones'),
            _buildSwitchListTile('Audio', settings.isAudioEnabled, (value) {
              setState(() {
                settings.isAudioEnabled = value;
              });
            }),
            _buildSwitchListTile('Visual', settings.isVisualEnabled, (value) {
              setState(() {
                settings.isVisualEnabled = value;
              });
            }),
            _buildSectionTitle('Command to Smartphone'),
            _buildSwitchListTile(
              'Notifications',
              settings.isNotificationsEnabled,
              (value) {
                setState(() {
                  settings.isNotificationsEnabled = value;
                });
              },
            ),
            _buildSwitchListTile(
              'Dark Mode',
              settings.isDarkModeEnabled,
              (value) {
                setState(() {
                  settings.isDarkModeEnabled = value;
                });
              },
            ),
            _buildSectionTitle('Priority'),
            _buildSwitchListTile(
              'President',
              settings.isPresidentEnabled,
              (value) {
                setState(() {
                  settings.isPresidentEnabled = value;
                });
              },
            ),
            _buildSwitchListTile(
              'Disable People',
              settings.isDisablePeopleEnabled,
              (value) {
                setState(() {
                  settings.isDisablePeopleEnabled = value;
                });
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Save settings to the database or perform any other action
          // Here, you can navigate back or display a success message
        },
        child: Icon(Icons.save),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Column(
      children: [
        ListTile(
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 18,
            ),
          ),
        ),
        Divider(),
      ],
    );
  }

  Widget _buildSwitchListTile(
      String title, bool value, Function(bool) onChanged) {
    return ListTile(
      title: Text(title),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
