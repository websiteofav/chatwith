import 'package:chatwith/features/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';

import 'package:chatwith/utils/colors.dart';
import 'package:chatwith/utils/widgets/custom_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OTP extends ConsumerWidget {
  static const routeName = '/otp';
  final String verificationId;
  const OTP({Key? key, required this.verificationId}) : super(key: key);

  void verifyOtp(
      {required BuildContext context,
      required String otp,
      required WidgetRef ref}) {
    ref
        .read(authControllerProvider)
        .verifyOtp(verficationId: verificationId, otp: otp, context: context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: c131C21,
          title: const Text(
            'Verify your Mobile Number',
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 50,
            ),
            const Align(
              alignment: Alignment.center,
              child: Text(
                'Enter the 6 digit code sent to your mobile number',
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              width: size.width * 0.5,
              child: TextField(
                onChanged: (value) {
                  if (value.length == 6) {
                    verifyOtp(context: context, otp: value, ref: ref);
                  }
                },
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 30),
                decoration: const InputDecoration(
                  hintText: 'Enter the 6 digit code',
                  hintStyle: TextStyle(fontSize: 15),
                ),
              ),
            ),
            // const SizedBox(
            //   height: 20,
            // ),
            // CustomButton(
            //   color: c33cc33,
            //   text: 'Verify',
            //   onPressed: () {
            //     Navigator.of(context).pushNamed('/home');
            //   },
            // )
          ],
        ));
  }
}
