import 'package:chatwith/features/chat/controller/chat_controller.dart';
import 'package:chatwith/features/chat/models/message.dart';
import 'package:chatwith/utils/info.dart';
import 'package:chatwith/utils/widgets/loader.dart';
import 'package:chatwith/utils/widgets/my_message_card.dart';
import 'package:chatwith/utils/widgets/sender_message_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ChatList extends ConsumerStatefulWidget {
  final String receiverUserId;
  const ChatList({
    super.key,
    required this.receiverUserId,
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

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Message>>(
        stream: ref
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
              if (message.senderId != widget.receiverUserId) {
                return MyMessageCard(
                  message: message.message,
                  time: timesent,
                );
              } else {
                return SenderMessageCard(
                  message: message.message,
                  time: timesent,
                );
              }
            }),
          );
        });
  }
}
