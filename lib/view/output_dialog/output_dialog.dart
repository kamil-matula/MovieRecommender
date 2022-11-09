import 'package:flutter/material.dart';
import 'package:movie_recommender/constants/constant_texts.dart';
import 'package:movie_recommender/models/movie.dart';
import 'package:movie_recommender/view/main_page/widgets/movie_item.dart';

class OutputDialog extends StatelessWidget {
  final List<Movie> matchedMovies;

  const OutputDialog({
    Key? key,
    required this.matchedMovies,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        MATCHED_MOVIES,
        textAlign: TextAlign.center,
      ),
      contentPadding: const EdgeInsets.all(10),
      insetPadding: const EdgeInsets.all(15),
      content: SizedBox(
        width: 400,
        height: 445,
        child: ListView.builder(
          itemCount: matchedMovies.length,
          itemBuilder: (_, int index) => MovieItem(
            movie: matchedMovies[index],
            isAdmin: false,
          ),
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(0, 0, 10, 5),
      actions: [
        TextButton(
          onPressed: Navigator.of(context).pop,
          child: const Text(CLOSE),
        ),
      ],
    );
  }
}
