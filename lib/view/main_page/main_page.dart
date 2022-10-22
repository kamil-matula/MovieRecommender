import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_recommender/view/main_page/cubit/bottom_nav_bar_cubit.dart';
import 'package:movie_recommender/view/main_page/widgets/all_movies_tab.dart';
import 'package:movie_recommender/view/main_page/widgets/my_movies_tab.dart';
import 'package:movie_recommender/view/main_page/widgets/my_preferences_tab.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavBarCubit, int>(builder: _body);
  }

  Widget _body(BuildContext context, int index) {
    return Scaffold(
      // TODO: Customize or remove AppBar
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: FirebaseAuth.instance.signOut,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: _tab(index),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.question_mark),
            label: 'All Movies',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.question_mark),
            label: 'My Movies',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.question_mark),
            label: 'My Preferences',
          ),
        ],
        currentIndex: index,
        onTap: context.read<BottomNavBarCubit>().changeIndex,
      ),
    );
  }
}

Widget _tab(int index) {
  return Stack(
    children: [
      Offstage(
        offstage: index != 0,
        child: AllMoviesTab(),
      ),
      Offstage(
        offstage: index != 1,
        child: const MyMoviesTab(),
      ),
      Offstage(
        offstage: index != 2,
        child: const MyPreferencesTab(),
      ),
    ],
  );
}
