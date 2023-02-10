import 'dart:io';

import 'package:chatwith/features/auth/models/user_model.dart';
import 'package:chatwith/features/auth/repository/auth_repository.dart';
import 'package:chatwith/utils/widgets/toast_messages.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authControllerProvider = Provider<AuthController>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthController(authRepository: authRepository, ref: ref);
});

final userDataAuthProvider = FutureProvider<UserModel?>((ref) {
  final authController = ref.watch(authControllerProvider);
  return authController.getCurrentUserData();
});

class AuthController {
  final AuthRepository authRepository;

  final ProviderRef ref;

  AuthController({required this.authRepository, required this.ref});

  Future<UserModel?> getCurrentUserData() async {
    UserModel? userModel = await authRepository.getCurrentUser();
    return userModel;
  }

  void signInWithPhoneNumber(
      {required String phoneNumber, required BuildContext context}) {
    authRepository.signInWithPhoneNumber(
        phoneNumber: phoneNumber, context: context);
  }

  void verifyOtp(
      {required String verficationId,
      required String otp,
      required BuildContext context}) {
    authRepository.verifyOtp(
        verificationId: verficationId, otp: otp, context: context);
  }

  void saveUserdataToFirebase(
      {required String name,
      required String email,
      required String bio,
      required File? profilePic,
      required BuildContext context}) {
    authRepository.saveUserDataToFirebase(
      name: name,
      emailId: email,
      profilePic: profilePic,
      context: context,
      bio: bio,
      ref: ref,
    );
  }

  Stream<UserModel> getUserDataById(String uid) {
    return authRepository.getUserData(uid);
  }

  void updateUserOnlineStatus(bool isOnline) {
    authRepository.setUserOnlineStatus(isOnline);
  }
}
