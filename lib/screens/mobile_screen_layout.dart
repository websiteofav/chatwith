import 'package:chatwith/features/auth/controller/auth_controller.dart';
import 'package:chatwith/features/contacts/screens/contacts.dart';
import 'package:chatwith/utils/colors.dart';
import 'package:chatwith/features/chat/screens/contacts_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MobileScreenLayout extends ConsumerStatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  ConsumerState<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends ConsumerState<MobileScreenLayout>
    with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
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
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.more_vert_rounded),
                )
              ],
              bottom: const TabBar(
                  indicatorColor: c33cc33,
                  indicatorWeight: 3,
                  labelColor: c33cc33,
                  unselectedLabelColor: cffffff,
                  labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      letterSpacing: 2),
                  tabs: [
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
            body: const ContactsList(),
            floatingActionButton: FloatingActionButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed(Contacts.routeName),
              backgroundColor: c33cc33,
              child: const Icon(Icons.message_rounded, color: cffffff),
            )));
  }
}
