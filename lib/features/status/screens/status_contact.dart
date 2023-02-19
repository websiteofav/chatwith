import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatwith/features/status/controller/status_controller.dart';
import 'package:chatwith/features/status/models/status_model.dart';
import 'package:chatwith/features/status/screens/status.dart';
import 'package:chatwith/utils/colors.dart';
import 'package:chatwith/utils/widgets/error.dart';
import 'package:chatwith/utils/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StatusContact extends ConsumerWidget {
  const StatusContact({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<List<Status>>(
      future: ref.read(statusControllerProvider).getAllStatus(context),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return snapshot.data!.isEmpty
              ? const ErrorScreen(
                  message: 'No Status Found',
                )
              : ListView.separated(
                  separatorBuilder: (context, index) => const Divider(
                    color: cC3B9B9,
                  ),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final status = snapshot.data![index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10, top: 10),
                      child: ListTile(
                        onTap: () => Navigator.of(context).pushNamed(
                          StatusScreen.routeName,
                          arguments: status,
                        ),
                        title: Text(
                          status.username,
                          style: const TextStyle(fontSize: 20),
                        ),
                        leading: CircleAvatar(
                          radius: 35,
                          backgroundImage: CachedNetworkImageProvider(
                            status.profilePic,
                          ),
                        ),
                      ),
                    );
                  },
                );
        } else if (snapshot.hasError) {
          return ErrorScreen(
            message: snapshot.error.toString(),
          );
        } else {
          return const Loader();
        }
      },
    );
  }
}
