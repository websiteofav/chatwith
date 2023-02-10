import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  final String message;
  const ErrorScreen({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Error',
        style: TextStyle(
          color: Colors.red,
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
