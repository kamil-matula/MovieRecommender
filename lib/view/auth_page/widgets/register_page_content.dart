import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_recommender/constants/texts.dart';
import 'package:movie_recommender/constants/typography.dart';
import 'package:movie_recommender/core/auth/auth_cubit.dart';
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
          style: CustomTypography.h1,
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
          onPressed: () async {
            AuthCubit authCubit = context.read<AuthCubit>();
            authCubit.signUp(
              emailController.text,
              passwordController.text,
              repeatedPasswordController.text,
            );
          },
          text: SIGN_UP,
        ),
        TextButton(
          onPressed: context.read<AuthPageTypeCubit>().goToLoginPage,
          child: const Text(USER_HAS_AN_ACCOUNT),
        ),
      ],
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    repeatedPasswordController.dispose();
    super.dispose();
  }
}
