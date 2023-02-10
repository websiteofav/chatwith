import 'package:chatwith/features/auth/controller/auth_controller.dart';
import 'package:chatwith/features/auth/models/user_model.dart';
import 'package:chatwith/features/chat/models/contact_chat.dart';
import 'package:chatwith/features/chat/models/message.dart';
import 'package:chatwith/features/chat/repository/chat_repository.dart';
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

  void sendTextMessage({
    required BuildContext context,
    required String message,
    required String receiverId,
  }) {
    ref.read(userDataAuthProvider).whenData(
          (value) => chatRepository.sendTextMessage(
            context: context,
            message: message,
            receiverId: receiverId,
            senderUserModel: value!,
          ),
        ); // check if userDat is loaded using Future
  }

  Stream<List<ContactChat>> getContactChats(BuildContext context) {
    return chatRepository.getContactChats(context: context);
  }

  Stream<List<Message>> getUserChats(String receiverUserId) {
    return chatRepository.getUserChats(receiverUserId: receiverUserId);
  }
}
