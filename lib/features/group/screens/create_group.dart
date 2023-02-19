import 'dart:io';

import 'package:chatwith/features/group/controller/group_controller.dart';
import 'package:chatwith/features/group/widgets/select_contacts.dart';
import 'package:chatwith/utils/colors.dart';
import 'package:chatwith/utils/images.dart';
import 'package:chatwith/utils/utils.dart';
import 'package:chatwith/utils/widgets/toast_messages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateGroup extends ConsumerStatefulWidget {
  static const String routeName = '/createGroup';
  const CreateGroup({Key? key}) : super(key: key);

  @override
  ConsumerState<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends ConsumerState<CreateGroup> {
  final TextEditingController _groupNameController = TextEditingController();
  File? image;

  void selectImage() async {
    image = await pickImageFromGallery(context);

    setState(() {});
  }

  void createGroup() {
    if (image == null) {
      showToast(context: context, message: 'Please select group image');
      return;
    } else if (_groupNameController.text.isEmpty) {
      showToast(context: context, message: 'Please enter group name');
      return;
    } else if (ref.read(selectContacts).isEmpty) {
      showToast(context: context, message: 'Please select contacts');
      return;
    } else {
      ref.read(groupControllerProvider).createGroup(
          context: context,
          name: _groupNameController.text.trim(),
          groupProfilePic: image!,
          selectedContacts: ref.read(selectContacts));

      ref.read(selectContacts.notifier).state = [];

      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _groupNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Create Group'),
        ),
        body: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Stack(
              children: [
                image == null
                    ? const CircleAvatar(
                        backgroundImage: AssetImage(Images.noProfileImage),
                        radius: 60,
                      )
                    : CircleAvatar(
                        backgroundImage: FileImage(image!),
                        radius: 60,
                      ),
                Positioned(
                  bottom: -10,
                  left: 80,
                  child: IconButton(
                    onPressed: selectImage,
                    icon: const Icon(
                      Icons.add_a_photo_rounded,
                      size: 40,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _groupNameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter Group Name',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              alignment: Alignment.centerLeft,
              child: const Text('Select Contacts',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            const SelectContacts(),
          ],
        )),
        floatingActionButton: FloatingActionButton(
          backgroundColor: c33cc33,
          onPressed: createGroup,
          child: const Icon(Icons.check, color: cffffff),
        ));
  }
}
