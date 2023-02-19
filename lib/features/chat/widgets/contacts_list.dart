import 'package:chatwith/features/auth/models/user_model.dart';
import 'package:chatwith/features/chat/controller/chat_controller.dart';
import 'package:chatwith/features/chat/models/contact_chat.dart';
import 'package:chatwith/features/group/models/group.dart';
import 'package:chatwith/utils/colors.dart';
import 'package:chatwith/utils/info.dart';
import 'package:chatwith/features/chat/screens/mobile_chat_screen.dart';
import 'package:chatwith/utils/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;

class ContactsList extends ConsumerWidget {
  const ContactsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 15,
      ),
      child: SingleChildScrollView(
        child: Column(children: [
          StreamBuilder<List<GroupModel>>(
              stream: ref.watch(chatControllerProvider).getChatsGroups(context),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Loader();
                }
                return ListView.separated(
                    shrinkWrap: true,
                    separatorBuilder: (context, index) => const Divider(
                          color: cC3B9B9,
                        ),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var groupData = snapshot.data![index];
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                              MobileChatScreen.routeName,
                              arguments: {
                                'userModel': UserModel(
                                    uid: groupData.groupUid,
                                    name: groupData.name,
                                    profilePic: groupData.groupProfilePic,
                                    bio: '',
                                    emailId: '',
                                    groupId: [],
                                    isOnline: false,
                                    mobileNumber: ''),
                                'isGroupChat': true
                              });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: ListTile(
                            title: Text(
                              groupData.name,
                              style: const TextStyle(fontSize: 20),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                groupData.lastMessage,
                                style: const TextStyle(fontSize: 15),
                              ),
                            ),
                            leading: CircleAvatar(
                              radius: 35,
                              backgroundImage: NetworkImage(
                                groupData.groupProfilePic,
                              ),
                            ),
                            trailing: Text(
                              timeago.format(groupData.lastMessageTime),
                              style:
                                  const TextStyle(fontSize: 13, color: cC3B9B9),
                            ),
                          ),
                        ),
                      );
                    });
              }),
          StreamBuilder<List<ContactChat>>(
              stream:
                  ref.watch(chatControllerProvider).getContactChats(context),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Loader();
                }
                return ListView.separated(
                    shrinkWrap: true,
                    separatorBuilder: (context, index) => const Divider(
                          color: cC3B9B9,
                        ),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var chatContact = snapshot.data![index];
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            MobileChatScreen.routeName,
                            arguments: {
                              'userModel': UserModel(
                                  uid: chatContact.contactId,
                                  name: chatContact.name,
                                  profilePic: chatContact.profilePic,
                                  bio: '',
                                  emailId: '',
                                  groupId: [],
                                  isOnline: false,
                                  mobileNumber: ''),
                              'isGroupChat': false
                            },
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: ListTile(
                            title: Text(
                              chatContact.name,
                              style: const TextStyle(fontSize: 20),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                chatContact.recentMessage,
                                style: const TextStyle(fontSize: 15),
                              ),
                            ),
                            leading: CircleAvatar(
                              radius: 35,
                              backgroundImage: NetworkImage(
                                chatContact.profilePic,
                              ),
                            ),
                            trailing: Text(
                              timeago.format(chatContact.timeSent),
                              style:
                                  const TextStyle(fontSize: 13, color: cC3B9B9),
                            ),
                          ),
                        ),
                      );
                    });
              }),
        ]),
      ),
    );
  }
}
