import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_recommender/constants/texts.dart';
import 'package:movie_recommender/constants/typography.dart';
import 'package:movie_recommender/core/auth/auth_cubit.dart';
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
        const Text(SIGN_IN, style: CustomTypography.h1),
        const SizedBox(height: 100),
        CustomInputField(
          key: const Key('login_page_email_field'),
          controller: emailController,
          labelText: EMAIL,
        ),
        const SizedBox(height: 20),
        CustomInputField(
          key: const Key('login_page_password_field'),
          controller: passwordController,
          obscureText: true,
          labelText: PASSWORD,
        ),
        const SizedBox(height: 20),
        CustomButton(
          key: const Key('login_page_sign_in_button'),
          onPressed: () async {
            AuthCubit authCubit = context.read<AuthCubit>();
            authCubit.signIn(emailController.text, passwordController.text);
          },
          text: SIGN_IN,
        ),
        TextButton(
          onPressed: context.read<AuthPageTypeCubit>().goToRegisterPage,
          child: const Text(USER_DOES_NOT_HAVE_AN_ACCOUNT),
        ),
      ],
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
