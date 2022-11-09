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

class RegisterPageContent extends StatefulWidget {
  const RegisterPageContent({Key? key}) : super(key: key);

  @override
  State<RegisterPageContent> createState() => _RegisterPageContentState();
}

class _RegisterPageContentState extends State<RegisterPageContent> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController repeatedPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 100),
        const Text(
          SIGN_UP,
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
        CustomInputField(
          controller: repeatedPasswordController,
          obscureText: true,
          labelText: REPEAT_PASSWORD,
        ),
        const SizedBox(height: 20),
        CustomButton(
          text: SIGN_UP,
          onPressed: _signUp,
        ),
        TextButton(
          onPressed: context.read<AuthPageTypeCubit>().goToLoginPage,
          child: const Text(USER_HAS_AN_ACCOUNT),
        ),
      ],
    );
  }

  Future<void> _signUp() async {
    // Basic frontend validation:
    if (emailController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: EMPTY_EMAIL,
        backgroundColor: Colors.grey,
      );
      return;
    }
    if (passwordController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: EMPTY_PASSWORD,
        backgroundColor: Colors.grey,
      );
      return;
    }
    if (repeatedPasswordController.text != passwordController.text) {
      Fluttertoast.showToast(
        msg: DIFFERENT_REPEATED,
        backgroundColor: Colors.grey,
      );
      return;
    }

    // Request to Firebase:
    String email = emailController.text;
    String password = passwordController.text;
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
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
