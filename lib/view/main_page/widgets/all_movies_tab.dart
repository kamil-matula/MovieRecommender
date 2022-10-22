import 'package:flutter/material.dart';
import 'package:movie_recommender/models/movie.dart';
import 'package:movie_recommender/view/main_page/widgets/list_of_movies.dart';

class AllMoviesTab extends StatelessWidget {
  AllMoviesTab({Key? key}) : super(key: key);

  final List<Movie> temporaryMovies = [
    Movie(
      'The Lord of the Rings: The Fellowship of the Ring',
      'Peter Jackson',
      'Fantasy',
      2001,
    ),
    Movie(
      'The Lord of the Rings: The Two Towers',
      'Peter Jackson',
      'Fantasy',
      2002,
    ),
    Movie(
      'The Lord of the Rings: The Return of the King',
      'Peter Jackson',
      'Fantasy',
      2003,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListOfMovies(movies: temporaryMovies);
  }
}
