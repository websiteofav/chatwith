import 'dart:io';

import 'package:chatwith/features/auth/models/user_model.dart';
import 'package:chatwith/features/auth/screens/login.dart';
import 'package:chatwith/features/auth/screens/otp.dart';
import 'package:chatwith/features/auth/screens/user_detail.dart';
import 'package:chatwith/features/call/screens/call.dart';
import 'package:chatwith/features/contacts/screens/contacts.dart';
import 'package:chatwith/features/group/screens/create_group.dart';
import 'package:chatwith/features/status/models/status_model.dart';
import 'package:chatwith/features/status/screens/confirm_status.dart';
import 'package:chatwith/features/status/screens/status.dart';
import 'package:chatwith/utils/widgets/error.dart';
import 'package:chatwith/features/chat/screens/mobile_chat_screen.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case Login.routeName:
      return MaterialPageRoute(builder: (context) => const Login());

    case OTP.routeName:
      final verficationId = routeSettings.arguments as String;
      return MaterialPageRoute(
          builder: (context) => OTP(
                verificationId: verficationId,
              ));

    case UserDetail.routeName:
      return MaterialPageRoute(builder: (context) => const UserDetail());

    case Contacts.routeName:
      return MaterialPageRoute(builder: (context) => const Contacts());

    case MobileChatScreen.routeName:
      final argument = routeSettings.arguments as Map<String, dynamic>;
      final userModel = argument['userModel'];
      final isGroupChat = argument['isGroupChat'];
      return MaterialPageRoute(
          builder: (context) => MobileChatScreen(
                userModel: userModel,
                isGroupChat: isGroupChat,
              ));

    case ConfirmStatus.routeName:
      final imageFile = routeSettings.arguments as File;
      return MaterialPageRoute(
          builder: (context) => ConfirmStatus(
                imageFile: imageFile,
              ));
    case StatusScreen.routeName:
      final status = routeSettings.arguments as Status;
      return MaterialPageRoute(
          builder: (context) => StatusScreen(
                status: status,
              ));
    case CreateGroup.routeName:
      return MaterialPageRoute(builder: (context) => const CreateGroup());
    case CallScreen.routeName:
      final argument = routeSettings.arguments as Map<dynamic, dynamic>;
      final channelId = argument['channelId'];
      final call = argument['call'];
      final isGroupChat = argument['isGroupChat'];

      return MaterialPageRoute(
          builder: (context) => CallScreen(
                call: call,
                channelId: channelId,
                isGroupChat: isGroupChat,
              ));
    default:
      return MaterialPageRoute(
        builder: (context) => Scaffold(
          body: ErrorScreen(
            message: 'No route defined for ${routeSettings.name}',
          ),
        ),
      );
  }
}
