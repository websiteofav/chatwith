import 'dart:async';
import 'dart:io';

import 'package:chatwith/features/chat/controller/chat_controller.dart';
import 'package:chatwith/features/chat/widgets/reply_message.dart';
import 'package:chatwith/utils/colors.dart';
import 'package:chatwith/utils/enums.dart';
import 'package:chatwith/utils/providers/message_reply.dart';
import 'package:chatwith/utils/utils.dart';
import 'package:chatwith/utils/widgets/toast_messages.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:enough_giphy_flutter/enough_giphy_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class BottomChatTextField extends ConsumerStatefulWidget {
  final String receiverId;
  final bool isGroupChat;
  const BottomChatTextField({
    Key? key,
    required this.receiverId,
    required this.isGroupChat,
  }) : super(key: key);

  @override
  ConsumerState<BottomChatTextField> createState() =>
      _BottomChatTextFieldState();
}

class _BottomChatTextFieldState extends ConsumerState<BottomChatTextField> {
  bool showSendButton = false;
  bool showEmojiPicker = false;
  final TextEditingController messageController = TextEditingController();
  FocusNode focusNode = FocusNode();
  FlutterSoundRecorder? recorder;
  bool isRecorderInitialized = false;
  bool isRecording = false;

  @override
  void initState() {
    recorder = FlutterSoundRecorder();
    openAudio();

    super.initState();
  }

  @override
  void dispose() {
    recorder!.closeRecorder();
    isRecorderInitialized = false;
    recorder = null;
    focusNode.dispose();
    messageController.dispose();
    super.dispose();
  }

  Future openAudio() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      showToast(context: context, message: 'Microphone permission not granted');

      throw RecordingPermissionException('Microphone permission not granted');
    }
    await recorder!.openRecorder();
    isRecorderInitialized = true;
  }

  void sendTextMessage(MessageReplyProvider? messageReplyProvider) async {
    if (showSendButton) {
      ref.read(chatControllerProvider).sendTextMessage(
            context: context,
            message: messageController.text.trim(),
            receiverId: widget.receiverId,
            isGroupChat: widget.isGroupChat,
          );

      messageController.clear();
    } else {
      var tempDir = await getTemporaryDirectory();
      var tempPath = '${tempDir.path}/flutter_sound.aac';
      if (!isRecorderInitialized) {
        return;
      }
      if (isRecording) {
        await recorder!.stopRecorder();
        isRecording = false;
        sendFileMessage(file: File(tempPath), messageType: MessageTypes.audio);
      } else {
        await recorder!.startRecorder(toFile: tempPath);
        isRecording = true;
      }

      setState(() {});
    }
  }

  void sendFileMessage(
      {required File file, required MessageTypes messageType}) {
    ref.read(chatControllerProvider).sendFileMessage(
          context: context,
          receiverId: widget.receiverId,
          file: file,
          messageType: messageType,
          isGroupChat: widget.isGroupChat,
        );
  }

  void selectImage() async {
    File? image = await pickImageFromGallery(context);

    if (image != null) {
      sendFileMessage(file: image, messageType: MessageTypes.image);
    }
  }

  void selectVideo() async {
    File? video = await pickVideoFromGallery(context);

    if (video != null) {
      sendFileMessage(file: video, messageType: MessageTypes.video);
    }
  }

  void selectGIF() async {
    GiphyGif? gif = await pickGIF(context);

    if (gif != null) {
      ref.read(chatControllerProvider).sendGIFMessage(
          context: context,
          gifUrl: gif.url,
          receiverId: widget.receiverId,
          isGroupChat: widget.isGroupChat);
    }
  }

  @override
  Widget build(BuildContext context) {
    final messageReply = ref.watch(messageReplyProvider);
    final showMessageReply = messageReply != null;
    return WillPopScope(
      onWillPop: () {
        if (showEmojiPicker) {
          setState(() {
            showEmojiPicker = false;
          });
          return Future.value(false);
        }

        return Future.value(true);
      },
      child: Container(
        // height: 70,
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
            color: c131C21, border: Border(bottom: BorderSide(color: cC3B9B9))),
        child: Column(
          children: [
            showMessageReply ? const MessageReply() : const SizedBox.shrink(),
            showMessageReply
                ? const SizedBox(height: 5)
                : const SizedBox.shrink(),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onTap: () {
                      if (showEmojiPicker) {
                        setState(() {
                          showEmojiPicker = false;
                        });
                      }
                    },
                    focusNode: focusNode,
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
                              onPressed: selectImage,
                            ),
                            IconButton(
                              padding: const EdgeInsets.only(right: 5),
                              constraints: const BoxConstraints(),
                              icon: const Icon(
                                Icons.attach_file_rounded,
                                color: cC3B9B9,
                              ),
                              onPressed: selectVideo,
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
                              onPressed: () {
                                focusNode.unfocus();

                                Future.delayed(
                                    const Duration(milliseconds: 500), () {
                                  setState(() {
                                    showEmojiPicker = !showEmojiPicker;
                                  });
                                });
                              }),
                          IconButton(
                            padding:
                                const EdgeInsets.only(right: 20, bottom: 10),
                            constraints: const BoxConstraints(),
                            icon: const Icon(
                              Icons.gif_rounded,
                              size: 40,
                              color: cC3B9B9,
                            ),
                            onPressed: selectGIF,
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
                  onTap: () => sendTextMessage(messageReply),
                  child: CircleAvatar(
                    backgroundColor: coC54BE,
                    radius: 20,
                    child: Icon(
                      showSendButton
                          ? Icons.send_rounded
                          : isRecording
                              ? Icons.close_rounded
                              : Icons.mic_rounded,
                      color: cffffff,
                    ),
                  ),
                ),
              ],
            ),
            if (showEmojiPicker)
              SizedBox(
                height: 280,
                child: EmojiPicker(onEmojiSelected: ((category, emoji) {
                  messageController.text = messageController.text + emoji.emoji;
                  if (!showSendButton) {
                    setState(() {
                      showSendButton = true;
                    });
                  }
                })),
              ),
          ],
        ),
      ),
    );
  }
}
