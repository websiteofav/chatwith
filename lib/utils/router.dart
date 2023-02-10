import 'package:chatwith/features/auth/models/user_model.dart';
import 'package:chatwith/features/auth/screens/login.dart';
import 'package:chatwith/features/auth/screens/otp.dart';
import 'package:chatwith/features/auth/screens/user_detail.dart';
import 'package:chatwith/features/contacts/screens/contacts.dart';
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
      final userModel = routeSettings.arguments as UserModel;
      return MaterialPageRoute(
          builder: (context) => MobileChatScreen(
                userModel: userModel,
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
