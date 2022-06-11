import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:mynotes/firebase_options.dart';

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
                      child: const Text('Register'),
                      onPressed: () async {
                        final email = _email.text;
                        final password = _password.text;
                        try {
                          final userCredential = await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                                  email: email, password: password);
                          print(userCredential);
                        } on FirebaseException catch (e) {
                          print(e);
                          if (e.code == 'email-already-in-use') {
                            print('hello');
                          } else if (e.code == 'weak-password') {
                            print('Try a more complex password');
                          } else if (e.code == 'invalid-email') {
                            print('Invalid email entered');
                          }
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
