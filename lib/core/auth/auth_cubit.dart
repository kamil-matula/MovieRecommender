// ignore_for_file: prefer_void_to_null

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:movie_recommender/constants/texts.dart';
import 'package:movie_recommender/core/auth/auth_service.dart';
import 'package:movie_recommender/core/enum/auth_enum.dart';

/// Cubit responsible for signing in, up and off.
class AuthCubit extends Cubit<bool> {
  StreamSubscription<bool>? _userAuthStateSub;

  AuthCubit({bool isTest = false}) : super(false) {
    if (isTest) return;
    _userAuthStateSub = _initUserAuthStateSubscription();
  }

  /// Initializes user auth state listener.
  StreamSubscription<bool> _initUserAuthStateSubscription() {
    return AuthService.isUserAuthenticated().listen(emit);
  }

  /// Checks provided data and displays Toasts if something is wrong
  /// or signs in/up.
  Future<void> handleLoginDetails(
    String email,
    String password, {
    String repeatedPassword = '',
  }) async {
    // Basic frontend validation:
    switch (checkIfDataIsCorrect(
      email,
      password,
      repeatedPassword: repeatedPassword,
    )) {
      case AuthEnum.EMPTY_EMAIL:
        return _displayToast(EMPTY_EMAIL);
      case AuthEnum.EMPTY_PASSWORD:
        return _displayToast(EMPTY_PASSWORD);
      case AuthEnum.WRONG_REPEATED_PASSWORD:
        return _displayToast(WRONG_REPEATED);
      case AuthEnum.CORRECT_INPUT:
        if (repeatedPassword == '') {
          // Logs user in with provided email and password.
          AuthService.signIn(email, password).catchError(
            _onFirebaseError<UserCredential>,
          );
        } else {
          // Registers user in with provided email and password.
          AuthService.signUp(email, password).catchError(
            _onFirebaseError<UserCredential>,
          );
        }
        break;
    }
  }

  /// Checks if provided email, password and repeated passwords are correct.
  AuthEnum checkIfDataIsCorrect(
    String email,
    String password, {
    String repeatedPassword = '',
  }) {
    if (email.isEmpty) return AuthEnum.EMPTY_EMAIL;
    if (password.isEmpty) return AuthEnum.EMPTY_PASSWORD;
    if (password != repeatedPassword) return AuthEnum.WRONG_REPEATED_PASSWORD;
    return AuthEnum.CORRECT_INPUT;
  }

  /// Signs user out.
  Future<void> signOut() async => AuthService.signOut();

  /// Changes current user's password.
  /// Returns boolean which says if everything went fine.
  Future<bool> changePassword(
    String currentPassword,
    String newPassword,
    String repeatedPassword,
  ) async {
    // Basic frontend validation:
    if (currentPassword.isEmpty) {
      _displayToast(EMPTY_PASSWORD);
      return false;
    }
    if (newPassword.isEmpty) {
      _displayToast(EMPTY_NEW_PASSWORD);
      return false;
    }
    if (repeatedPassword != newPassword) {
      _displayToast(WRONG_REPEATED);
      return false;
    }
    if (FirebaseAuth.instance.currentUser == null) {
      _displayToast(TRY_AGAIN);
      return false;
    }

    // Validate provided password with Firebase:
    final User? user = FirebaseAuth.instance.currentUser;
    try {
      final AuthCredential cred = EmailAuthProvider.credential(
        email: user?.email ?? '',
        password: currentPassword,
      );
      await user?.reauthenticateWithCredential(cred);
    } catch (e, st) {
      _onFirebaseError<Null>(e, st);
      return false;
    }

    // Update password with Firebase:
    try {
      await user?.updatePassword(newPassword);
    } catch (e, st) {
      _onFirebaseError<Null>(e, st);
      return false;
    }

    _displayToast(PASSWORD_CHANGED);
    return true;
  }

  Future<bool> deleteAccount() async {
    try {
      await FirebaseAuth.instance.currentUser?.delete();
      return true;
    } catch (e, st) {
      _onFirebaseError<Null>(e, st);
      return false;
    }
  }

  /// Shows toast if request to Firebase failed.
  FutureOr<T> _onFirebaseError<T>(Object err, StackTrace st) async {
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

  /// Shows grey toast at the bottom of the screen.
  Future<void> _displayToast(String msg) async {
    Fluttertoast.showToast(msg: msg, backgroundColor: Colors.grey);
  }

  @override
  Future<void> close() {
    _userAuthStateSub?.cancel();
    return super.close();
  }
}
