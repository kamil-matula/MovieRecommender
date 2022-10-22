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
      null,
    ),
    Movie(
      'The Lord of the Rings: The Two Towers',
      'Peter Jackson',
      'Fantasy',
      2002,
      'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/640px-Image_created_with_a_mobile_phone.png',
    ),
    Movie(
      'The Lord of the Rings: The Return of the King',
      'Peter Jackson',
      'Fantasy',
      2003,
      null,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListOfMovies(movies: temporaryMovies);
  }
}
