import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_recommender/view/main_page/cubit/movies_cubit.dart';
import 'package:movie_recommender/view/main_page/widgets/list_of_movies.dart';
import 'package:movie_recommender/view/movie_dialog/movie_dialog.dart';

class AdminMoviesTab extends StatelessWidget {
  final AppBar appBar;

  const AdminMoviesTab({
    Key? key,
    required this.appBar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: const ListOfMovies(isAdmin: true),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          showDialog(
            context: context,
            builder: (_) => BlocProvider.value(
              value: context.read<MoviesCubit>(),
              child: const MovieDialog(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
