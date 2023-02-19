import 'package:chatwith/features/auth/controller/auth_controller.dart';
import 'package:chatwith/features/call/models/call.dart';
import 'package:chatwith/features/call/repository/call_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final callControllerProvider = Provider<CallController>((ref) {
  return CallController(
    callRepository: ref.read(callRepositoryProvider),
    ref: ref,
  );
});

class CallController {
  final CallRepository callRepository;

  final ProviderRef ref;

  CallController({required this.callRepository, required this.ref});

  void makeACall(
      {required BuildContext context,
      required String recieverUserName,
      required String recieverUserId,
      required String recieverUserPic,
      required bool isGroupChat}) async {
    ref.read(userDataAuthProvider).whenData((value) {
      String callId = const Uuid().v1();
      Call senderCallData = Call(
          callerId: value!.uid,
          callerName: value.name,
          callerPic: value.profilePic,
          receiverId: recieverUserId,
          receiverName: recieverUserName,
          receiverPic: recieverUserPic,
          hasDialled: true,
          callId: callId);

      Call recieverCallData = Call(
          callerId: value.uid,
          callerName: value.name,
          callerPic: value.profilePic,
          receiverId: recieverUserId,
          receiverName: recieverUserName,
          receiverPic: recieverUserPic,
          hasDialled: false,
          callId: callId);

      callRepository.makeACall(
        context: context,
        senderCallData: senderCallData,
        receiverCallData: recieverCallData,
      );
    });
  }

  Stream<DocumentSnapshot> get getCallStreamData => callRepository
      .getCallStreamData; // No parameter is required because we are getting the data of the current user so a getter can be used
}
