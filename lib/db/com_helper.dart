// ignore_for_file: file_names, non_constant_identifier_names

import 'package:api_local_db/db/navigator_key.dart';
import 'package:flutter/material.dart';

alertDialog(String msg) {
  //Toast.show(msg, context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
  //Toast.show(msg, duration: Toast.lengthShort, gravity: Toast.bottom);
  showAlertDialog(NavigatorKey.navigatorKey.currentContext!, msg);
}

showAlertDialog(BuildContext context, String msg) {
  // set up the button
  Widget okButton = TextButton(
    child: const Text("OK"),
    onPressed: () {
      Navigator.pop(context);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text("ALERT!"),
    content: Text(msg),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

///EmailValidation
validateEmail(String email) {
  final emailReg = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  return emailReg.hasMatch(email);
}

///PhoneValidation
validatePhone(String phone) {
  final phoneReg = RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)');
  return phoneReg.hasMatch(phone);
}

///PasswordValidation
validatePassword(String password) {
  final PassReg =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$&*~]).{8,}$');
  return PassReg.hasMatch(password);
}
