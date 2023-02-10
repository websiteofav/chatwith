import 'package:chatwith/features/auth/models/user_model.dart';
import 'package:chatwith/utils/colors.dart';
import 'package:chatwith/features/chat/screens/mobile_chat_screen.dart';
import 'package:chatwith/utils/widgets/toast_messages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final contactRepositoryProvider = Provider((ref) {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  return ContactRepository(firebaseFirestore: firebaseFirestore, mounted: true);
});

class ContactRepository {
  final FirebaseFirestore firebaseFirestore;
  final bool mounted;

  ContactRepository({required this.firebaseFirestore, required this.mounted});

  Future<List<Contact>> getContacts() async {
    List<Contact> contacts = [];
    try {
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return contacts;
  }

  void checkIfContactExist(
      {required Contact contact, required BuildContext context}) async {
    try {
      var userCollection =
          await FirebaseFirestore.instance.collection('/users').get();
      bool isFound = false;

      for (var user in userCollection.docs) {
        var userModel = UserModel.fromJson(user.data());

        String mobileNumber = contact.phones.first.number.replaceAll(' ', '');
        if (userModel.mobileNumber == mobileNumber) {
          isFound = true;
          if (mounted) {
            Navigator.of(context)
                .pushNamed(MobileChatScreen.routeName, arguments: userModel);
          }
        }
      }

      if (!isFound) {
        showToast(
            context: context,
            message: 'Contact not registered on App',
            toastColor: cD43F25_1);
      }
    } catch (e) {
      showToast(
        context: context,
        message: e.toString(),
      );
      debugPrint(e.toString());
    }
  }
}
