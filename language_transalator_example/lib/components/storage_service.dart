import 'package:localstorage/localstorage.dart';
import 'package:language_transalator_example/components/emergency_contact.dart';

class StorageService {
  final LocalStorage storage = new LocalStorage('emergency_contacts');

  Future<List<EmergencyContact>> getEmergencyContacts() async {
    await storage.ready;
    List<EmergencyContact> contacts = [];

    storage.getItem('contacts')?.forEach((contactMap) {
      contacts.add(EmergencyContact.fromMap(Map<String, dynamic>.from(contactMap)));
    });

    return contacts;
  }

  Future<void> addEmergencyContact(EmergencyContact contact) async {
    await storage.ready;
    List<EmergencyContact> contacts = await getEmergencyContacts();
    contacts.add(contact);

    storage.setItem('contacts', contacts.map((c) => c.toMap()).toList());
  }

  Future<void> updateEmergencyContact(EmergencyContact contact) async {
    await storage.ready;
    List<EmergencyContact> contacts = await getEmergencyContacts();
    int contactIndex = contacts.indexWhere((c) => c.id == contact.id);

    if (contactIndex >= 0) {
      contacts[contactIndex] = contact;
      storage.setItem('contacts', contacts.map((c) => c.toMap()).toList());
    }
  }

  Future<void> deleteEmergencyContact(String id) async {
    await storage.ready;
    List<EmergencyContact> contacts = await getEmergencyContacts();
    contacts.removeWhere((contact) => contact.id == id);

    storage.setItem('contacts', contacts.map((c) => c.toMap()).toList());
  }
}
