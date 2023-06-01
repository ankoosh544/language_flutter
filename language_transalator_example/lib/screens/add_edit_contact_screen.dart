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
  final TextEditingController prefixController = TextEditingController(text: "+39");
  final TextEditingController phoneNumberController = TextEditingController();

  List<String> countryCodes = ["+39", "+91"]; // List of country codes
  String selectedCountryCode = "+39"; // Default selected country code

  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    if (widget.contact != null) {
      nameController.text = widget.contact!.name;
      prefixController.text = "+39";
      phoneNumberController.text = widget.contact!.phoneNumber.substring(3); // Remove the "+39" prefix when editing
      isEditing = true;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    prefixController.dispose();
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
    if (value.isEmpty || value.length != 13) {
      return false;
    }
    // Add additional validation rules if needed
    return true;
  }

  void saveContact() {
    String name = nameController.text;
    String phoneNumber = prefixController.text + phoneNumberController.text;

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
          content: Text('Please enter a valid name and a 10-digit phone number.'),
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
            Row(
              children: [
                Container(
                  width: 100.0,
                  child: Padding(
                    padding: const EdgeInsets.only(left:8,top: 15),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: DropdownButton<String>(
                        value: selectedCountryCode,
                        onChanged: (newValue) {
                          setState(() {
                            selectedCountryCode = newValue!;
                            prefixController.text = selectedCountryCode;
                          });
                        },
                        items: countryCodes.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: phoneNumberController,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                    ),
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(13), // Limit the input to 10 digits
                    ],
                  ),
                ),
              ],
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
