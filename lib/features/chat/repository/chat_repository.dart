import 'package:chatwith/features/auth/models/user_model.dart';
import 'package:chatwith/features/chat/models/contact_chat.dart';
import 'package:chatwith/features/chat/models/message.dart';
import 'package:chatwith/utils/enums.dart';
import 'package:chatwith/utils/widgets/toast_messages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final chatRepositoryProvider = Provider((ref) {
  return ChatRepository(
    firebaseFirestore: FirebaseFirestore.instance,
    firebaseAuth: FirebaseAuth.instance,
  );
});

class ChatRepository {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;

  ChatRepository({required this.firebaseFirestore, required this.firebaseAuth});

  void _saveDataToContactCollection({
    required UserModel senderUserModel,
    required UserModel receiverUserModel,
    required String message,
    required DateTime timeSent,
  }) async {
    // saving recent message in reciever chat collection
    var receiverContactChat = ContactChat(
      name: senderUserModel.name,
      profilePic: senderUserModel.profilePic,
      contactId: senderUserModel.uid,
      timeSent: timeSent,
      recentMessage: message,
    );

    await firebaseFirestore
        .collection('users')
        .doc(receiverUserModel.uid)
        .collection('chats')
        .doc(senderUserModel.uid)
        .set(receiverContactChat.toJson());

    // saving recent message in sender chat collection
    var senderContactChat = ContactChat(
      name: receiverUserModel.name,
      profilePic: receiverUserModel.profilePic,
      contactId: receiverUserModel.uid,
      timeSent: timeSent,
      recentMessage: message,
    );

    await firebaseFirestore
        .collection('users')
        .doc(senderUserModel.uid)
        .collection('chats')
        .doc(receiverUserModel.uid)
        .set(senderContactChat.toJson());
  }

  void _saveMessageToMessageCollection({
    required String message,
    required String receiverId,
    required DateTime timeSent,
    required String messageId,
    required String senderUsername,
    required String receiverUsername,
    required MessageTypes messageType,
  }) async {
    final messageMap = Message(
      senderId: firebaseAuth.currentUser!.uid,
      receiverId: receiverId,
      message: message,
      timeSent: timeSent,
      messageId: messageId,
      isRead: false,
      messageType: messageType,
    );

    await firebaseFirestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .doc(messageId)
        .set(
          messageMap.toJson(),
        );

    await firebaseFirestore
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('messages')
        .doc(messageId)
        .set(messageMap.toJson());
  }

  void sendTextMessage({
    required BuildContext context,
    required String message,
    required String receiverId,
    required UserModel senderUserModel,
  }) async {
    try {
      var timeSent = DateTime.now();
      UserModel receiverUserModel = await firebaseFirestore
          .collection('users')
          .doc(receiverId)
          .get()
          .then((value) => UserModel.fromJson(value.data()!));

      var messageId = const Uuid().v1();

      _saveDataToContactCollection(
          message: message,
          receiverUserModel: receiverUserModel,
          senderUserModel: senderUserModel,
          timeSent: timeSent);

      _saveMessageToMessageCollection(
        message: message,
        receiverId: receiverId,
        timeSent: timeSent,
        messageId: messageId,
        senderUsername: senderUserModel.name,
        receiverUsername: receiverUserModel.name,
        messageType: MessageTypes.text,
      );
    } catch (e) {
      showToast(context: context, message: e.toString());
      debugPrint(e.toString());
    }
  }

  Stream<List<ContactChat>> getContactChats({required BuildContext context}) {
    try {
      return firebaseFirestore
          .collection('users')
          .doc(firebaseAuth.currentUser!.uid)
          .collection('chats')
          .snapshots()
          .asyncMap((event) async {
        List<ContactChat> contactChats = [];

        for (var doc in event.docs) {
          try {
            var contactChat = ContactChat.fromJson(doc.data());
            contactChats.add(contactChat);
          } catch (e) {
            debugPrint(e.toString());
          }
        }
        return contactChats;
      });
    } catch (e) {
      showToast(context: context, message: e.toString());
      debugPrint(e.toString());
      rethrow;
    }
  }

  Stream<List<Message>> getUserChats({required String receiverUserId}) {
    try {
      return firebaseFirestore
          .collection('users')
          .doc(firebaseAuth.currentUser!.uid)
          .collection('chats')
          .doc(receiverUserId)
          .collection('messages')
          .orderBy(
            'timeSent',
          )
          .snapshots()
          .asyncMap((event) async {
        List<Message> messages = [];

        for (var doc in event.docs) {
          try {
            var message = Message.fromJson(doc.data());
            messages.add(message);
          } catch (e) {
            debugPrint(e.toString());
          }
        }
        return messages;
      });
    } catch (e) {
      // showToast(context: context, message: e.toString());
      debugPrint(e.toString());
      rethrow;
    }
  }

  void sendFileMessage(){
    
  }
}
