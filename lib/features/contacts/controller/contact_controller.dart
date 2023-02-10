import 'package:chatwith/features/contacts/repository/contact_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getContactProvider = FutureProvider((ref) {
  final contactRepository = ref.watch(contactRepositoryProvider);
  return contactRepository.getContacts();
});

final contactControllerProvider = Provider((ref) {
  final contactRepository = ref.watch(contactRepositoryProvider);
  return ContactController(ref: ref, contactRepository: contactRepository);
});

class ContactController {
  final ProviderRef ref;
  final ContactRepository contactRepository;

  ContactController({required this.ref, required this.contactRepository});

  void checkContact({required Contact contact, required BuildContext context}) {
    contactRepository.checkIfContactExist(contact: contact, context: context);
  }
}
