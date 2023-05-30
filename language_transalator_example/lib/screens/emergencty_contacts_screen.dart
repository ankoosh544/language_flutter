import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:language_transalator_example/components/emergency_contact.dart';
import 'package:language_transalator_example/components/storage_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'add_edit_contact_screen.dart';

class EmergencyContactsScreen extends StatefulWidget {
  @override
  _EmergencyContactsScreenState createState() =>
      _EmergencyContactsScreenState();
}

class _EmergencyContactsScreenState extends State<EmergencyContactsScreen> {
  final StorageService storageService = StorageService();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  List<EmergencyContact> emergencyContacts = [];

  @override
  void initState() {
    super.initState();
    loadEmergencyContacts();
  }

  Future<void> loadEmergencyContacts() async {
    List<EmergencyContact> contacts =
        await storageService.getEmergencyContacts();
    setState(() {
      emergencyContacts = contacts;
    });
  }

  Future<void> addEmergencyContact() async {
    String name = nameController.text;
    String phoneNumber = phoneNumberController.text;
    EmergencyContact contact =
        EmergencyContact(name: name, phoneNumber: phoneNumber);

    await storageService.addEmergencyContact(contact);
    clearTextFields();
    loadEmergencyContacts();
  }

  Future<void> updateEmergencyContact(EmergencyContact contact) async {
    await storageService.updateEmergencyContact(contact);
    loadEmergencyContacts();
  }

  Future<void> deleteEmergencyContact(String id) async {
    await storageService.deleteEmergencyContact(id);
    loadEmergencyContacts();
  }

  void clearTextFields() {
    nameController.clear();
    phoneNumberController.clear();
  }

  void showAddDialog() {
    navigateToAddEditContactScreen();
  }

  Future<void> showEditDialog(EmergencyContact contact) async {
    navigateToAddEditContactScreen(contact: contact);
  }

  Future<void> navigateToAddEditContactScreen({EmergencyContact? contact}) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditContactScreen(contact: contact),
      ),
    ).then((_) {
      loadEmergencyContacts();
    });
  }

  Future<void> _deleteEmergencyContact(EmergencyContact contact) async {
    await deleteEmergencyContact(contact.id);
  }

  Future<void> _tapCallEmergencyContact(String phoneNumber) async {
    final uri = 'tel:$phoneNumber';
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to launch the phone app.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _callEmergencyContact(EmergencyContact contact) async {
    final phoneNumber = 'tel:${contact.phoneNumber}';
    if (await canLaunch(phoneNumber)) {
      await launch(phoneNumber);
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(AppLocalizations.of(context)!.error),
          content: Text('Failed to launch the phone app.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.emergencycontacts),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: emergencyContacts.length,
              itemBuilder: (context, index) {
                final contact = emergencyContacts[index];
                return Card(
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.white,
                    ),
                    title: Text(contact.name),
                    subtitle: Text(contact.phoneNumber),
                    onTap: () {
                      _tapCallEmergencyContact(contact.phoneNumber);
                    },
                    trailing: PopupMenuButton(
                      icon: Icon(Icons.more_vert),
                      itemBuilder: (BuildContext context) {
                        return [
                          PopupMenuItem(
                            child: ListTile(
                              leading: Icon(Icons.edit),
                              title: Text(AppLocalizations.of(context)!.edit),
                              onTap: () {
                                showEditDialog(contact);
                              },
                            ),
                          ),
                          PopupMenuItem(
                            child: ListTile(
                              leading: Icon(Icons.delete),
                              title: Text(AppLocalizations.of(context)!.delete),
                              onTap: () {
                                _deleteEmergencyContact(contact);
                              },
                            ),
                          ),
                        ];
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Container(
              width: double.infinity,
              height: 50, // Make the container full width
              child: ElevatedButton(
                onPressed: () {
                  showAddDialog();
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.green, // Set the desired background color
                ),
                child: Text(
                  AppLocalizations.of(context)!.add,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
