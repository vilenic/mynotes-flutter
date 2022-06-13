import 'package:flutter/material.dart';

import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/utilities/show_error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Column(
        children: [
          TextField(
            decoration: const InputDecoration(hintText: 'Enter email here'),
            enableSuggestions: false, // no suggestions above keyboard
            autocorrect: false, // no autocorrection while typing
            keyboardType: TextInputType.emailAddress,
            controller: _email,
          ),
          TextField(
            decoration: const InputDecoration(hintText: 'Enter password here'),
            obscureText: true, // replace input with asteriks'
            enableSuggestions: false,
            autocorrect: false,
            controller: _password,
          ),
          TextButton(
            child: const Text('Register'),
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              final navigator = Navigator.of(context);
              if (email.isEmpty || password.isEmpty) {
                await showErrorDialog(context, 'Please fill in all fields!');
                return;
              }
              try {
                final authService = AuthService.firebase();
                await authService.createUser(
                  email: email,
                  password: password,
                );
                await authService
                    .sendEmailVerification(); // Automatically send verification email
                navigator.pushNamed(verifyEmailRoute);
              } on EmailAlreadyInUseAuthException {
                await showErrorDialog(
                  context,
                  'Email is already in use',
                );
              } on WeakPasswordAuthException {
                await showErrorDialog(
                  context,
                  'Password is too simple',
                );
              } on InvalidEmailAuthException {
                await showErrorDialog(
                  context,
                  'Email is invalid',
                );
              } on GenericAuthException {
                await showErrorDialog(
                  context,
                  'Registration error',
                );
              } catch (e) {
                await showErrorDialog(
                  context,
                  'Error: ${e.toString()}',
                );
              }
            },
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                loginRoute,
                (route) => false,
              );
            },
            child: const Text('Already registered? Log in here!'),
          )
        ],
      ),
    );
  }
}
