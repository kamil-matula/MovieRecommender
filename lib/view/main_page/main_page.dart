import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_recommender/view/main_page/cubit/bottom_nav_bar_cubit.dart';
import 'package:movie_recommender/view/main_page/widgets/all_movies_tab.dart';
import 'package:movie_recommender/view/main_page/widgets/my_movies_tab.dart';
import 'package:movie_recommender/view/main_page/widgets/my_preferences_tab.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool? isAdmin;

  @override
  void initState() {
    super.initState();
    unawaited(_checkIfAdmin());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavBarCubit, int>(builder: _body);
  }

  Widget _body(BuildContext context, int index) {
    return Scaffold(
      appBar: _appBar(),
      body: isAdmin != null
          ? _tab(index)
          : const Center(
              child: CircularProgressIndicator(),
            ),
      bottomNavigationBar: isAdmin == true
          ? BottomNavigationBar(
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
            )
          : null,
    );
  }

  AppBar _appBar() {
    return AppBar(
      actions: [
        IconButton(
          onPressed: FirebaseAuth.instance.signOut,
          icon: const Icon(Icons.logout),
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
          child: const MyMoviesTab(),
        ),
        Offstage(
          offstage: index != 2,
          child: const MyPreferencesTab(),
        ),
      ],
    );
  }

  Future<void> _checkIfAdmin() async {
    final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .doc('admins')
            .get();
    if (!mounted) return;

    List<String> admins = List<String>.from(snapshot.data()?['listOfIds']);
    String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    isAdmin = admins.contains(uid);
    setState(() {});
  }
}
