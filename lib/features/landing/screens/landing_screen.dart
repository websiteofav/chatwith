import 'package:chatwith/features/auth/screens/login.dart';
import 'package:chatwith/utils/colors.dart';
import 'package:chatwith/utils/images.dart';
import 'package:chatwith/utils/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({Key? key}) : super(key: key);

  void navigateToLogin(BuildContext context) {
    Navigator.of(context).pushNamed(Login.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 50,
              ),
              const Align(
                alignment: Alignment.center,
                child: Text(
                  'Welcome to ChatWith',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: size.height * 0.1,
              ),
              Image.asset(
                Images.fingerprint,
                width: size.width * 0.5,
                height: size.height * 0.5,
                color: c33cc33,
              ),
              SizedBox(
                height: size.height * 0.1,
              ),
              const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  'Terms and Conditions. To accept click on "Agree and Continue""',
                  style: TextStyle(
                    fontSize: 16,
                    color: c747578,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              CustomButton(
                text: 'Agree and Continue',
                onPressed: () => navigateToLogin(context),
                color: coC54BE,
              )
            ],
          ),
        ),
      ),
    );
  }
}
