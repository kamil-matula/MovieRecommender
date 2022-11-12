import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_recommender/models/movie.dart';
import 'package:movie_recommender/view/main_page/cubit/movies_cubit.dart';
import 'package:movie_recommender/view/main_page/widgets/movie_item.dart';

class ListOfMovies extends StatelessWidget {
  final bool isAdmin;

  const ListOfMovies({
    required this.isAdmin,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MoviesCubit, List<Movie>>(
      builder: (_, movies) {
        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (_, int index) {
            bool isLast = index == movies.length - 1;
            return isLast && isAdmin
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 88.0),
                    child: MovieItem(movie: movies[index], isAdmin: isAdmin),
                  )
                : MovieItem(movie: movies[index], isAdmin: isAdmin);
          },
        );
      },
    );
  }
}
