import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../components/language.dart';
import '../main.dart';
import '../utils/session_manager.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool isAudioEnabled = false;
  late bool isVisualEnabled = false;
  late bool isNotificationsEnabled = false;
  late bool isDarkModeEnabled = false;
  late bool isPresidentEnabled = false;
  late bool isDisablePeopleEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settings = await SessionManager.getSettings();
    setState(() {
      isAudioEnabled = settings['isAudioEnabled'] ?? false;
      isVisualEnabled = settings['isVisualEnabled'] ?? false;
      isNotificationsEnabled = settings['isNotificationsEnabled'] ?? false;
      isDarkModeEnabled = settings['isDarkModeEnabled'] ?? false;
      isPresidentEnabled = settings['isPresidentEnabled'] ?? false;
      isDisablePeopleEnabled = settings['isDisablePeopleEnabled'] ?? false;
    });
  }

  Future<void> _saveSettings() async {
    await SessionManager.setSettings(
      isAudioEnabled: isAudioEnabled,
      isVisualEnabled: isVisualEnabled,
      isNotificationsEnabled: isNotificationsEnabled,
      isDarkModeEnabled: isDarkModeEnabled,
      isPresidentEnabled: isPresidentEnabled,
      isDisablePeopleEnabled: isDisablePeopleEnabled,
    );
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
              AppLocalizations.of(context)!.settingsstatement1,
            ),
            _buildSwitchListTile(
              AppLocalizations.of(context)!.settingsstatement1Option1,
              isAudioEnabled,
              (value) {
                setState(() {
                  isAudioEnabled = value;
                });
              },
            ),
            _buildSwitchListTile(
              AppLocalizations.of(context)!.settingsstatement1Option2,
              isVisualEnabled,
              (value) {
                setState(() {
                  isVisualEnabled = value;
                });
              },
            ),
            _buildSectionTitle(
              AppLocalizations.of(context)!.settingsstatement2,
            ),
            _buildSwitchListTile(
              AppLocalizations.of(context)!.settingsstatement2Option1,
              isNotificationsEnabled,
              (value) {
                setState(() {
                  isNotificationsEnabled = value;
                });
              },
            ),
            _buildSwitchListTile(
              AppLocalizations.of(context)!.settingsstatement2Option2,
              isDarkModeEnabled,
              (value) {
                setState(() {
                  isDarkModeEnabled = value;
                });
              },
            ),
            _buildSectionTitle(
              AppLocalizations.of(context)!.settingsstatement3,
            ),
            _buildSwitchListTile(
              AppLocalizations.of(context)!.settingsstatement3Option1,
              isPresidentEnabled,
              (value) {
                setState(() {
                  isPresidentEnabled = value;
                });
              },
            ),
            _buildSwitchListTile(
              AppLocalizations.of(context)!.settingsstatement3Option2,
              isDisablePeopleEnabled,
              (value) {
                setState(() {
                  isDisablePeopleEnabled = value;
                });
              },
            ),
          ],
        ),
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
  String title,
  bool value,
  Function(bool) onChanged,
) {
  return ListTile(
    title: Text(title),
    trailing: Switch(
      value: value,
      onChanged: (newValue) {
        onChanged(newValue);
        _saveSettings(); // Save settings immediately when switch is toggled
      },
    ),
  );
}

}
