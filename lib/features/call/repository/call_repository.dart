import 'dart:io';

import 'package:chatwith/features/call/models/call.dart';
import 'package:chatwith/features/call/screens/call.dart';
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

final callRepositoryProvider = Provider<CallRepository>((ref) {
  final firebaseAuth = FirebaseAuth.instance;
  final firebaseFirestore = FirebaseFirestore.instance;
  return CallRepository(
    firebaseAuth: firebaseAuth,
    firebaseFirestore: firebaseFirestore,
  );
});

class CallRepository {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;
  CallRepository({
    required this.firebaseFirestore,
    required this.firebaseAuth,
  });

  Future<void> makeACall({
    required BuildContext context,
    required Call senderCallData,
    required Call receiverCallData,
  }) async {
    try {
      await firebaseFirestore
          .collection('calls')
          .doc(senderCallData.callerId)
          .set(senderCallData.toJson());

      await firebaseFirestore
          .collection('calls')
          .doc(senderCallData.receiverId)
          .set(receiverCallData.toJson());

      Navigator.of(context).pushNamed(CallScreen.routeName, arguments: {
        'channelId': senderCallData.callId,
        'call': senderCallData,
        'isGroupChat': false,
      });
    } catch (e) {
      showToast(context: context, message: e.toString());
      debugPrint(e.toString());
    }
  }

  Stream<DocumentSnapshot> get getCallStreamData => firebaseFirestore
      .collection('calls')
      .doc(firebaseAuth.currentUser!.uid)
      .snapshots(); // No parameter is required because we are getting the data of the current user so a getter can be used
}
