import 'package:chatwith/features/auth/controller/auth_controller.dart';
import 'package:chatwith/utils/colors.dart';
import 'package:chatwith/utils/widgets/custom_button.dart';
import 'package:chatwith/utils/widgets/toast_messages.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Login extends ConsumerStatefulWidget {
  static const routeName = '/login';
  const Login({Key? key}) : super(key: key);

  @override
  ConsumerState<Login> createState() => _LoginState();
}

class _LoginState extends ConsumerState<Login> {
  final TextEditingController _mobileNumberController = TextEditingController();

  Country? country;
  void pickACountry() {
    showCountryPicker(
        context: context,
        searchAutofocus: true,
        onSelect: (Country ctr) {
          setState(() {
            country = ctr;
          });
        });
  }

  void sendMobileNumber() {
    String mobileNumber = _mobileNumberController.text.trim();

    if (country == null) {
      showToast(
          message: 'Please select your country',
          context: context,
          toastGravity: ToastGravity.CENTER);
      return;
    } else if (mobileNumber.isEmpty) {
      showToast(
          message: 'Please enter your mobile number',
          context: context,
          toastGravity: ToastGravity.CENTER);

      return;
    } else {
      ref.read(authControllerProvider).signInWithPhoneNumber(
          phoneNumber: '+${country!.phoneCode}$mobileNumber', context: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: c131C21,
        title: const Text(
          'Enter your mobile number',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('ChatWith will verify your mobile number'),
            const SizedBox(
              height: 15,
            ),
            TextButton(
                onPressed: pickACountry,
                child: const Text('Select your country')),
            const SizedBox(
              height: 30,
            ),
            Row(
              children: [
                if (country != null) Text('+${country!.phoneCode}'),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  alignment: Alignment.center,
                  width: size.width * 0.7,
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Enter your mobile number',
                    ),
                    controller: _mobileNumberController,
                  ),
                ),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: size.width * 0.5,
              child: CustomButton(
                text: 'Login',
                onPressed: sendMobileNumber,
                color: c33cc33,
              ),
            )
          ],
        ),
      ),
    );
  }
}
