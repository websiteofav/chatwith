import 'package:chatwith/features/contacts/controller/contact_controller.dart';
import 'package:chatwith/features/chat/widgets/contacts_list.dart';
import 'package:chatwith/utils/widgets/error.dart';
import 'package:chatwith/utils/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Contacts extends ConsumerWidget {
  static const routeName = '/contacts';
  const Contacts({Key? key}) : super(key: key);

  void checkContact(
      {required Contact contact,
      required BuildContext context,
      required WidgetRef ref}) {
    ref
        .read(contactControllerProvider)
        .checkContact(contact: contact, context: context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Select Contacts'),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search_rounded),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_vert_rounded),
            ),
          ],
        ),
        body: ref.watch(getContactProvider).when(
            data: (contactsList) {
              return contactsList.isEmpty
                  ? const ErrorScreen(
                      message: 'No Contacts to display',
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: ((context, index) {
                        final contact = contactsList[index];
                        return ListTile(
                          onTap: () => checkContact(
                              contact: contact, context: context, ref: ref),
                          leading: contact.photo == null
                              ? null
                              : CircleAvatar(
                                  radius: 25,
                                  backgroundImage: MemoryImage(contact.photo!),
                                ),
                          title: Text(contact.displayName,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 20)),
                          // subtitle: Text(
                          //   contact.phones.,
                          // ),
                        );
                      }),
                      separatorBuilder: (context, index) {
                        return const Padding(
                          padding: EdgeInsets.only(bottom: 5),
                          child: Divider(),
                        );
                      },
                      itemCount: contactsList.length);
            },
            error: (err, trace) => ErrorScreen(message: err.toString()),
            loading: () => const Loader()));
  }
}
