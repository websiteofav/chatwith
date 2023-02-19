import 'package:chatwith/features/chat/widgets/display_message.dart';
import 'package:chatwith/utils/colors.dart';
import 'package:chatwith/utils/enums.dart';
import 'package:flutter/material.dart';

class MyMessageCard extends StatelessWidget {
  final String message;
  final String time;
  final MessageTypes messageType;
  final VoidCallback onLongPress;
  final String replyText;
  final String username;
  final MessageTypes repliedMessageType;
  final bool isRead;
  const MyMessageCard({
    Key? key,
    required this.message,
    required this.time,
    required this.messageType,
    required this.onLongPress,
    required this.replyText,
    required this.username,
    required this.repliedMessageType,
    required this.isRead,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final repliedMessage = replyText.isNotEmpty;
    return GestureDetector(
      onLongPress: onLongPress,
      child: Align(
        alignment: Alignment.centerRight,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width - 45,
          ),
          child: Card(
              elevation: 1,
              color: c604949,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: messageType == MessageTypes.text
                        ? const EdgeInsets.only(
                            left: 10,
                            right: 20,
                            bottom: 20,
                            top: 5,
                          )
                        : const EdgeInsets.only(
                            left: 5,
                            right: 5,
                            bottom: 5,
                            top: 5,
                          ),
                    child: Column(
                      children: [
                        if (repliedMessage) ...[
                          Text(
                            username,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: cffffff.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: DisplayMessage(
                              message: replyText,
                              messageType: repliedMessageType,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                        ],
                        DisplayMessage(
                          message: message,
                          messageType: messageType,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 5.0, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          time,
                          style: const TextStyle(
                            fontSize: 13,
                            color: cC3B9B9,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.done_all,
                          color: isRead ? coC54BE : cC3B9B9,
                          size: 15,
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
