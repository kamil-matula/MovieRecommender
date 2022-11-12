import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_recommender/core/authentication/auth_cubit.dart';
import 'package:movie_recommender/view/auth_page/auth_page.dart';
import 'package:movie_recommender/view/auth_page/cubit/auth_page_type_cubit.dart';
import 'package:movie_recommender/view/main_page/cubit/bottom_nav_bar_cubit.dart';
import 'package:movie_recommender/view/main_page/cubit/permission_cubit.dart';
import 'package:movie_recommender/view/main_page/main_page.dart';

// TODO: Refactor it so that there will be two real pages instead of one
class NavigationManager extends StatelessWidget {
  const NavigationManager({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, bool>(
      builder: (_, state) => state ? _mainPage() : _authPage(),
    );
  }

  Widget _mainPage() {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => BottomNavBarCubit()),
        BlocProvider(create: (_) => PermissionCubit()),
      ],
      child: const MainPage(),
    );
  }

  Widget _authPage() {
    return BlocProvider(
      create: (_) => AuthPageTypeCubit(),
      child: const AuthPage(),
    );
  }
}
