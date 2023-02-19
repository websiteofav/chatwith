//create a message class

import 'package:chatwith/utils/enums.dart';

class Message {
  final String senderId;
  final String receiverId;
  final String message;
  final DateTime timeSent;
  final String messageId;
  final bool isRead;
  final MessageTypes messageType;
  final String replyText;
  final String repliedTo;
  final MessageTypes repliedToMessageType;

  Message({
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.timeSent,
    required this.messageId,
    required this.isRead,
    required this.messageType,
    required this.replyText,
    required this.repliedTo,
    required this.repliedToMessageType,
  });

  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'timeSent': timeSent,
      'messageId': messageId,
      'isRead': isRead,
      'messageType': messageType.value,
      'replyText': replyText,
      'repliedTo': repliedTo,
      'repliedToMessageType': repliedToMessageType.value,
    };
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      message: json['message'],
      timeSent: json['timeSent'].toDate(),
      messageId: json['messageId'],
      isRead: json['isRead'],
      messageType: MessageTypes.values.firstWhere(
        (e) => e.value == json['messageType'],
      ),
      repliedTo: json['repliedTo'],
      replyText: json['replyText'],
      repliedToMessageType: MessageTypes.values.firstWhere(
        (e) => e.value == json['repliedToMessageType'],
      ),
    );
  }
}
