import 'dart:io';

import 'package:chatwith/features/auth/models/user_model.dart';
import 'package:chatwith/features/auth/screens/otp.dart';
import 'package:chatwith/features/auth/screens/user_detail.dart';
import 'package:chatwith/firebase/repository/firebase_storage.dart';
import 'package:chatwith/responsive/responsive_layout.dart';
import 'package:chatwith/screens/mobile_screen_layout.dart';
import 'package:chatwith/screens/web_screen_layout.dart';
import 'package:chatwith/utils/images.dart';
import 'package:chatwith/utils/widgets/toast_messages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final firebaseAuth = FirebaseAuth.instance;
  final firebaseFirestore = FirebaseFirestore.instance;
  return AuthRepository(
      firebaseAuth: firebaseAuth,
      firebaseFirestore: firebaseFirestore,
      mounted: true);
});

class AuthRepository {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;
  bool mounted;

  AuthRepository(
      {required this.firebaseAuth,
      required this.firebaseFirestore,
      required this.mounted});

  Future<UserModel?> getCurrentUser() async {
    try {
      final user = firebaseAuth.currentUser;
      if (user != null) {
        final userData = await firebaseFirestore
            .collection('users')
            .doc(user.uid)
            .get()
            .then((value) => UserModel.fromJson(value.data()!));
        return userData;
      }
      return null;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  void signInWithPhoneNumber(
      {required String phoneNumber, required BuildContext context}) async {
    try {
      await firebaseAuth.verifyPhoneNumber(
          verificationCompleted:
              (PhoneAuthCredential phoneAuthCredential) async {
            await firebaseAuth.signInWithCredential(phoneAuthCredential);
          },
          phoneNumber: phoneNumber,
          verificationFailed: (FirebaseAuthException firebaseAuthException) {
            showToast(context: context, message: firebaseAuthException.message);
          },
          codeSent: (String verificationId, int? token) {
            Navigator.of(context)
                .pushNamed(OTP.routeName, arguments: verificationId);
          },
          codeAutoRetrievalTimeout: (String verificationId) {});
    } catch (e) {
      showToast(context: context, message: e.toString());
      debugPrint(e.toString());
    }
  }

  void verifyOtp(
      {required String otp,
      required String verificationId,
      required BuildContext context}) async {
    try {
      final phoneAuthCredential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: otp);

      await firebaseAuth.signInWithCredential(phoneAuthCredential);
      if (mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          UserDetail.routeName,
          (route) => false,
        );
      }
    } catch (e) {
      showToast(context: context, message: e.toString());
      debugPrint(e.toString());
    }
  }

  void saveUserDataToFirebase(
      {required String name,
      required File? profilePic,
      required String emailId,
      required String bio,
      required ProviderRef ref,
      required BuildContext context}) async {
    try {
      String uid = firebaseAuth.currentUser!.uid;
      String noProfilePic = Images.noProfileImage;
      profilePic = profilePic ?? File(noProfilePic);
      String profilePicUrl = await ref
          .read(firebaseStorageRepositoryProvider)
          .storeFIleToFirebaseStorage(
              file: profilePic, refPath: 'profilePic/$uid', context: context);
      UserModel userModel = UserModel(
        name: name,
        emailId: emailId,
        bio: bio,
        profilePic: profilePicUrl,
        uid: uid,
        groupId: <String>[],
        isOnline: true,
        mobileNumber: firebaseAuth.currentUser!.phoneNumber.toString(),
      );

      await firebaseFirestore
          .collection('users')
          .doc(uid)
          .set(userModel.toJson());

      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const ResponsiveLayout(
                mobileScreenLayout: MobileScreenLayout(),
                webScreenLayout: WebScreenLayout()),
          ),
          (route) => false,
        );
      }
    } catch (e) {
      showToast(context: context, message: e.toString());
      debugPrint(e.toString());
    }
  }

  Stream<UserModel> getUserData(String uid) {
    return firebaseFirestore.collection('users').doc(uid).snapshots().map(
          (event) => UserModel.fromJson(event.data()!),
        );
  }

  void setUserOnlineStatus(bool isOnline) async {
    try {
      await firebaseFirestore
          .collection('users')
          .doc(firebaseAuth.currentUser!.uid)
          .update({'isOnline': isOnline});
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
