import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:movie_recommender/constants/constant_texts.dart';
import 'package:movie_recommender/constants/constant_typography.dart';
import 'package:movie_recommender/view/widgets/custom_button.dart';
import 'package:movie_recommender/view/widgets/input_field.dart';

class MyAccount extends StatefulWidget {
  const MyAccount({Key? key}) : super(key: key);

  @override
  State<MyAccount> createState() => _MyAccount();
}

class _MyAccount extends State<MyAccount> {
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController repeatPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(MY_ACCOUNT),
      ),
      body: _body(context),
    );
  }

  Widget _body(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            CHANGE_PASSWORD,
            style: CHANGE_PASSWORD_STYLE,
          ),
          const SizedBox(height: 30),
          CustomInputField(
            controller: currentPasswordController,
            obscureText: true,
            labelText: CURRENT_PASSWORD,
          ),
          const SizedBox(height: 20),
          CustomInputField(
            controller: newPasswordController,
            obscureText: true,
            labelText: NEW_PASSWORD,
          ),
          const SizedBox(height: 20),
          CustomInputField(
            controller: repeatPasswordController,
            obscureText: true,
            labelText: REPEAT_PASSWORD,
          ),
          const SizedBox(height: 30),
          CustomButton(
            onPressed: _changePassword,
            text: CHANGE_PASSWORD,
          ),
        ],
      ),
    );
  }

  Future<void> _changePassword() async {
    final user = auth.FirebaseAuth.instance.currentUser;
    String email = auth.FirebaseAuth.instance.currentUser?.email ?? '';
    final cred = EmailAuthProvider.credential(
      email: email,
      password: currentPasswordController.text,
    );

    user?.reauthenticateWithCredential(cred).then((value) {
      if (newPasswordController.text == repeatPasswordController.text) {
        user.updatePassword(newPasswordController.text).then((_) {
          Fluttertoast.showToast(
            msg: PASSWORD_CHANGE,
            backgroundColor: Colors.grey,
          );
        }).catchError((error) {
          Fluttertoast.showToast(
            msg: TRY_AGAIN,
            backgroundColor: Colors.grey,
          );
        });
      } else {
        Fluttertoast.showToast(
          msg: NEW_DIFFERENT_REPEAT,
          backgroundColor: Colors.grey,
        );
      }
    }).catchError((err) {
      Fluttertoast.showToast(
        msg: PASSWORD_NOT_MATCH,
        backgroundColor: Colors.grey,
      );
    });
  }
}
