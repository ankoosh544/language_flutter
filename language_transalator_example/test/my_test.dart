import 'package:flutter/material.dart';
import 'package:language_transalator_example/components/emergency_contact.dart';
import 'package:language_transalator_example/components/storage_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/services.dart';

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
    String name = nameController.text.trim();
    String phoneNumber = phoneNumberController.text.trim();

    if (name.isEmpty || phoneNumber.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Name and phone number are required.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
      return;
    }

    if (!isItalianPhoneNumber(phoneNumber)) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Please enter a valid Italian phone number.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
      return;
    }

    EmergencyContact contact =
        EmergencyContact(name: name, phoneNumber: phoneNumber);

    await storageService.addEmergencyContact(contact);
    clearTextFields();
    loadEmergencyContacts();
  }

  bool isItalianPhoneNumber(String phoneNumber) {
    // Add your validation logic to check if the phone number is an Italian number
    // For example, you can use a regular expression to validate the format
    // or use a library like 'phone_numbers' to validate the number.
    // Here's an example using a regular expression to check the format:
    RegExp regex = RegExp(r'^\d{8,10}$');
    return regex.hasMatch(phoneNumber);
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
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.addemergencycontactTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.name,
                ),
              ),
              TextField(
                controller: phoneNumberController,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.phone,
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text(AppLocalizations.of(context)!.cancel),
              onPressed: () {
                clearTextFields();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(AppLocalizations.of(context)!.add),
              onPressed: () {
                addEmergencyContact();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> showEditDialog(EmergencyContact contact) async {
    nameController.text = contact.name;
    phoneNumberController.text = contact.phoneNumber;

    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.editemergencycontactTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.name,
                ),
              ),
              TextField(
                controller: phoneNumberController,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.phone,
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text(AppLocalizations.of(context)!.cancel),
              onPressed: () {
                clearTextFields();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(AppLocalizations.of(context)!.update),
              onPressed: () {
                EmergencyContact updatedContact = EmergencyContact(
                  id: contact.id,
                  name: nameController.text,
                  phoneNumber: phoneNumberController.text,
                );

                updateEmergencyContact(updatedContact);
                clearTextFields();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showEditContactDialog(EmergencyContact contact) async {
    await showEditDialog(contact);
  }

  Future<void> _deleteEmergencyContact(EmergencyContact contact) async {
    await deleteEmergencyContact(contact.id);
  }

  Future<void> _addEmergencyContact(EmergencyContact contact) async {
    await addEmergencyContact();
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
      body: ListView.builder(
        itemCount: emergencyContacts.length,
        itemBuilder: (context, index) {
          final contact = emergencyContacts[index];
          return ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.white,
            ),
            tileColor: index % 2 == 0
                ? Color.fromARGB(255, 196, 190, 190)
                : Color.fromARGB(255, 234, 206, 206),
            title: Text(contact.name),
            subtitle: Text(contact.phoneNumber),
            onTap: () {
              _tapCallEmergencyContact(contact.phoneNumber);
            },
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.call),
                  onPressed: () {
                    _callEmergencyContact(contact);
                  },
                ),
                PopupMenuButton<String>(
                  itemBuilder: (BuildContext context) {
                    return const [
                      PopupMenuItem<String>(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit),
                            SizedBox(width: 8),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete),
                            SizedBox(width: 8),
                            Text('Delete'),
                          ],
                        ),
                      ),
                    ];
                  },
                  onSelected: (String value) {
                    if (value == 'edit') {
                      _showEditContactDialog(contact);
                    } else if (value == 'delete') {
                      _deleteEmergencyContact(contact);
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showAddDialog();
        },
      ),
    );
  }
}
