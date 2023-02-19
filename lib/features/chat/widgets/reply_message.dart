import 'package:chatwith/features/chat/widgets/display_message.dart';
import 'package:chatwith/utils/colors.dart';
import 'package:chatwith/utils/providers/message_reply.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MessageReply extends ConsumerWidget {
  const MessageReply({super.key});

  void cancelReply(WidgetRef ref) {
    ref.read(messageReplyProvider.notifier).update((state) => null);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messageReply = ref.watch(messageReplyProvider);

    return Container(
      // color: c747578,
      // margin: EdgeInsets.only(bottom: 10),

      decoration: const BoxDecoration(
          color: c304450,
          boxShadow: [
            BoxShadow(
              blurRadius: 25.0,
            ),
          ],
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12), topRight: Radius.circular(12))),

      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                  child: Text(
                messageReply!.isMe ? 'You' : 'Someone',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              )),
              GestureDetector(
                  child: const Icon(Icons.close_rounded, size: 18),
                  onTap: () => cancelReply(ref))
            ],
          ),
          const SizedBox(height: 4),
          DisplayMessage(
            message: messageReply.message,
            messageType: messageReply.messageType,
          )
        ],
      ),
    );
  }
}
