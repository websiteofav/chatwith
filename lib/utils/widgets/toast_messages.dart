import 'package:chatwith/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToast({
  required BuildContext context,
  message,
  toastColor = cff0000,
  duration = 2,
  ToastGravity toastGravity = ToastGravity.BOTTOM,
  fontSize = 20,
  backgroundColor = black,
}) {
  final fToast = FToast();
  fToast.init(context);

  if (message != null) {
    final Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: Text(message,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: toastColor,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          )),
    );

    fToast.showToast(
      child: toast,
      gravity: toastGravity,
      toastDuration: Duration(seconds: duration),
    );
  }
}
