import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_recommender/view/auth_page/cubit/auth_page_type_cubit.dart';
import 'package:movie_recommender/view/auth_page/widgets/login_page_content.dart';
import 'package:movie_recommender/view/auth_page/widgets/register_page_content.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(), // TODO: Customize it or remove it
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: BlocBuilder<AuthPageTypeCubit, AuthPageType>(
          builder: (_, pageType) {
            return pageType == AuthPageType.Login
                ? const LoginPageContent()
                : const RegisterPageContent();
          },
        ),
      ),
    );
  }
}
