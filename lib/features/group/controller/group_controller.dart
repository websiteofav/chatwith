import 'dart:io';

import 'package:chatwith/features/group/repository/group_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final groupControllerProvider = Provider<GroupController>((ref) {
  return GroupController(
    groupRepository: ref.read(groupRepositoryProvider),
    ref: ref,
  );
});

class GroupController {
  final GroupRepository groupRepository;

  final ProviderRef ref;

  GroupController({required this.groupRepository, required this.ref});

  void createGroup(
      {required BuildContext context,
      required String name,
      required File groupProfilePic,
      required List<Contact> selectedContacts}) async {
    await groupRepository.createGroup(
        context: context,
        groupName: name,
        groupPic: groupProfilePic,
        selectedContacts: selectedContacts);
  }
}
