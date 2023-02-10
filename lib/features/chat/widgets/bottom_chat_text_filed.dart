import 'package:chatwith/features/chat/controller/chat_controller.dart';
import 'package:chatwith/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BottomChatTextField extends ConsumerStatefulWidget {
  final String receiverId;
  const BottomChatTextField({
    Key? key,
    required this.receiverId,
  }) : super(key: key);

  @override
  ConsumerState<BottomChatTextField> createState() =>
      _BottomChatTextFieldState();
}

class _BottomChatTextFieldState extends ConsumerState<BottomChatTextField> {
  bool showSendButton = false;
  final TextEditingController messageController = TextEditingController();

  void sendTextMessage() async {
    if (showSendButton) {
      ref.read(chatControllerProvider).sendTextMessage(
            context: context,
            message: messageController.text.trim(),
            receiverId: widget.receiverId,
          );

      messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1,
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
          color: c131C21, border: Border(bottom: BorderSide(color: cC3B9B9))),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: messageController,
              onChanged: ((value) {
                if (value.trim().isNotEmpty) {
                  setState(() {
                    showSendButton = true;
                  });
                } else {
                  setState(() {
                    showSendButton = false;
                  });
                }
              }),
              maxLines: null,
              style: const TextStyle(color: cffffff),
              decoration: InputDecoration(
                filled: true,
                fillColor: c55554D,
                suffixIcon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        padding: const EdgeInsets.only(left: 5),
                        constraints: const BoxConstraints(),
                        icon: const Icon(
                          Icons.camera_alt_rounded,
                          color: cE6D3D3,
                        ),
                        onPressed: () {},
                      ),
                      IconButton(
                        padding: const EdgeInsets.only(right: 5),
                        constraints: const BoxConstraints(),
                        icon: const Icon(
                          Icons.attach_file_rounded,
                          color: cC3B9B9,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                prefixIcon: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      padding: const EdgeInsets.only(left: 5),
                      constraints: const BoxConstraints(),
                      icon: const Icon(
                        Icons.emoji_emotions_rounded,
                        color: c9FFFF06,
                      ),
                      onPressed: () {},
                    ),
                    IconButton(
                      padding: const EdgeInsets.only(right: 20, bottom: 10),
                      constraints: const BoxConstraints(),
                      icon: const Icon(
                        Icons.gif_rounded,
                        size: 40,
                        color: cC3B9B9,
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
                hintStyle: const TextStyle(
                  fontSize: 12,
                ),
                hintText: 'Type a message',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.all(10),
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          GestureDetector(
            onTap: sendTextMessage,
            child: CircleAvatar(
              backgroundColor: coC54BE,
              radius: 20,
              child: Icon(
                showSendButton ? Icons.send_rounded : Icons.mic_rounded,
                color: cffffff,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
