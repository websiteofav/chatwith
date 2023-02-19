import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatwith/features/chat/widgets/video_player_widget.dart';
import 'package:chatwith/utils/enums.dart';
import 'package:flutter/material.dart';

class DisplayMessage extends StatelessWidget {
  final String message;
  final MessageTypes messageType;
  const DisplayMessage(
      {Key? key, required this.message, required this.messageType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isPlaying = false;
    final AudioPlayer audioPlayer = AudioPlayer();
    return messageType == MessageTypes.text
        ? Text(
            message,
            style: const TextStyle(fontSize: 16, color: Colors.black),
          )
        : messageType == MessageTypes.video
            ? VideoPlayerWidget(
                url: message,
              )
            : messageType == MessageTypes.audio
                ? StatefulBuilder(builder: (context, setState) {
                    return Column(
                      children: [
                        IconButton(
                            constraints: const BoxConstraints(
                                minWidth: 100, maxHeight: 50),
                            onPressed: () async {
                              if (isPlaying) {
                                await audioPlayer.pause();
                                setState(
                                  () {
                                    isPlaying = false;
                                  },
                                );
                              } else {
                                await audioPlayer.resume();
                                setState(
                                  () {
                                    isPlaying = true;
                                  },
                                );
                              }
                            },
                            icon: Icon(isPlaying
                                ? Icons.pause_circle_rounded
                                : Icons.play_circle_rounded)),
                      ],
                    );
                  })
                : CachedNetworkImage(imageUrl: message);
  }
}
