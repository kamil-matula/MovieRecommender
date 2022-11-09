import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:movie_recommender/constants/constant_texts.dart';
import 'package:movie_recommender/constants/constant_typography.dart';
import 'package:movie_recommender/view/auth_page/cubit/auth_page_type_cubit.dart';
import 'package:movie_recommender/view/widgets/custom_button.dart';
import 'package:movie_recommender/view/widgets/input_field.dart';

class LoginPageContent extends StatefulWidget {
  const LoginPageContent({Key? key}) : super(key: key);

  @override
  State<LoginPageContent> createState() => _LoginPageContentState();
}

class _LoginPageContentState extends State<LoginPageContent> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 100),
        const Text(
          SIGN_IN,
          style: AUTH_TITLE_TEXT_STYLE,
        ),
        const SizedBox(height: 100),
        CustomInputField(controller: emailController, labelText: EMAIL),
        const SizedBox(height: 20),
        CustomInputField(
          controller: passwordController,
          obscureText: true,
          labelText: PASSWORD,
        ),
        const SizedBox(height: 20),
        CustomButton(
          text: SIGN_IN,
          onPressed: _signIn,
        ),
        TextButton(
          onPressed: context.read<AuthPageTypeCubit>().goToRegisterPage,
          child: const Text(USER_DOES_NOT_HAVE_AN_ACCOUNT),
        ),
      ],
    );
  }

  Future<void> _signIn() async {
    // Basic frontend validation:
    if (emailController.text.isEmpty) {
      Fluttertoast.showToast(msg: EMPTY_EMAIL, backgroundColor: Colors.grey);
      return;
    }
    if (passwordController.text.isEmpty) {
      Fluttertoast.showToast(msg: EMPTY_PASSWORD, backgroundColor: Colors.grey);
      return;
    }

    // Request to Firebase:
    String email = emailController.text;
    String password = passwordController.text;
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .catchError(_onLoginError);
  }

  FutureOr<UserCredential> _onLoginError(Object err, StackTrace st) async {
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
}
