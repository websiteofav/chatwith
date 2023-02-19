import 'package:chatwith/features/chat/controller/chat_controller.dart';
import 'package:chatwith/features/chat/models/message.dart';
import 'package:chatwith/utils/enums.dart';
import 'package:chatwith/utils/info.dart';
import 'package:chatwith/utils/providers/message_reply.dart';
import 'package:chatwith/utils/widgets/loader.dart';
import 'package:chatwith/features/chat/widgets/my_message_card.dart';
import 'package:chatwith/features/chat/widgets/sender_message_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ChatList extends ConsumerStatefulWidget {
  final String receiverUserId;
  final bool isGroupChat;
  const ChatList({
    super.key,
    required this.receiverUserId,
    required this.isGroupChat,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  final ScrollController _scrollController = ScrollController();
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void onLongPress(
      {required String message,
      required bool isMe,
      required MessageTypes messageType}) {
    ref.read(messageReplyProvider.notifier).update((state) =>
        MessageReplyProvider(
            message: message, isMe: isMe, messageType: messageType));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Message>>(
        stream: widget.isGroupChat
            ? ref
                .read(chatControllerProvider)
                .getGroupChats(widget.receiverUserId)
            : ref
                .read(chatControllerProvider)
                .getUserChats(widget.receiverUserId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Loader();
          }
          SchedulerBinding.instance.addPostFrameCallback((_) {
            _scrollController
                .jumpTo(_scrollController.position.maxScrollExtent);
          });
          final messages = snapshot.data ?? [];
          return ListView.builder(
            controller: _scrollController,
            shrinkWrap: true,
            itemCount: messages.length,
            itemBuilder: ((context, index) {
              final message = messages[index];
              final timesent = DateFormat.Hm().format(message.timeSent);
              if (message.isRead == false &&
                  message.senderId == widget.receiverUserId) {
                ref.read(chatControllerProvider).updateMessageReadStatus(
                    messageId: message.messageId,
                    context: context,
                    receiverId: widget.receiverUserId);
              }
              if (message.senderId == FirebaseAuth.instance.currentUser!.uid) {
                return MyMessageCard(
                  message: message.message,
                  time: timesent,
                  messageType: message.messageType,
                  replyText: message.replyText,
                  onLongPress: () => onLongPress(
                      isMe: true,
                      message: message.message,
                      messageType: message.messageType),
                  username: message.repliedTo,
                  repliedMessageType: message.repliedToMessageType,
                  isRead: message.isRead,
                );
              } else {
                return SenderMessageCard(
                  message: message.message,
                  time: timesent,
                  messageType: message.messageType,
                  replyText: message.replyText,
                  onLongPress: () => onLongPress(
                      isMe: false,
                      message: message.message,
                      messageType: message.messageType),
                  username: message.repliedTo,
                  repliedMessageType: message.repliedToMessageType,
                );
              }
            }),
          );
        });
  }
}
