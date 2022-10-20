import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_recommender/view/auth_page/cubit/auth_page_type_cubit.dart';
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
        const SizedBox(height: 40),
        const Text('Login Page'),
        const SizedBox(height: 20),
        CustomInputField(controller: emailController),
        const SizedBox(height: 20),
        CustomInputField(controller: passwordController, obscureText: true),
        const SizedBox(height: 20),
        ElevatedButton(onPressed: _signIn, child: const Text('Log in')),
        TextButton(
          onPressed: context.read<AuthPageTypeCubit>().goToRegisterPage,
          child: const Text('Don`t have an account? Register'),
        ),
      ],
    );
  }

  Future<void> _signIn() async {
    /// TODO: Add validation and displaying response if something went wrong
    FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    );
  }
}
