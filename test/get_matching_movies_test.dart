import 'package:flutter_test/flutter_test.dart';
import 'package:movie_recommender/constants/movie_attributes.dart';
import 'package:movie_recommender/models/movie.dart';
import 'package:movie_recommender/models/movie_attribute.dart';
import 'package:movie_recommender/models/user.dart';
import 'package:movie_recommender/view/main_page/cubit/my_preferences_cubit.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  MyPreferencesCubit cubit = MyPreferencesCubit(isTest: true);
  List<List<MovieAttribute>> listOfListsOfMovieAttributes = [];
  List<Movie> movies = [];

  setUp(() {
    List<List<int>> values = [
      [0, 2, 2, 4, 6, 6, 8, 10, 10],
      [0, 1, 1, 3, 5, 5, 7, 0, 0],
      [1, 1, 1, 1, 1, 1, 1, 1, 1],
      [0, 3, 3, 5, 7, 7, 9, 10, 10],
      [1, 1, 1, 1, 1, 1, 1, 1, 1],
      [1, 1, 1, 1, 1, 1, 1, 1, 1],
    ];

    for (int i = 0; i < values.length; i++) {
      List<MovieAttribute> movieAttributes = [];
      for (int j = 0; j < movie_attributes.length; j++) {
        movieAttributes.add(movie_attributes[j].copyWith(value: values[i][j]));
      }
      listOfListsOfMovieAttributes.add(movieAttributes);
    }

    int i = 0;
    movies = listOfListsOfMovieAttributes.map((attributes) {
      i += 1;
      return Movie(
        id: i.toString(),
        title: 'Movie $i',
        director: 'Director $i',
        genre: 'Genre $i',
        year: i,
        attributes: attributes,
      );
    }).toList();
  });

  group('get_matching_movies', () {
    test('should return movies at 0, 3, 1 index', () async {
      User user = User(
        email: 'email@email.com',
        preferences: listOfListsOfMovieAttributes[0],
      );

      List<Movie> result =
          await cubit.getMatchingMovies(user: user, movies: movies);
      expect(result, [movies[0], movies[3], movies[1]]);
    });

    test(
        'entered movies have the same values, so test should return movies at 2, 4, 5 index',
        () async {
      User user = User(
        email: 'email@email.com',
        preferences: movie_attributes.map((e) => e.copyWith(value: 0)).toList(),
      );

      List<Movie> result =
          await cubit.getMatchingMovies(user: user, movies: movies);
      expect(result, [movies[2], movies[4], movies[5]]);
    });

    test('should return empty list', () async {
      User user = User(
        email: 'email@email.com',
        preferences: listOfListsOfMovieAttributes[0],
      );

      List<Movie> result =
          await cubit.getMatchingMovies(user: user, movies: []);
      expect(result, []);
    });

    test('should return list of length 3', () async {
      User user = User(
        email: 'email@email.com',
        preferences: listOfListsOfMovieAttributes[3],
      );

      List<Movie> result = await cubit.getMatchingMovies(
        user: user,
        movies: [movies[2], movies[0], movies[0]],
      );
      expect(result.length, 3);
    });

    test('should return list of length 2', () async {
      User user = User(
        email: 'email@email.com',
        preferences: listOfListsOfMovieAttributes[3],
      );

      List<Movie> result = await cubit.getMatchingMovies(
        user: user,
        movies: [movies[2], movies[0]],
      );
      expect(result.length, 2);
    });

    test('should return list of length 1', () async {
      User user = User(
        email: 'email@email.com',
        preferences: listOfListsOfMovieAttributes[3],
      );

      List<Movie> result = await cubit.getMatchingMovies(
        user: user,
        movies: [movies[2]],
      );
      expect(result.length, 1);
    });

    test('user\'s preferences are empty, so test should return empty list',
        () async {
      User user = const User(
        email: 'email@email.com',
        preferences: [],
      );

      List<Movie> result =
          await cubit.getMatchingMovies(user: user, movies: movies);
      expect(result, []);
    });
  });
}
