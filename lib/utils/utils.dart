import 'dart:io';

import 'package:chatwith/utils/environment.dart';
import 'package:chatwith/utils/widgets/toast_messages.dart';
import 'package:enough_giphy_flutter/enough_giphy_flutter.dart';
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
    rethrow;
  }
}

Future<File?> pickVideoFromGallery(BuildContext context) async {
  try {
    final video = await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (video == null) {
      return null;
    }
    final pickedVideo = File(video.path);
    return pickedVideo;
  } catch (e) {
    showToast(context: context, message: e.toString());
    debugPrint(e.toString());
    rethrow;
  }
}

Future<GiphyGif?> pickGIF(BuildContext context) async {
  try {
    GiphyGif? gif =
        await Giphy.getGif(context: context, apiKey: Environment.giphyKey);

    return gif;
  } catch (e) {
    showToast(context: context, message: e.toString());
    debugPrint(e.toString());
    rethrow;
  }
}
