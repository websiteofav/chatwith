import 'dart:io';

import 'package:chatwith/features/status/controller/status_controller.dart';
import 'package:chatwith/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConfirmStatus extends ConsumerWidget {
  static const routeName = '/confirmStatus';
  final File imageFile;
  const ConfirmStatus({super.key, required this.imageFile});

  void addStatus(BuildContext context, WidgetRef ref) {
    ref.read(statusControllerProvider).addStatus(
          context: context,
          imageFile: imageFile,
        );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        body: Center(
          child: AspectRatio(
            aspectRatio: 9 / 16,
            child: Image.file(imageFile),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => addStatus(context, ref),
          backgroundColor: coC54BE,
          child: const Icon(Icons.send, color: cffffff),
        ));
  }
}
