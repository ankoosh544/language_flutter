import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/language.dart';
import '../main.dart';

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
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      settings.isAudioEnabled = _prefs.getBool('isAudioEnabled') ?? false;
      settings.isVisualEnabled = _prefs.getBool('isVisualEnabled') ?? false;
      settings.isNotificationsEnabled =
          _prefs.getBool('isNotificationsEnabled') ?? false;
      settings.isDarkModeEnabled = _prefs.getBool('isDarkModeEnabled') ?? false;
      settings.isPresidentEnabled =
          _prefs.getBool('isPresidentEnabled') ?? false;
      settings.isDisablePeopleEnabled =
          _prefs.getBool('isDisablePeopleEnabled') ?? false;
    });
  }

  Future<void> _saveSettings() async {
    await _prefs.setBool('isAudioEnabled', settings.isAudioEnabled);
    await _prefs.setBool('isVisualEnabled', settings.isVisualEnabled);
    await _prefs.setBool(
        'isNotificationsEnabled', settings.isNotificationsEnabled);
    await _prefs.setBool('isDarkModeEnabled', settings.isDarkModeEnabled);
    await _prefs.setBool('isPresidentEnabled', settings.isPresidentEnabled);
    await _prefs.setBool(
        'isDisablePeopleEnabled', settings.isDisablePeopleEnabled);
  }

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
            _buildSectionTitle(
                AppLocalizations.of(context)!.settingsstatement1),
            _buildSwitchListTile(
              AppLocalizations.of(context)!.settingsstatement1Option1,
              settings.isAudioEnabled,
              (value) {
                setState(() {
                  settings.isAudioEnabled = value;
                });
              },
            ),
            _buildSwitchListTile(
              AppLocalizations.of(context)!.settingsstatement1Option2,
              settings.isVisualEnabled,
              (value) {
                setState(() {
                  settings.isVisualEnabled = value;
                });
              },
            ),
            _buildSectionTitle(
                AppLocalizations.of(context)!.settingsstatement2),
            _buildSwitchListTile(
              AppLocalizations.of(context)!.settingsstatement2Option1,
              settings.isNotificationsEnabled,
              (value) {
                setState(() {
                  settings.isNotificationsEnabled = value;
                });
              },
            ),
            _buildSwitchListTile(
              AppLocalizations.of(context)!.settingsstatement2Option2,
              settings.isDarkModeEnabled,
              (value) {
                setState(() {
                  settings.isDarkModeEnabled = value;
                });
              },
            ),
            _buildSectionTitle(
                AppLocalizations.of(context)!.settingsstatement3),
            _buildSwitchListTile(
              AppLocalizations.of(context)!.settingsstatement3Option1,
              settings.isPresidentEnabled,
              (value) {
                setState(() {
                  settings.isPresidentEnabled = value;
                });
              },
            ),
            _buildSwitchListTile(
              AppLocalizations.of(context)!.settingsstatement3Option2,
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
        onPressed: () async {
          await _saveSettings();
          // Perform any other necessary actions
          // For example, display a success message or navigate back
          Navigator.pop(context);
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
