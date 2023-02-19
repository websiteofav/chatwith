import 'dart:io';

import 'package:chatwith/features/auth/controller/auth_controller.dart';
import 'package:chatwith/features/contacts/screens/contacts.dart';
import 'package:chatwith/features/group/screens/create_group.dart';
import 'package:chatwith/features/status/screens/confirm_status.dart';
import 'package:chatwith/features/status/screens/status_contact.dart';
import 'package:chatwith/utils/colors.dart';
import 'package:chatwith/features/chat/widgets/contacts_list.dart';
import 'package:chatwith/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MobileScreenLayout extends ConsumerStatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  ConsumerState<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends ConsumerState<MobileScreenLayout>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        ref.read(authControllerProvider).updateUserOnlineStatus(true);
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        ref.read(authControllerProvider).updateUserOnlineStatus(false);
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int tabLength = 3;

    return DefaultTabController(
        length: tabLength,
        child: Scaffold(
            appBar: AppBar(
              centerTitle: false,
              backgroundColor: c0C181F,
              elevation: 0,
              title: const Text(
                'ChatWith',
                style: TextStyle(
                  color: cffffff,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.search_rounded,
                  ),
                ),
                PopupMenuButton(itemBuilder: ((context) {
                  return [
                    PopupMenuItem(
                        height: 30,
                        child: const Text('New Group'),
                        onTap: () => Future(() => Navigator.of(context)
                            .pushNamed(CreateGroup.routeName))),
                    // PopupMenuItem(
                    //   child: Text('New Broadcast'),
                    // ),
                    // PopupMenuItem(
                    //   child: Text('WhatsApp Web'),
                    // ),
                    // PopupMenuItem(
                    //   child: Text('Starred Messages'),
                    // ),
                    // PopupMenuItem(
                    //   child: Text('Settings'),
                    // ),
                  ];
                }))
              ],
              // IconButton(
              //   onPressed: () {},
              //   icon: const Icon(Icons.more_vert_rounded),
              // )

              bottom: TabBar(
                  controller: _tabController,
                  indicatorColor: c33cc33,
                  indicatorWeight: 3,
                  labelColor: c33cc33,
                  unselectedLabelColor: cffffff,
                  labelStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      letterSpacing: 2),
                  tabs: const [
                    Tab(
                      text: 'Chats',
                    ),
                    Tab(
                      text: 'Status',
                    ),
                    Tab(
                      text: 'Calls',
                    ),
                  ]),
            ),
            body: TabBarView(controller: _tabController, children: const [
              ContactsList(),
              StatusContact(),
              Center(child: Text('Calls'))
            ]),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                if (_tabController.index == 0) {
                  Navigator.of(context).pushNamed(Contacts.routeName);
                } else {
                  File? image = await pickImageFromGallery(context);
                  if (image != null) {
                    if (mounted) {
                      Navigator.of(context)
                          .pushNamed(ConfirmStatus.routeName, arguments: image);
                    }
                  }
                }
              },
              backgroundColor: c33cc33,
              child: const Icon(Icons.message_rounded, color: cffffff),
            )));
  }
}
