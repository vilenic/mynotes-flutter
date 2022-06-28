import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/cloud/cloud_storage_constants.dart';
import 'package:mynotes/views/login_view.dart';
import 'package:mynotes/views/notes/create_update_note_view.dart';
import 'package:mynotes/views/notes/notes_view.dart';
import 'package:mynotes/views/register_view.dart';
import 'package:mynotes/views/verify_email_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.orange,
    ),
    home: const HomePage(),
    routes: {
      notesRoute: (context) => const NotesView(),
      loginRoute: (context) => const LoginView(),
      registerRoute: (context) => const RegisterView(),
      verifyEmailRoute: (context) => const VerifyEmailView(),
      createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
    },
  ));
}

/* class HomePage extends StatelessWidget { */
/*   const HomePage({Key? key}) : super(key: key); */
/**/
/*   @override */
/*   Widget build(BuildContext context) { */
/*     return FutureBuilder( */
/*         // FutureBuilder ensures that the future completes before it runs builder and produces a widget */
/*         future: AuthService.firebase().initialize(), */
/*         builder: (context, snapshot) { */
/*           switch (snapshot.connectionState) { */
/*             case ConnectionState.done: */
/*               final user = AuthService.firebase().currentUser; */
/*               if (user != null) { */
/*                 if (user.isEmailVerified) { */
/*                   return const NotesView(); */
/*                 } else { */
/*                   return const VerifyEmailView(); */
/*                 } */
/*               } else { */
/*                 return const LoginView(); */
/*               } */
/*             default: */
/*               return const CircularProgressIndicator(); */
/*           } */
/*         }); */
/*   } */
/* } */

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CounterBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Testing bloc'),
        ),
        body: BlocConsumer<CounterBloc, CounterState>(
          builder: (context, state) {
            final invalidValue = (state is CounterStateInvalidNumber) ? state.invalidValue : '';
            return Column(
              children: [
                Text('Current value => ${state.value}'),
                Visibility(
                  visible: state is CounterStateInvalidNumber,
                  child: Text('Ivalid input: $invalidValue'),
                ),
                TextField(
                  controller: _controller,
                  decoration: const InputDecoration(hintText: 'Enter a number'),
                  keyboardType: TextInputType.number,
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        context.read<CounterBloc>().add(
                              DecrementEvent(_controller.text),
                            );
                      },
                      child: const Text('-'),
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<CounterBloc>().add(
                              IncrementEvent(_controller.text),
                            );
                      },
                      child: const Text('+'),
                    )
                  ],
                )
              ],
            );
          },
          listener: (context, state) {
            _controller.clear();
          },
        ),
      ),
    );
  }
}

@immutable
abstract class CounterState {
  final int value;

  const CounterState(this.value);
}

class CounterStateValid extends CounterState {
  // const constructor says: give me a valid value and I'll call my super class
  const CounterStateValid(int value) : super(value);
}

class CounterStateInvalidNumber extends CounterState {
  final String invalidValue;

  const CounterStateInvalidNumber({
    required this.invalidValue,
    required int previousValue,
  }) : super(previousValue);
}

@immutable
abstract class CounterEvent {
  final String value;

  const CounterEvent(this.value);
}

class IncrementEvent extends CounterEvent {
  const IncrementEvent(String value) : super(value);
}

class DecrementEvent extends CounterEvent {
  const DecrementEvent(String value) : super(value);
}

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(const CounterStateValid(0)) {
    on<IncrementEvent>((event, emit) {
      final integer = int.tryParse(event.value);
      if (integer == null) {
        emit(
          CounterStateInvalidNumber(
            invalidValue: event.value,
            previousValue: state.value, // state is available inside on function in Bloc
          ),
        );
      } else {
        emit(CounterStateValid(state.value + integer));
      }
    });
    on<DecrementEvent>((event, emit) {
      final integer = int.tryParse(event.value);
      if (integer == null) {
        emit(
          CounterStateInvalidNumber(
            invalidValue: event.value,
            previousValue: state.value, // state is available inside on function in Bloc
          ),
        );
      } else {
        emit(CounterStateValid(state.value - integer));
      }
    });
  }
}
