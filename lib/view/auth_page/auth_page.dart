import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_recommender/constants/constant_colors.dart';
import 'package:movie_recommender/view/auth_page/cubit/auth_page_type_cubit.dart';
import 'package:movie_recommender/view/auth_page/widgets/login_page_content.dart';
import 'package:movie_recommender/view/auth_page/widgets/register_page_content.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: STATUS_BAR_COLOR,
      ),
    );
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: BlocBuilder<AuthPageTypeCubit, AuthPageType>(
              builder: (_, pageType) {
                return pageType == AuthPageType.Login
                    ? const LoginPageContent()
                    : const RegisterPageContent();
              },
            ),
          ),
        ),
      ),
    );
  }
}
