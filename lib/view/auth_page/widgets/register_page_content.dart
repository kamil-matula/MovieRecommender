import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_recommender/view/auth_page/cubit/auth_page_type_cubit.dart';
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
        const SizedBox(height: 40),
        const Text('Register Page'),
        const SizedBox(height: 20),
        CustomInputField(controller: emailController),
        const SizedBox(height: 20),
        CustomInputField(
          controller: passwordController,
          obscureText: true,
        ),
        const SizedBox(height: 20),
        CustomInputField(
          controller: repeatedPasswordController,
          obscureText: true,
        ),
        const SizedBox(height: 20),
        ElevatedButton(onPressed: _signUp, child: const Text('Register')),
        TextButton(
          onPressed: context.read<AuthPageTypeCubit>().goToLoginPage,
          child: const Text('Already have an account? Log in'),
        ),
      ],
    );
  }

  Future<void> _signUp() async {
    /// TODO: Add validation and displaying response if something went wrong
    FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    );
  }
}
