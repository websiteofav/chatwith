import 'package:agora_uikit/agora_uikit.dart';
import 'package:chatwith/features/call/models/call.dart';
import 'package:chatwith/utils/environment.dart';
import 'package:chatwith/utils/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CallScreen extends ConsumerStatefulWidget {
  static const routeName = '/call';
  final String channelId;
  final Call call;
  final bool isGroupChat;
  const CallScreen(
      {super.key,
      required this.channelId,
      required this.call,
      required this.isGroupChat});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CallScreenState();
}

class _CallScreenState extends ConsumerState<CallScreen> {
  final baseUrl = Environment.goServerUrl;

  AgoraClient? _client;

  @override
  void initState() {
    _client = AgoraClient(
        agoraConnectionData: AgoraConnectionData(
            appId: Environment.agoraAppId,
            channelName: widget.channelId,
            tokenUrl: baseUrl));
    initializeAgora();
    super.initState();
  }

  void initializeAgora() async {
    await _client?.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _client == null
          ? const Loader()
          : SafeArea(
              child: Stack(
                children: [
                  AgoraVideoViewer(client: _client!),
                  AgoraVideoButtons(client: _client!),
                ],
              ),
            ),
    );
  }
}
