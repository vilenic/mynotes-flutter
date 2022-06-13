import 'package:flutter/material.dart';

import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_service.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    final authService = AuthService.firebase();
    return Scaffold(
      appBar: AppBar(title: const Text('Verify email')),
      body: Column(children: [
        const Text(
          "We've already sent you a verification email. Please open it to verify your account.",
        ),
        const Text(
          "If you haven't received the email verification yet, press the button below:",
        ),
        TextButton(
          onPressed: () async {
            await authService.sendEmailVerification();
          },
          child: const Text('Send email verification again'),
        ),
        TextButton(
          onPressed: () async {
            final navigator = Navigator.of(context);
            await authService.logOut();
            navigator.pushNamedAndRemoveUntil(
              registerRoute,
              (route) => false,
            );
          },
          child: const Text('Restart'),
        )
      ]),
    );
  }
}
