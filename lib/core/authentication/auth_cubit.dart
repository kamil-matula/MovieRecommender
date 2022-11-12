import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:movie_recommender/constants/texts.dart';
import 'package:movie_recommender/core/authentication/auth_service.dart';

/// Cubit responsible for signing in, up and off.
class AuthCubit extends Cubit<bool> {
  StreamSubscription<bool>? _userAuthStateSub;

  AuthCubit() : super(false) {
    _userAuthStateSub = _initUserAuthStateSubscription();
  }

  /// Initializes user auth state listener.
  StreamSubscription<bool> _initUserAuthStateSubscription() {
    return AuthService.isUserAuthenticated().listen(emit);
  }

  /// Logs user in with provided email and password.
  Future<void> signIn(String email, String password) async {
    // Basic frontend validation:
    if (email.isEmpty) {
      Fluttertoast.showToast(msg: EMPTY_EMAIL, backgroundColor: Colors.grey);
      return;
    }
    if (password.isEmpty) {
      Fluttertoast.showToast(msg: EMPTY_PASSWORD, backgroundColor: Colors.grey);
      return;
    }

    // Request to Firebase:
    AuthService.signIn(email, password).catchError(_onFirebaseError);
  }

  /// Registers user in with provided email and password.
  Future<void> signUp(
    String email,
    String password,
    String repeatedPassword,
  ) async {
    if (email.isEmpty) {
      Fluttertoast.showToast(msg: EMPTY_EMAIL, backgroundColor: Colors.grey);
      return;
    }
    if (password.isEmpty) {
      Fluttertoast.showToast(msg: EMPTY_PASSWORD, backgroundColor: Colors.grey);
      return;
    }
    if (repeatedPassword != password) {
      Fluttertoast.showToast(msg: WRONG_REPEATED, backgroundColor: Colors.grey);
      return;
    }

    // Request to Firebase:
    AuthService.signUp(email, password).catchError(_onFirebaseError);
  }

  /// Signs user out.
  Future<void> signOut() async => AuthService.signOut();

  /// Shows toast if request to Firebase failed.
  FutureOr<UserCredential> _onFirebaseError(Object err, StackTrace st) async {
    if (err is FirebaseAuthException && err.message != null) {
      // Remove dot from the end of message:
      String msg = err.message!.endsWith('.')
          ? err.message!.substring(0, err.message!.length - 1)
          : err.message!;
      Fluttertoast.showToast(msg: msg, backgroundColor: Colors.grey);
    } else {
      Fluttertoast.showToast(msg: TRY_AGAIN, backgroundColor: Colors.grey);
    }
    return Future.error(err);
  }

  @override
  Future<void> close() {
    _userAuthStateSub?.cancel();
    return super.close();
  }
}
