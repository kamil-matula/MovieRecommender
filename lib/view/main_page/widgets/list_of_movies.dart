import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movie_recommender/models/movie.dart';
import 'package:movie_recommender/view/main_page/widgets/movie_item.dart';

class ListOfMovies extends StatelessWidget {
  const ListOfMovies({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('movies').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Movie> movies = snapshot.data!.docs
              .map((el) => Movie.fromJson(el.data()))
              .toList();
          return ListView.builder(
            itemCount: movies.length,
            itemBuilder: (_, int index) => MovieItem(movie: movies[index]),
          );
        }

        // TODO: Add some widgets for other states: error, loading, initial
        return const SizedBox();
      },
    );
  }
}
