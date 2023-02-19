import 'package:chatwith/features/call/controller/call_controller.dart';
import 'package:chatwith/features/call/models/call.dart';
import 'package:chatwith/features/call/screens/call.dart';
import 'package:chatwith/utils/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CallPickup extends ConsumerWidget {
  final Widget scaffold;
  const CallPickup({super.key, required this.scaffold});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<DocumentSnapshot>(
      stream: ref.watch(callControllerProvider).getCallStreamData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            if (snapshot.data!.exists) {
              Call call =
                  Call.fromJson(snapshot.data!.data()! as Map<String, dynamic>);
              if (!call.hasDialled) {
                return Scaffold(
                  body: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Incoming Call...',
                          style: TextStyle(
                            color: cffffff,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 50),
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(call.callerPic),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          call.callerName,
                          style: const TextStyle(
                            color: coC54BE,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                                onPressed: () => Navigator.of(context)
                                        .pushNamed(CallScreen.routeName,
                                            arguments: {
                                          'channelId': call.callId,
                                          'call': call,
                                          'isGroupChat': false,
                                        }),
                                icon: const Icon(
                                  Icons.call_end,
                                  color: cff0000,
                                  size: 35,
                                )),
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.call,
                                  color: c33cc33,
                                  size: 35,
                                )),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              }
              return scaffold;
            } else {
              return scaffold;
            }
          } else {
            return scaffold;
          }
        } else {
          return scaffold;
        }
      },
    );
  }
}
