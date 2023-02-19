import 'dart:io';

import 'package:chatwith/features/auth/controller/auth_controller.dart';
import 'package:chatwith/features/status/models/status_model.dart';
import 'package:chatwith/features/status/repository/status_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final statusControllerProvider = Provider<StatusController>((ref) {
  final statusRepository = ref.read(statusRepositoryProvider);
  return StatusController(
    statusRepository: statusRepository,
    ref: ref,
  );
});

class StatusController {
  final StatusRepository statusRepository;
  final ProviderRef ref;

  StatusController({required this.statusRepository, required this.ref});

  void addStatus({
    required File imageFile,
    required BuildContext context,
  }) {
    ref.watch(userDataAuthProvider).whenData((value) =>
        statusRepository.updateStatus(
            context: context,
            imageFile: imageFile,
            mobileNumber: value!.mobileNumber,
            profilePic: value.profilePic,
            username: value.name));
  }

  Future<List<Status>> getAllStatus(BuildContext context) async {
    return await ref.read(statusRepositoryProvider).getAllStatus(context);
  }
}
