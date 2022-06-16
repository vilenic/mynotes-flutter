import 'package:flutter/material.dart';
import 'package:mynotes/utilities/dialogs/generic_dialog.dart';

Future<bool> showLogOutDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: 'Log out',
    content: 'Are you sure you want to log out?',
    optionsBuilder: () => {
      'Cancel': null,
      'Log out': true,
    },
  ).then(
    // Future has to return a bool. Guarding against a platform (android, for instance),
    // where you could dismiss a dialog by pressing a back hardware button.
    (value) => value ?? false,
  );
}
