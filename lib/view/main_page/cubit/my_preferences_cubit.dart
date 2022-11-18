import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:movie_recommender/constants/movie_attributes.dart';
import 'package:movie_recommender/constants/texts.dart';
import 'package:movie_recommender/core/db/db_service.dart';
import 'package:movie_recommender/models/movie.dart';
import 'package:movie_recommender/models/movie_attribute.dart';
import 'package:movie_recommender/models/user.dart';

/// Cubit which stores list of movies from DB.
class MyPreferencesCubit extends Cubit<User?> {
  StreamSubscription<User?>? _preferencesSub;

  MyPreferencesCubit() : super(null) {
    unawaited(_createUserInDb());
    _preferencesSub = _initPreferencesSubscription();
  }

  /// Initializes user's attributes' listener.
  StreamSubscription<User?> _initPreferencesSubscription() {
    return DbService.watchUserWithPreferences().listen(emit);
  }

  /// Initializes user's objects in DB.
  Future<void> _createUserInDb() async {
    // Get user's object from Firestore Database:
    User? user = await DbService.getUserWithPreferences();
    if (user != null) return;

    // Make sure that user has email:
    String email = auth.FirebaseAuth.instance.currentUser?.email ?? '';
    if (email.isEmpty) return;

    // Save object in Firestore Database:
    user = User(
      email: email,
      preferences: movie_attributes.map((e) => e.copyWith(value: 5)).toList(),
    );
    await DbService.updatePreferences(jsonDecode(jsonEncode(user.toJson())));
  }

  /// Updates user's object in DB.
  Future<void> updateAttribute(User user, int index, int value) async {
    user.preferences[index] = user.preferences[index].copyWith(value: value);
    await DbService.updatePreferences(jsonDecode(jsonEncode(user.toJson())));
  }

  /// Uses kNN to get k nearest movies.
  static Future<List<Movie>> getMatchingMovies(
    User user,
    List<Movie> movies,
  ) async {
    try {
      List<MovieAttribute> userPreferences = user.preferences;

      // Calculate distances:
      Map<int, int> distances = movies
          .map((movie) => _calculateDistance(movie.attributes, userPreferences))
          .toList()
          .asMap();

      // Get K nearest movies:
      int k = movies.length >= 3 ? 3 : movies.length;
      List<Movie> matchingMovies = [];
      List<int> sortedIndexes = Map.fromEntries(
        distances.entries.toList()
          ..sort((e1, e2) => e1.value.compareTo(e2.value)),
      ).keys.toList();
      for (int i = 0; i < k; i++) {
        matchingMovies.add(movies[sortedIndexes[i]]);
      }

      return matchingMovies;
    } catch (_) {
      Fluttertoast.showToast(msg: CONTACT_ADMIN, backgroundColor: Colors.grey);
      return [];
    }
  }

  /// Calculates distance between [Movie]'s attributes
  /// and user's preferences with usage of Manhattan's metric.
  static int _calculateDistance(
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

  @override
  Future<void> close() {
    _preferencesSub?.cancel();
    return super.close();
  }
}
