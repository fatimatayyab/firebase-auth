import 'package:flutter/material.dart';
import 'package:testproject/utilities/dialogs/generic_dialog.dart';

Future<void> showCannotShareEmptyNoteDialog(BuildContext context) {
  return showGenericDialog<void>(
    context: context,
    title: 'Sharing',
    content: 'You cannot Share an empty Note',
    optionsBuilder: ()=> {
      'OK' : null,
    },
  );
}
