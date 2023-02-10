import 'package:chatwith/features/auth/controller/auth_controller.dart';
import 'package:chatwith/features/landing/screens/landing_screen.dart';
import 'package:chatwith/firebase_options.dart';
import 'package:chatwith/responsive/responsive_layout.dart';
import 'package:chatwith/screens/mobile_screen_layout.dart';
import 'package:chatwith/screens/web_screen_layout.dart';
import 'package:chatwith/utils/colors.dart';
import 'package:chatwith/utils/router.dart';
import 'package:chatwith/utils/widgets/error.dart';
import 'package:chatwith/utils/widgets/loader.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ChatWith',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: c131C21,
          appBarTheme: const AppBarTheme(
            backgroundColor: c304450,
            elevation: 0,
          ),
        ),
        onGenerateRoute: (routeSettings) => generateoute(routeSettings),
        home: ref.watch(userDataAuthProvider).when(
              data: (user) {
                if (user == null) {
                  return const LandingScreen();
                } else {
                  return const ResponsiveLayout(
                      mobileScreenLayout: MobileScreenLayout(),
                      webScreenLayout: WebScreenLayout());
                }
              },
              error: (err, trace) {
                return ErrorScreen(message: err.toString());
              },
              loading: () => const Loader(),
            ));
  }
}
