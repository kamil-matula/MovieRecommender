import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_recommender/view/auth_page/auth_page.dart';
import 'package:movie_recommender/view/auth_page/cubit/auth_page_type_cubit.dart';
import 'package:movie_recommender/view/main_page/cubit/bottom_nav_bar_cubit.dart';
import 'package:movie_recommender/view/main_page/main_page.dart';

// TODO: Refactor it so that there will be two real pages instead of one
class NavigationManager extends StatelessWidget {
  const NavigationManager({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (_, snapshot) => snapshot.hasData ? _mainPage() : _authPage(),
    );
  }

  Widget _mainPage() {
    return BlocProvider(
      create: (_) => BottomNavBarCubit(),
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
