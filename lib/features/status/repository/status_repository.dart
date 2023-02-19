import 'dart:io';

import 'package:chatwith/features/auth/models/user_model.dart';
import 'package:chatwith/features/status/models/status_model.dart';
import 'package:chatwith/firebase/repository/firebase_storage.dart';
import 'package:chatwith/utils/widgets/toast_messages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final statusRepositoryProvider = Provider<StatusRepository>((ref) {
  final firebaseAuth = FirebaseAuth.instance;
  final firebaseFirestore = FirebaseFirestore.instance;
  return StatusRepository(
    firebaseAuth: firebaseAuth,
    firebaseFirestore: firebaseFirestore,
    ref: ref,
  );
});

class StatusRepository {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;
  final ProviderRef ref;

  StatusRepository({
    required this.firebaseAuth,
    required this.firebaseFirestore,
    required this.ref,
  });

  Future<void> updateStatus({
    required BuildContext context,
    required String profilePic,
    required String mobileNumber,
    required File imageFile,
    required String username,
  }) async {
    try {
      final statusId = const Uuid().v1();
      final userId = firebaseAuth.currentUser!.uid;
      final imageUrl = await ref
          .read(firebaseStorageRepositoryProvider)
          .storeFIleToFirebaseStorage(
              file: imageFile,
              refPath: '/status/$statusId$userId',
              context: context);
      List<Contact> contacts = [];
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
      List<String> contactUids = [];

      for (int i = 0; i < contacts.length; i++) {
        var contact = contacts[i];
        var userCollection = await firebaseFirestore
            .collection('users')
            .where('mobileNumber',
                isEqualTo: contact.phones.first.number.replaceAll(' ', ''))
            .get(); // get mobile number only not workplace or other number

        if (userCollection.docs.isNotEmpty) {
          contactUids.add(userCollection.docs.first.id);
        }
      }

      List<String> statusUrl = [];
      var statusCollection = await firebaseFirestore
          .collection('status')
          .where('uid', isEqualTo: userId)
          .where('createdAt',
              isGreaterThan: DateTime.now().subtract(const Duration(hours: 24)))
          .get();

      if (statusCollection.docs.isNotEmpty) {
        Status status = Status.fromJson(statusCollection.docs.first.data());
        statusUrl = status.imageUrls; // image urls is array
        statusUrl.add(imageUrl);
        await firebaseFirestore
            .collection('status')
            .doc(statusCollection.docs.first.id)
            .update({
          'imageUrls': statusUrl,
        });
      } else {
        statusUrl.add(imageUrl);
        Status status = Status(
            uid: userId,
            inContactUser: contactUids,
            imageUrls: statusUrl,
            profilePic: profilePic,
            mobileNumber: mobileNumber,
            statusId: statusId,
            createdAt: DateTime.now(),
            username: username);

        await firebaseFirestore
            .collection('status')
            .doc(statusId)
            .set(status.toJson());
      }
    } catch (e) {
      showToast(context: context, message: e.toString());
      debugPrint(e.toString());
    }
  }

  Future<List<Status>> getAllStatus(BuildContext context) async {
    try {
      List<Status> statusList = [];

      List<Contact> contacts = [];
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }

      for (int i = 0; i < contacts.length; i++) {
        var contact = contacts[i];
        debugPrint(contact.phones.first.number.replaceAll(' ', '').toString());
        var statusCollection = await firebaseFirestore
            .collection('status')
            .where('mobileNumber',
                isEqualTo: contact.phones.first.number.replaceAll(' ', ''))
            .where(
              'createdAt',
              isGreaterThan: DateTime.now().subtract(
                const Duration(hours: 24),
              ),
            )
            .get(); //

        for (var status in statusCollection.docs) {
          Status statusModel = Status.fromJson(status.data());

          if (statusModel.inContactUser
              .contains(firebaseAuth.currentUser!.uid)) {
            statusList.add(statusModel);
          }
        }
      }
      return statusList;
    } catch (e) {
      showToast(context: context, message: e.toString());
      debugPrint(e.toString());
      rethrow;
    }
  }
}

// "The query requires an index. You can create it here: https://console.firebase.google.com/v1/r/project/chatwith-23601/firestore/i…"
// The query requires an index. That index is currently building and cannot be used yet. See its status here: https://console.firebase.google.com/v1/r/project/chatwith-23601/firestore/indexes?create_composite=Clhwcm9qZWN0cy9jaGF0d2l0aC0yMzYwMS9kYXRhYmFzZXMvKGRlZmF1bHQpL2NvbGxlY3Rpb25Hcm91cHMvc3RhdHVzL2luZGV4ZXMvQ0lDQWdPalhoNEVLEAEaBwoDdWlkEAEaDQoJY3JlYXRlZEF0EAEaDAoIX19uYW1lX18QAQ
