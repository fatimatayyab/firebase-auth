import 'package:flutter/material.dart';
import 'package:testproject/utilities/dialogs/generic_dialog.dart';

Future<void> showPasswordResetSentDialog(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    title: ' PassWord Reset ',
    content: 'Please Check your Email. We have sent you a password reset Link',
    optionsBuilder: () => {
      'Ok' : null,
    },
  );
}
