import 'dart:io';

import 'package:chatwith/features/auth/controller/auth_controller.dart';
import 'package:chatwith/features/chat/models/contact_chat.dart';
import 'package:chatwith/features/chat/models/message.dart';
import 'package:chatwith/features/chat/repository/chat_repository.dart';
import 'package:chatwith/features/group/models/group.dart';
import 'package:chatwith/utils/enums.dart';
import 'package:chatwith/utils/providers/message_reply.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatControllerProvider = Provider((ref) {
  final chatRepository = ref.watch(chatRepositoryProvider);

  return ChatController(chatRepository: chatRepository, ref: ref);
});

class ChatController {
  final ChatRepository chatRepository;

  final ProviderRef ref;

  ChatController({required this.chatRepository, required this.ref});

  void sendTextMessage(
      {required BuildContext context,
      required String message,
      required String receiverId,
      required bool isGroupChat}) {
    final messageReply = ref.watch(messageReplyProvider);
    ref.read(userDataAuthProvider).whenData(
          (value) => chatRepository.sendTextMessage(
              context: context,
              message: message,
              receiverId: receiverId,
              senderUserModel: value!,
              messageReply: messageReply,
              isGroupChat: isGroupChat),
        ); // check if userData is loaded using Future

    ref.read(messageReplyProvider.notifier).update((state) => null);
  }

  Stream<List<ContactChat>> getContactChats(BuildContext context) {
    return chatRepository.getContactChats(context: context);
  }

  Stream<List<GroupModel>> getChatsGroups(BuildContext context) {
    return chatRepository.getChatsGroups(context: context);
  }

  Stream<List<Message>> getUserChats(String receiverUserId) {
    return chatRepository.getUserChats(receiverUserId: receiverUserId);
  }

  Stream<List<Message>> getGroupChats(String groupId) {
    return chatRepository.getGroupChats(groupId: groupId);
  }

  void sendFileMessage(
      {required BuildContext context,
      required String receiverId,
      required File file,
      required MessageTypes messageType,
      required bool isGroupChat}) {
    final messageReply = ref.watch(messageReplyProvider);

    ref.read(userDataAuthProvider).whenData(
          (value) => chatRepository.sendFileMessage(
              context: context,
              file: file,
              messageType: messageType,
              ref: ref,
              receiverId: receiverId,
              senderUserModel: value!,
              messageReply: messageReply,
              isGroupChat: isGroupChat),
        );
    // check if userData is loaded using Future

    ref.read(messageReplyProvider.notifier).update((state) => null);
  }

  void sendGIFMessage(
      {required BuildContext context,
      required String gifUrl,
      required String receiverId,
      required bool isGroupChat}) {
    final messageReply = ref.watch(messageReplyProvider);

    String gifBaseUrl = 'https://i.giphy.com/media/';
    String gifRefactoredUrl = "$gifBaseUrl${gifUrl.split('-').last}/200.gif";
    ref.read(userDataAuthProvider).whenData(
          (value) => chatRepository.sendGIFMessage(
              context: context,
              gifUrl: gifRefactoredUrl,
              receiverId: receiverId,
              senderUserModel: value!,
              messageReply: messageReply,
              isGroupChat: isGroupChat),
        ); // check if userData is loaded using Future

    ref.read(messageReplyProvider.notifier).update((state) => null);
  }

  void updateMessageReadStatus(
      {required BuildContext context,
      required String receiverId,
      required String messageId}) {
    chatRepository.updateMessageReadStatus(
        context: context,
        receiverId: receiverId,
        messageId: messageId); // check if userData is loaded using Future
  }
}
