import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_recommender/view/main_page/cubit/bottom_nav_bar_cubit.dart';
import 'package:movie_recommender/view/main_page/cubit/permission_cubit.dart';
import 'package:movie_recommender/view/main_page/widgets/admin_movies_tab.dart';
import 'package:movie_recommender/view/main_page/widgets/all_movies_tab.dart';
import 'package:movie_recommender/view/main_page/widgets/my_account.dart';
import 'package:movie_recommender/view/main_page/widgets/my_preferences_tab.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PermissionCubit, bool?>(builder: _body);
  }

  Widget _body(BuildContext context, bool? isAdmin) {
    if (isAdmin == null) {
      return Scaffold(
        appBar: _appBar(context),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (isAdmin) {
      return AdminMoviesTab(appBar: _appBar(context));
    }

    return BlocBuilder<BottomNavBarCubit, int>(
      builder: (_, index) {
        return Scaffold(
          appBar: _appBar(context),
          body: _tab(index),
          bottomNavigationBar: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.question_mark),
                label: 'All Movies',
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
      },
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      actions: [
        IconButton(
          onPressed: FirebaseAuth.instance.signOut,
          icon: const Icon(Icons.logout),
        ),
        IconButton(
          onPressed: () async {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const MyAccount()));
          },
          icon: const Icon(Icons.account_circle),
        ),
      ],
    );
  }

  Widget _tab(int index) {
    return Stack(
      children: [
        Offstage(
          offstage: index != 0,
          child: const AllMoviesTab(),
        ),
        Offstage(
          offstage: index != 1,
          child: const MyPreferencesTab(),
        ),
      ],
    );
  }
}
