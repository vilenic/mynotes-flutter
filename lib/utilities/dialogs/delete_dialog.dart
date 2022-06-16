import 'package:flutter/material.dart';
import 'package:mynotes/utilities/dialogs/generic_dialog.dart';

Future<bool> showDeleteDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Delete',
    content: 'Are you sure you want to delete the note?',
    optionsBuilder: () => {
      'Cancel': false,
      'Yes': true,
    },
  ).then(
    // Future has to return a bool. Guarding against a platform (android, for instance),
    // where you could dismiss a dialog by pressing a back hardware button.
    (value) => value ?? false,
  );
}
