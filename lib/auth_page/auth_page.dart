import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_recommender/main_page/cubit/bottom_nav_bar_cubit.dart';
import 'package:movie_recommender/main_page/main_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(), // TODO: Customize it or remove it
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // TODO: Add input fields and buttons
          Center(
            child: ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => BlocProvider(
                      create: (_) => BottomNavBarCubit(),
                      child: const MainPage(),
                    ),
                  ),
                );
              },
              child: const Text('OK'),
            ),
          ),
        ],
      ),
    );
  }
}
