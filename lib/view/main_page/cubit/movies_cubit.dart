import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movie_recommender/constants/texts.dart';
import 'package:movie_recommender/core/db/db_service.dart';
import 'package:movie_recommender/core/storage/storage_service.dart';
import 'package:movie_recommender/models/movie.dart';
import 'package:movie_recommender/models/movie_attribute.dart';

/// Cubit which stores list of movies from DB.
class MoviesCubit extends Cubit<List<Movie>> {
  StreamSubscription<List<Movie>>? _moviesSub;

  MoviesCubit() : super([]) {
    _moviesSub = _initMoviesSubscription();
  }

  /// Initializes movies-in-db listener.
  StreamSubscription<List<Movie>> _initMoviesSubscription() {
    return DbService.watchListOfMovies().listen(emit);
  }

  /// Adds new movie or overrides existing one.
  Future<bool> addOrEditMovie({
    required String? currentId,
    required String title,
    required String director,
    required int? year,
    required String genre,
    required List<MovieAttribute> attributes,
    required XFile? posterFile,
    required String? currentPosterUrl,
  }) async {
    // TODO: Add better validation (especially for year)
    // Frontend validation:
    if (title.isEmpty || director.isEmpty || year == null) {
      Fluttertoast.showToast(msg: MISSING_DATA, backgroundColor: Colors.grey);
      return false;
    }

    try {
      // Upload poster to Firebase Storage:
      String id = currentId ?? '${title}_$year';
      String? posterUrl = posterFile != null
          ? await StorageService.uploadPoster(id, posterFile)
          : currentPosterUrl;

      // Prepare object:
      Movie movie = Movie(
        id: id,
        title: title,
        director: director,
        genre: genre,
        year: year,
        poster_url: posterUrl,
        attributes: attributes,
      );

      // Save object in Firestore Database:
      await DbService.addMovie(id, jsonDecode(jsonEncode(movie.toJson())));
      return true;
    } catch (_) {
      Fluttertoast.showToast(msg: MISSING_DATA, backgroundColor: Colors.grey);
      return false;
    }
  }

  /// Deletes movie.
  Future<void> deleteMovie(String id) async => DbService.deleteMovie(id);

  @override
  Future<void> close() {
    _moviesSub?.cancel();
    return super.close();
  }
}
