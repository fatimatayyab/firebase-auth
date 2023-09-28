import 'package:flutter/material.dart';
import 'package:testproject/utilities/dialogs/generic_dialog.dart';

Future<bool> showDeleteDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Delete This Note',
    content: 'Are you sure you want to delete this note?',
    optionsBuilder: () => {
      'Cancel': false,      
      'Yes ' : true, 
    },
  ).then(
    (value) => value ?? false,
    );
}
