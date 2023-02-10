import 'dart:io';

import 'package:chatwith/features/auth/controller/auth_controller.dart';
import 'package:chatwith/utils/colors.dart';
import 'package:chatwith/utils/images.dart';
import 'package:chatwith/utils/pick_image.dart';
import 'package:chatwith/utils/widgets/custom_button.dart';
import 'package:chatwith/utils/widgets/toast_messages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UserDetail extends ConsumerStatefulWidget {
  static const routeName = '/userDetail';
  const UserDetail({Key? key}) : super(key: key);

  @override
  ConsumerState<UserDetail> createState() => _UserDetailState();
}

class _UserDetailState extends ConsumerState<UserDetail> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailIdController = TextEditingController();

  final TextEditingController _bioController = TextEditingController();

  File? image;

  void selectImage() async {
    image = await pickImageFromGallery(context);

    setState(() {});
  }

  void saveUserData() async {
    final name = _nameController.text.trim();
    final emailId = _emailIdController.text.trim();
    final bio = _bioController.text.trim();

    if (name.isEmpty) {
      showToast(
          context: context,
          message: 'Please enter your name',
          toastGravity: ToastGravity.CENTER);
      return;
    } else {
      ref.watch(authControllerProvider).saveUserdataToFirebase(
          name: name,
          email: emailId,
          bio: bio,
          profilePic: image,
          context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        body: SafeArea(
            child: Center(
                child: Column(
      children: [
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
        Container(
          width: size.width * 0.8,
          padding: const EdgeInsets.all(20),
          child: TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              hintText: 'Your Name  (*)',
              hintStyle: TextStyle(color: Colors.grey),
              // border: InputBorder.none,
            ),
          ),
        ),
        Container(
          width: size.width * 0.8,
          padding: const EdgeInsets.all(20),
          child: TextField(
            controller: _emailIdController,
            decoration: const InputDecoration(
              hintText: 'Your Email Id',
              hintStyle: TextStyle(color: Colors.grey),
              // border: InputBorder.none,
            ),
          ),
        ),
        Container(
          width: size.width * 0.8,
          padding: const EdgeInsets.all(20),
          child: TextField(
            maxLines: null,
            controller: _bioController,
            decoration: const InputDecoration(
              hintText: 'Tell us about yourself',
              hintStyle: TextStyle(color: Colors.grey),
              // border: InputBorder.none,
            ),
          ),
        ),
        SizedBox(
          width: size.width * 0.5,
          // height: size.height * 0.2,
          child: CustomButton(
            text: 'Save',
            onPressed: saveUserData,
            color: c33cc33,
          ),
        )
      ],
    ))));
  }
}
