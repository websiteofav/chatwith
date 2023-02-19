import 'dart:io';

import 'package:chatwith/features/auth/models/user_model.dart';
import 'package:chatwith/features/chat/models/contact_chat.dart';
import 'package:chatwith/features/chat/models/message.dart';
import 'package:chatwith/features/chat/widgets/reply_message.dart';
import 'package:chatwith/features/group/models/group.dart';
import 'package:chatwith/firebase/repository/firebase_storage.dart';
import 'package:chatwith/utils/enums.dart';
import 'package:chatwith/utils/providers/message_reply.dart';
import 'package:chatwith/utils/widgets/toast_messages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
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
    required UserModel? receiverUserModel,
    required String message,
    required DateTime timeSent,
    required bool isGroupChat,
    required String reciverUserId,
  }) async {
    // saving recent message in reciever chat collection
    var receiverContactChat = ContactChat(
      name: senderUserModel.name,
      profilePic: senderUserModel.profilePic,
      contactId: senderUserModel.uid,
      timeSent: timeSent,
      recentMessage: message,
    );

    if (isGroupChat) {
      await firebaseFirestore.collection('groups').doc(reciverUserId).update({
        'lastMessage': message,
        'lastMessageTime': timeSent,
      });
    } else {
      await firebaseFirestore
          .collection('users')
          .doc(receiverUserModel!.uid)
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
  }

  void _saveMessageToMessageCollection({
    required String message,
    required String receiverId,
    required DateTime timeSent,
    required String messageId,
    required String senderUsername,
    required String? receiverUsername,
    required MessageTypes messageType,
    required MessageReplyProvider? messageReply,
    required MessageTypes messageReplyType,
    required bool isGroupChat,
  }) async {
    final messageMap = Message(
        senderId: firebaseAuth.currentUser!.uid,
        receiverId: receiverId,
        message: message,
        timeSent: timeSent,
        messageId: messageId,
        isRead: false,
        messageType: messageType,
        replyText: messageReply == null ? '' : messageReply.message,
        repliedTo: messageReply == null
            ? ''
            : messageReply.isMe
                ? senderUsername
                : receiverUsername ?? '',
        repliedToMessageType: messageReplyType);

    if (isGroupChat) {
      await firebaseFirestore
          .collection('groups')
          .doc(receiverId)
          .collection('chats')
          .doc(messageId)
          .set(messageMap.toJson());
    } else {
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
  }

  void sendTextMessage({
    required BuildContext context,
    required String message,
    required String receiverId,
    required UserModel senderUserModel,
    required MessageReplyProvider? messageReply,
    required bool isGroupChat,
  }) async {
    try {
      var timeSent = DateTime.now();
      UserModel? receiverUserModel;

      if (!isGroupChat) {
        receiverUserModel = await firebaseFirestore
            .collection('users')
            .doc(receiverId)
            .get()
            .then((value) => UserModel.fromJson(value.data()!));
      }

      var messageId = const Uuid().v1();

      _saveDataToContactCollection(
        message: message,
        receiverUserModel: receiverUserModel,
        senderUserModel: senderUserModel,
        timeSent: timeSent,
        isGroupChat: isGroupChat,
        reciverUserId: receiverId,
      );

      _saveMessageToMessageCollection(
        message: message,
        receiverId: receiverId,
        timeSent: timeSent,
        messageId: messageId,
        senderUsername: senderUserModel.name,
        messageType: MessageTypes.text,
        messageReply: messageReply,
        messageReplyType:
            messageReply == null ? MessageTypes.text : messageReply.messageType,
        isGroupChat: isGroupChat,
        receiverUsername: receiverUserModel?.name,
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

  Stream<List<GroupModel>> getChatsGroups({required BuildContext context}) {
    try {
      return firebaseFirestore
          .collection('groups')
          .snapshots()
          .asyncMap((event) async {
        List<GroupModel> chatGroups = [];

        for (var doc in event.docs) {
          var group = GroupModel.fromJson(doc.data());
          if (group.membersUid.contains(firebaseAuth.currentUser!.uid)) {
            chatGroups.add(group);
          }
        }

        return chatGroups;
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

  Stream<List<Message>> getGroupChats({required String groupId}) {
    try {
      return firebaseFirestore
          .collection('groups')
          .doc(groupId)
          .collection('chats')
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

  void sendFileMessage({
    required BuildContext context,
    required File file,
    required String receiverId,
    required UserModel senderUserModel,
    required ProviderRef ref,
    required MessageTypes messageType,
    required MessageReplyProvider? messageReply,
    required bool isGroupChat,
  }) async {
    try {
      var messageId = const Uuid().v1();
      var timeSent = DateTime.now();

      String fileDownloadUrl = await ref
          .read(firebaseStorageRepositoryProvider)
          .storeFIleToFirebaseStorage(
            file: file,
            context: context,
            refPath:
                '/chat/${messageType.value}/${senderUserModel.uid}/$receiverId/$messageId',
          );

      UserModel? receiverUserModel;
      if (!isGroupChat) {
        receiverUserModel = await firebaseFirestore
            .collection('users')
            .doc(receiverId)
            .get()
            .then((value) => UserModel.fromJson(value.data()!));
      }

      String contactMessage = '';

      switch (messageType) {
        case MessageTypes.image:
          contactMessage = 'Image';
          break;
        case MessageTypes.video:
          contactMessage = 'Video';
          break;
        case MessageTypes.audio:
          contactMessage = 'Audio';
          break;

        case MessageTypes.gif:
          contactMessage = 'GIF';
          break;

        default:
          contactMessage = 'File';
      }

      _saveDataToContactCollection(
        senderUserModel: senderUserModel,
        receiverUserModel: receiverUserModel,
        message: contactMessage,
        timeSent: timeSent,
        isGroupChat: isGroupChat,
        reciverUserId: receiverId,
      );

      _saveMessageToMessageCollection(
        message: fileDownloadUrl,
        receiverId: receiverId,
        timeSent: timeSent,
        messageId: messageId,
        senderUsername: senderUserModel.name,
        receiverUsername: receiverUserModel?.name,
        messageType: messageType,
        messageReply: messageReply,
        messageReplyType:
            messageReply == null ? MessageTypes.text : messageReply.messageType,
        isGroupChat: isGroupChat,
      );
    } catch (e) {
      showToast(context: context, message: e.toString());
      debugPrint(e.toString());
    }
  }

  void sendGIFMessage({
    required BuildContext context,
    required String gifUrl,
    required String receiverId,
    required UserModel senderUserModel,
    required MessageReplyProvider? messageReply,
    required bool isGroupChat,
  }) async {
    try {
      var timeSent = DateTime.now();
      UserModel? receiverUserModel;

      if (!isGroupChat) {
        receiverUserModel = await firebaseFirestore
            .collection('users')
            .doc(receiverId)
            .get()
            .then((value) => UserModel.fromJson(value.data()!));
      }

      var messageId = const Uuid().v1();

      _saveDataToContactCollection(
        message: 'GIF',
        receiverUserModel: receiverUserModel,
        senderUserModel: senderUserModel,
        timeSent: timeSent,
        isGroupChat: isGroupChat,
        reciverUserId: receiverId,
      );

      _saveMessageToMessageCollection(
        message: gifUrl,
        receiverId: receiverId,
        timeSent: timeSent,
        messageId: messageId,
        senderUsername: senderUserModel.name,
        receiverUsername: receiverUserModel?.name,
        messageType: MessageTypes.gif,
        messageReply: messageReply,
        messageReplyType:
            messageReply == null ? MessageTypes.text : messageReply.messageType,
        isGroupChat: isGroupChat,
      );
    } catch (e) {
      showToast(context: context, message: e.toString());
      debugPrint(e.toString());
    }
  }

  void updateMessageReadStatus({
    required BuildContext context,
    required String receiverId,
    required String messageId,
  }) async {
    try {
      await firebaseFirestore
          .collection('users')
          .doc(firebaseAuth.currentUser!.uid)
          .collection('chats')
          .doc(receiverId)
          .collection('messages')
          .doc(messageId)
          .update({'isRead': true});

      await firebaseFirestore
          .collection('users')
          .doc(receiverId)
          .collection('chats')
          .doc(firebaseAuth.currentUser!.uid)
          .collection('messages')
          .doc(messageId)
          .update({'isRead': true});
    } catch (e) {
      showToast(context: context, message: e.toString());
      debugPrint(e.toString());
    }
  }
}
