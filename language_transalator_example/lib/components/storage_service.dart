// import 'package:localstorage/localstorage.dart';
// import 'package:language_transalator_example/components/emergency_contact.dart';

// class StorageService {
//   final LocalStorage storage = new LocalStorage('emergency_contacts');

//   Future<List<EmergencyContact>> getEmergencyContacts() async {
//     await storage.ready;
//     List<EmergencyContact> contacts = [];

//     storage.getItem('contacts')?.forEach((contactMap) {
//       contacts
//           .add(EmergencyContact.fromMap(Map<String, dynamic>.from(contactMap)));
//     });

//     return contacts;
//   }

//   Future<void> addEmergencyContact(EmergencyContact contact) async {
//     await storage.ready;
//     List<EmergencyContact> contacts = await getEmergencyContacts();
//     contacts.add(contact);

//     storage.setItem('contacts', contacts.map((c) => c.toMap()).toList());
//   }

//   Future<void> updateEmergencyContact(EmergencyContact contact) async {
//     await storage.ready;
//     List<EmergencyContact> contacts = await getEmergencyContacts();
//     int contactIndex = contacts.indexWhere((c) => c.id == contact.id);

//     if (contactIndex >= 0) {
//       contacts[contactIndex] = contact;
//       storage.setItem('contacts', contacts.map((c) => c.toMap()).toList());
//     }
//   }

//   Future<void> deleteEmergencyContact(String id) async {
//     await storage.ready;
//     List<EmergencyContact> contacts = await getEmergencyContacts();
//     contacts.removeWhere((contact) => contact.id == id);

//     storage.setItem('contacts', contacts.map((c) => c.toMap()).toList());
//   }
// }

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:language_transalator_example/components/emergency_contact.dart';

class StorageService {
  Future<List<EmergencyContact>> getEmergencyContacts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? contactsJson = prefs.getStringList('emergency_contacts');

    List<EmergencyContact> contacts = [];

    if (contactsJson != null) {
      contacts = contactsJson
          .map((json) => EmergencyContact.fromMap(jsonDecode(json)))
          .toList();
    }

    return contacts;
  }

  Future<void> addEmergencyContact(EmergencyContact contact) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<EmergencyContact> contacts = await getEmergencyContacts();
    contacts.add(contact);

    List<String> contactsJson =
        contacts.map((c) => jsonEncode(c.toMap())).toList();

    await prefs.setStringList('emergency_contacts', contactsJson);
  }

  Future<void> updateEmergencyContact(EmergencyContact contact) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<EmergencyContact> contacts = await getEmergencyContacts();
    int contactIndex = contacts.indexWhere((c) => c.id == contact.id);

    if (contactIndex >= 0) {
      contacts[contactIndex] = contact;
      List<String> contactsJson =
          contacts.map((c) => jsonEncode(c.toMap())).toList();

      await prefs.setStringList('emergency_contacts', contactsJson);
    }
  }

  Future<void> deleteEmergencyContact(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<EmergencyContact> contacts = await getEmergencyContacts();
    contacts.removeWhere((contact) => contact.id == id);

    List<String> contactsJson =
        contacts.map((c) => jsonEncode(c.toMap())).toList();

    await prefs.setStringList('emergency_contacts', contactsJson);
  }
}
