import 'package:chatwith/utils/enums.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MessageReplyProvider {
  final String message;
  final bool isMe;
  final MessageTypes messageType;

  MessageReplyProvider(
      {required this.message, required this.isMe, required this.messageType});
}

final messageReplyProvider =
    StateProvider<MessageReplyProvider?>((ref) => null);
