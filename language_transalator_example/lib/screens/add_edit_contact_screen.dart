import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:language_transalator_example/components/emergency_contact.dart';
import 'package:language_transalator_example/components/storage_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddEditContactScreen extends StatefulWidget {
  final EmergencyContact? contact;

  AddEditContactScreen({this.contact});

  @override
  _AddEditContactScreenState createState() => _AddEditContactScreenState();
}

class _AddEditContactScreenState extends State<AddEditContactScreen> {
  final StorageService storageService = StorageService();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    if (widget.contact != null) {
      nameController.text = widget.contact!.name;
      phoneNumberController.text = widget.contact!.phoneNumber;
      isEditing = true;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  bool validateName(String value) {
    if (value.isEmpty) {
      return false;
    }
    // Add additional validation rules if needed
    return true;
  }

  bool validatePhoneNumber(String value) {
    if (value.isEmpty) {
      return false;
    }
    // Add additional validation rules if needed
    return true;
  }

  void saveContact() {
    String name = nameController.text;
    String phoneNumber = phoneNumberController.text;

    if (validateName(name) && validatePhoneNumber(phoneNumber)) {
      EmergencyContact contact =
          EmergencyContact(name: name, phoneNumber: phoneNumber);

      if (isEditing) {
        contact.id = widget.contact!.id;
        storageService.updateEmergencyContact(contact);
      } else {
        storageService.addEmergencyContact(contact);
      }

      Navigator.pop(context);
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Validation Error'),
          content: Text('Please enter valid name and phone number.'),
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
        title: Text(isEditing ? 'Edit Contact' : 'Add Contact'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Name',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: phoneNumberController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
              ),
              keyboardType: TextInputType.phone,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: saveContact,
              child: Text(isEditing ? 'Save Changes' : 'Add Contact'),
            ),
          ],
        ),
      ),
    );
  }
}
