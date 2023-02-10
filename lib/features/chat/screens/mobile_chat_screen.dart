import 'package:chatwith/features/auth/controller/auth_controller.dart';
import 'package:chatwith/features/auth/models/user_model.dart';
import 'package:chatwith/features/chat/widgets/bottom_chat_text_filed.dart';
import 'package:chatwith/utils/colors.dart';
import 'package:chatwith/features/chat/screens/chat_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MobileChatScreen extends ConsumerWidget {
  static const routeName = '/mobileChat';
  final UserModel userModel;
  const MobileChatScreen({Key? key, required this.userModel}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: c0C181F,
        elevation: 0,
        title: StreamBuilder<UserModel>(
            stream:
                ref.read(authControllerProvider).getUserDataById(userModel.uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userModel.name,
                      style: const TextStyle(
                        color: cffffff,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      snapshot.data!.isOnline ? 'Online' : '',
                      style: const TextStyle(color: c8c9a9e, fontSize: 12),
                    )
                  ],
                );
              }
              return Text(
                userModel.name,
                style: const TextStyle(
                  color: cffffff,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              );
            }),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.call_rounded,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.video_call_rounded,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert_rounded),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ChatList(
              receiverUserId: userModel.uid,
            ),
          ),
          BottomChatTextField(
            receiverId: userModel.uid,
          )
        ],
      ),
    );
  }
}
