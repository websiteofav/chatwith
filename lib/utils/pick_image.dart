import 'dart:io';

import 'package:chatwith/utils/widgets/toast_messages.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

Future<File?> pickImageFromGallery(BuildContext context) async {
  try {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) {
      return null;
    }
    final pickedImage = File(image.path);
    return pickedImage;
  } catch (e) {
    showToast(context: context, message: e.toString());
    debugPrint(e.toString());
  }
}
