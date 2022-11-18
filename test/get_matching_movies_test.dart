import 'package:flutter_test/flutter_test.dart';
import 'package:movie_recommender/constants/movie_attributes.dart';
import 'package:movie_recommender/models/movie.dart';
import 'package:movie_recommender/models/movie_attribute.dart';
import 'package:movie_recommender/models/user.dart';
import 'package:movie_recommender/view/main_page/cubit/my_preferences_cubit.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late List<List<MovieAttribute>> preferences;
  List<List<int>> values;
  late User user;
  late List<Movie> movies;

  setUp(() {
    preferences = [
      <MovieAttribute>[],
      <MovieAttribute>[],
      <MovieAttribute>[],
      <MovieAttribute>[],
      <MovieAttribute>[],
      <MovieAttribute>[],
    ];

    values = [
      [0, 2, 2, 4, 6, 6, 8, 10, 10],
      [0, 1, 1, 3, 5, 5, 7, 0, 0],
      [1, 1, 1, 1, 1, 1, 1, 1, 1],
      [0, 3, 3, 5, 7, 7, 9, 10, 10],
      [1, 1, 1, 1, 1, 1, 1, 1, 1],
      [1, 1, 1, 1, 1, 1, 1, 1, 1],
    ];

    for (int j = 0; j < values.length; j++) {
      for (int i = 0; i < movie_attributes.length; i++) {
        preferences[j].add(movie_attributes[i].copyWith(value: values[j][i]));
      }
    }

    movies = preferences
        .map(
          (pref) => Movie(
            id: 'id',
            title: 'title',
            director: 'director',
            genre: 'genre',
            year: 1,
            attributes: pref,
          ),
        )
        .toList();
  });
  group('get_matching_movies', () {
    test('should return movies at 0, 3, 1 index', () async {
      user = User(email: 'email@email.com', preferences: preferences[0]);
      final actual = await MyPreferencesCubit.getMatchingMovies(user, movies);
      expect(
        actual,
        [movies[0], movies[3], movies[1]],
      );
    });

    test('should return movies at 2, 4, 5 index', () async {
      user = User(
        email: 'email@email.com',
        preferences: movie_attributes.map((e) => e.copyWith(value: 0)).toList(),
      );
      final actual = await MyPreferencesCubit.getMatchingMovies(user, movies);
      expect(
        actual,
        [movies[2], movies[4], movies[5]],
      );
    });

    test('should return empty list', () async {
      user = User(email: 'email@email.com', preferences: preferences[0]);
      final actual = await MyPreferencesCubit.getMatchingMovies(user, []);
      expect(actual, []);
    });

    test('should return movies at 0, 2 index', () async {
      user = User(email: 'email@email.com', preferences: preferences[3]);
      final actual = await MyPreferencesCubit.getMatchingMovies(
        user,
        [movies[2], movies[0]],
      );
      expect(actual, [movies[0], movies[2]]);
    });
  });
}
