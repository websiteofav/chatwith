import 'dart:io';

import 'package:chatwith/features/group/models/group.dart';
import 'package:chatwith/firebase/repository/firebase_storage.dart';
import 'package:chatwith/utils/widgets/toast_messages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final groupRepositoryProvider = Provider<GroupRepository>((ref) {
  final firebaseAuth = FirebaseAuth.instance;
  final firebaseFirestore = FirebaseFirestore.instance;
  return GroupRepository(
    firebaseAuth: firebaseAuth,
    firebaseFirestore: firebaseFirestore,
    ref: ref,
  );
});

class GroupRepository {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;
  final ProviderRef ref;
  GroupRepository(
      {required this.firebaseFirestore,
      required this.firebaseAuth,
      required this.ref});

  Future<void> createGroup(
      {required BuildContext context,
      required String groupName,
      required File groupPic,
      required List<Contact> selectedContacts}) async {
    try {
      List<String> uuids = [];
      for (int i = 0; i < selectedContacts.length; i++) {
        var userCollection = await firebaseFirestore
            .collection('users')
            .where('mobileNumber',
                isEqualTo:
                    selectedContacts[i].phones.first.number.replaceAll(' ', ''))
            .get();

        if (userCollection.docs.isNotEmpty) {
          uuids.add(userCollection.docs.first.id);
        }
      }

      var groupId = const Uuid().v1();

      String groupPicUrl = await ref
          .read(firebaseStorageRepositoryProvider)
          .storeFIleToFirebaseStorage(
              file: groupPic, refPath: '/group/$groupId', context: context);

      GroupModel group = GroupModel(
        lastUserUid: firebaseAuth.currentUser!.uid,
        groupUid: groupId,
        name: groupName,
        groupProfilePic: groupPicUrl,
        membersUid: [firebaseAuth.currentUser!.uid, ...uuids],
        lastMessage: '',
        lastMessageTime: DateTime.now(),
      );

      await firebaseFirestore
          .collection('groups')
          .doc(groupId)
          .set(group.toJson());
    } catch (e) {
      showToast(context: context, message: e.toString());
      debugPrint(e.toString());
    }
  }
}
