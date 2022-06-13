import 'package:firebase_auth/firebase_auth.dart' as firebase show User;
import 'package:flutter/foundation.dart';

@immutable // No fields will change after initialization
class AuthUser {
  final bool isEmailVerified;

  const AuthUser({required this.isEmailVerified});

  // Takes a Firebase User instance and constructs an AuthUser
  // with emailVerified status from Firebase User
  factory AuthUser.fromFirebase(firebase.User user) =>
      AuthUser(isEmailVerified: user.emailVerified);
}
