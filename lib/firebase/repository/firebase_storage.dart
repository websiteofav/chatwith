import 'dart:io';

import 'package:chatwith/utils/widgets/toast_messages.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseStorageRepositoryProvider =
    Provider<FirebaseStorageRepository>((ref) => FirebaseStorageRepository(
          firebaseStorage: FirebaseStorage.instance,
        ));

class FirebaseStorageRepository {
  final FirebaseStorage firebaseStorage;

  FirebaseStorageRepository({required this.firebaseStorage});

  Future<String> storeFIleToFirebaseStorage(
      {required File file,
      required String refPath,
      required BuildContext context}) async {
    try {
      final uploadTask =
          firebaseStorage.ref(refPath).putFile(file); // no-profile not working
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      showToast(context: context, message: e.toString());
      debugPrint(e.toString());
      return '';
    }
  }
}
