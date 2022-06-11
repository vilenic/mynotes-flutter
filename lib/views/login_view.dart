import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mynotes/firebase_options.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
        title: const Text('Login'),
      ),
      body: FutureBuilder(
          future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          ),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return Column(
                  children: [
                    TextField(
                      decoration:
                          const InputDecoration(hintText: 'Enter email here'),
                      enableSuggestions: false, // no suggestions above keyboard
                      autocorrect: false, // no autocorrection while typing
                      keyboardType: TextInputType.emailAddress,
                      controller: _email,
                    ),
                    TextField(
                      decoration: const InputDecoration(
                          hintText: 'Enter password here'),
                      obscureText: true, // replace input with asteriks'
                      enableSuggestions: false,
                      autocorrect: false,
                      controller: _password,
                    ),
                    TextButton(
                      child: const Text('Login'),
                      onPressed: () async {
                        final email = _email.text;
                        final password = _password.text;
                        try {
                          final userCredential = await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  email: email, password: password);
                          print(userCredential);
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'user-not-found') {
                            print('user not found!');
                          } else if (e.code == 'wrong-password') {
                            print('Wrong password');
                          }
                        } catch (e) {
                          print('Error!');
                          print(e.runtimeType);
                          print(e);
                        }
                      },
                    ),
                  ],
                );
              default:
                return const Text('Loading');
            }
          }),
    );
  }
}
