import 'package:flutter/material.dart';
import 'package:movie_recommender/models/movie.dart';
import 'package:movie_recommender/view/main_page/widgets/movie_item.dart';

class ListOfMovies extends StatelessWidget {
  final List<Movie> movies;

  const ListOfMovies({
    Key? key,
    required this.movies,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: movies.length,
      itemBuilder: (_, int index) => MovieItem(movie: movies[index]),
    );
  }
}
