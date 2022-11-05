import 'package:flutter/material.dart';
import 'package:movie_recommender/view/main_page/widgets/list_of_movies.dart';

class AllMoviesTab extends StatelessWidget {
  const AllMoviesTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ListOfMovies(false);
  }
}
