import 'dart:developer';

import 'package:chatwith/features/contacts/controller/contact_controller.dart';
import 'package:chatwith/utils/widgets/error.dart';
import 'package:chatwith/utils/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectContacts = StateProvider<List<Contact>>((ref) => []);

class SelectContacts extends ConsumerStatefulWidget {
  const SelectContacts({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SelectContactsState();
}

class _SelectContactsState extends ConsumerState<SelectContacts> {
  List<int> selectedContacts = [];

  void selectContact(int index, Contact contact) {
    if (selectedContacts.contains(index)) {
      selectedContacts.remove(index);
      final ind = ref.read(selectContacts).indexOf(contact);
      ref
          .read(selectContacts.notifier)
          .update((state) => [state.removeAt(ind)]);
    } else {
      selectedContacts.add(index);

      ref.read(selectContacts.notifier).update((state) => [...state, contact]);
    }
    setState(() {});

    log(ref.read(selectContacts).toString());
  }

  // @override
  // void dispose() {
  //   ref.read(selectContacts.notifier).state = [];

  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return ref.watch(getContactProvider).when(
        data: (contactsList) {
          return ListView.builder(
              shrinkWrap: true,
              itemCount: contactsList.length,
              itemBuilder: ((context, index) {
                final contact = contactsList[index];
                return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      onTap: () => selectContact(index, contact),
                      title: Text(
                        contact.displayName,
                        style: const TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 20),
                        // subtitle: Text(contact.phoneNumber),
                      ),
                      leading: selectedContacts.contains(index)
                          ? const Icon(Icons.check_circle)
                          : const Icon(Icons.circle_outlined),
                    ));
              }));
        },
        error: (err, trace) => ErrorScreen(message: err.toString()),
        loading: () => const Loader());
  }
}
