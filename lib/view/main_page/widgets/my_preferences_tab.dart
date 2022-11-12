import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movie_recommender/constants/movie_attributes.dart';
import 'package:movie_recommender/constants/texts.dart';
import 'package:movie_recommender/constants/typography.dart';
import 'package:movie_recommender/models/movie.dart';
import 'package:movie_recommender/models/movie_attribute.dart';
import 'package:movie_recommender/models/user.dart';
import 'package:movie_recommender/view/output_dialog/output_dialog.dart';
import 'package:movie_recommender/view/widgets/custom_button.dart';

class MyPreferencesTab extends StatefulWidget {
  const MyPreferencesTab({Key? key}) : super(key: key);

  @override
  State<MyPreferencesTab> createState() => _MyPreferencesTabState();
}

class _MyPreferencesTabState extends State<MyPreferencesTab> {
  final CollectionReference<Map<String, dynamic>> moviesRef =
      FirebaseFirestore.instance.collection('movies');
  final DocumentReference<Map<String, dynamic>> userRef = FirebaseFirestore
      .instance
      .collection('users')
      .doc(auth.FirebaseAuth.instance.currentUser?.uid ?? '');

  @override
  void initState() {
    super.initState();
    unawaited(_createUserInDb());
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(15),
            child: Text(
              MATCH_MOVIES_HEADER,
              style: CustomTypography.p2Semibold,
              textAlign: TextAlign.center,
            ),
          ),
          StreamBuilder(
            stream: userRef.snapshots(),
            builder: (_, snapshot) {
              Map<String, dynamic>? data = snapshot.data?.data();
              if (data != null) {
                User user = User.fromJson(data);
                return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: user.preferences.length,
                  itemBuilder: (_, index) => _row(user, index),
                );
              }

              // TODO: Add some widgets for other states: error, loading, initial
              return const SizedBox();
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

  Widget _row(User user, int index) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(35, 15, 35, 5),
      child: Column(
        children: [
          SizedBox(
            width: 350,
            child: Text(
              user.preferences[index].description ?? '',
              style: CustomTypography.p2Regular,
            ),
          ),
          RatingBar.builder(
            maxRating: 5,
            allowHalfRating: true,
            initialRating: user.preferences[index].value / 2,
            itemPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            itemBuilder: (_, __) => const Icon(Icons.star, color: Colors.amber),
            onRatingUpdate: (rating) async {
              user.preferences[index] = user.preferences[index].copyWith(
                value: (rating * 2).toInt(),
              );
              userRef.set(jsonDecode(jsonEncode(user.toJson())));
            },
          ),
        ],
      ),
    );
  }

  Future<void> _createUserInDb() async {
    // Prepare data:
    String email = auth.FirebaseAuth.instance.currentUser?.email ?? '';
    List<MovieAttribute> preferences =
        movie_attributes.map((e) => e.copyWith(value: 5)).toList();
    if (email.isEmpty) return;

    // Get user's object from Firestore Database:
    DocumentSnapshot<Map<String, dynamic>> snapshot = await userRef.get();
    if (snapshot.data() != null) return;

    // Save object in Firestore Database:
    User user = User(email: email, preferences: preferences);
    userRef.set(jsonDecode(jsonEncode(user.toJson())));
  }

  /// Uses kNN to get k nearest movies.
  Future<void> _getMatchingMovies() async {
    try {
      // Get user's preferences:
      DocumentSnapshot<Map<String, dynamic>> userSnapshot = await userRef.get();
      List<MovieAttribute> userPreferences =
          User.fromJson(userSnapshot.data()!).preferences;

      // Get movies:
      QuerySnapshot<Map<String, dynamic>> moviesSnapshot =
          await moviesRef.get();
      List<Movie> movies = moviesSnapshot.docs
          .map((movie) => Movie.fromJson(movie.data()))
          .toList();

      // Calculate distances:
      Map<int, int> distances = movies
          .map((movie) => _calculateDistance(movie.attributes, userPreferences))
          .toList()
          .asMap();

      // Get K nearest movies:
      int k = 3;
      List<Movie> matchingMovies = [];
      List<int> sortedIndexes = Map.fromEntries(
        distances.entries.toList()
          ..sort((e1, e2) => e1.value.compareTo(e2.value)),
      ).keys.toList();
      for (int i = 0; i < k; i++) {
        matchingMovies.add(movies[sortedIndexes[i]]);
      }

      showDialog(
        context: context,
        builder: (_) => OutputDialog(matchedMovies: matchingMovies),
      );
    } catch (_) {
      // TODO: Display toast or something
      print('Something went wrong. Please contact administrator');
    }
  }

  /// Calculates distance between [Movie]'s attributes
  /// and user's preferences with usage of Manhattan's metric.
  int _calculateDistance(
    List<MovieAttribute> movieAttributes,
    List<MovieAttribute> userPreferences,
  ) {
    // If there is no attributes, the movie is very far from perfect match:
    if (movieAttributes.isEmpty ||
        movieAttributes.length != userPreferences.length) return 1000;

    // Let's assume that attributes here and in database have the same order:
    int distance = 0;
    for (int i = 0; i < movieAttributes.length; i++) {
      distance += (movieAttributes[i].value - userPreferences[i].value).abs();
    }

    return distance;
  }
}
