import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movie_recommender/constants/constant_movie_attributes.dart';
import 'package:movie_recommender/constants/constant_texts.dart';
import 'package:movie_recommender/constants/constant_typography.dart';
import 'package:movie_recommender/models/movie.dart';
import 'package:movie_recommender/models/movie_attribute.dart';
import 'package:movie_recommender/view/widgets/custom_button.dart';

class MyPreferencesTab extends StatefulWidget {
  const MyPreferencesTab({Key? key}) : super(key: key);

  @override
  State<MyPreferencesTab> createState() => _MyPreferencesTabState();
}

class _MyPreferencesTabState extends State<MyPreferencesTab> {
  final List<MovieAttribute> _userPreferences =
      movie_attributes.map((e) => e.copyWith(value: 5)).toList();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(15),
            child: Text(
              MATCH_MOVIES_HEADER,
              style: MOVIE_TITLE_STYLE,
            ),
          ),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: _userPreferences.length,
            itemBuilder: (_, index) {
              return _row(index);
            },
          ),
          Padding(
            padding: const EdgeInsets.all(25),
            child: SizedBox(
              width: 200,
              child: CustomButton(
                text: MATCH_MOVIES,
                onPressed: _getMatchingMovies,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _row(int index) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(35, 15, 35, 5),
      child: Column(
        children: [
          SizedBox(
            width: 350,
            child: Text(
              _userPreferences[index].description ?? '',
              style: MOVIE_PREFERENCE_STYLE,
            ),
          ),
          RatingBar.builder(
            maxRating: 5,
            allowHalfRating: true,
            initialRating: 2.5,
            itemPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            itemBuilder: (_, __) => const Icon(Icons.star, color: Colors.amber),
            onRatingUpdate: (rating) {
              _userPreferences[index] = _userPreferences[index].copyWith(
                value: (rating * 2).toInt(),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _getMatchingMovies() async {
    // Get movies:
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('movies').get();
    List<Movie> movies =
        snapshot.docs.map((movie) => Movie.fromJson(movie.data())).toList();

    // Calculate distances:
    Map<int, int> distances =
        movies.map((movie) => _calculateDistance(movie)).toList().asMap();

    // Get K nearest movies:
    int k = 2;
    List<Movie> matchingMovies = [];
    List<int> sortedIndexes = Map.fromEntries(
      distances.entries.toList()
        ..sort((e1, e2) => e1.value.compareTo(e2.value)),
    ).keys.toList();
    for (int i = 0; i < k; i++) {
      matchingMovies.add(movies[sortedIndexes[i]]);
    }

    // TODO: Do something with the matchingMovies (display in new dialog?)
    print(matchingMovies.map((m) => m.title));
  }

  /// Calculates distance between [Movie]'s attributes
  /// and user's preferences with usage of Manhattan's metric.
  int _calculateDistance(Movie movie) {
    // If there is no attributes, the movie is very far from perfect match:
    if (movie.attributes == null) return 1000;
    List<MovieAttribute> movieAttributes = movie.attributes!;

    // Let's assume that attributes here and in database have the same order:
    int distance = 0;
    for (int i = 0; i < movieAttributes.length; i++) {
      distance += (movieAttributes[i].value - _userPreferences[i].value).abs();
    }

    return distance;
  }
}
