import 'package:chatwith/features/auth/controller/auth_controller.dart';
import 'package:chatwith/features/auth/models/user_model.dart';
import 'package:chatwith/features/call/controller/call_controller.dart';
import 'package:chatwith/features/call/screens/call_pickup.dart';
import 'package:chatwith/features/chat/widgets/bottom_chat_text_filed.dart';
import 'package:chatwith/utils/colors.dart';
import 'package:chatwith/features/chat/widgets/chat_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MobileChatScreen extends ConsumerWidget {
  static const routeName = '/mobileChat';
  final UserModel userModel;
  final bool isGroupChat;
  const MobileChatScreen(
      {Key? key, required this.userModel, required this.isGroupChat})
      : super(key: key);

  void makeACall({
    required BuildContext context,
    required WidgetRef ref,
  }) {
    ref.read(callControllerProvider).makeACall(
        recieverUserId: userModel.uid,
        recieverUserName: userModel.name,
        recieverUserPic: userModel.profilePic,
        isGroupChat: isGroupChat,
        context: context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CallPickup(
      scaffold: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          backgroundColor: c0C181F,
          elevation: 0,
          title: isGroupChat
              ? Text(
                  userModel.name,
                  style: const TextStyle(
                    color: cffffff,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : StreamBuilder<UserModel>(
                  stream: ref
                      .read(authControllerProvider)
                      .getUserDataById(userModel.uid),
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
                            style:
                                const TextStyle(color: c8c9a9e, fontSize: 12),
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
              onPressed: () => makeACall(context: context, ref: ref),
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
                isGroupChat: isGroupChat,
              ),
            ),
            BottomChatTextField(
              receiverId: userModel.uid,
              isGroupChat: isGroupChat,
            )
          ],
        ),
      ),
    );
  }
}
