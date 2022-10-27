import 'package:movie_recommender/models/movie_attributes.dart';

class Movie {
  final String title;
  final String director;
  final String genre;
  final int year;
  final String? url;
  final MovieAttributes? attributes;

  Movie({
    required this.title,
    required this.director,
    required this.genre,
    required this.year,
    this.url,
    this.attributes,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'director': director,
      'genre': genre,
      'year': year,
      'url': url,
      'attributes': attributes,
    };
  }

  factory Movie.fromJson(Map<String, dynamic> map) {
    return Movie(
      title: map['title'] as String,
      director: map['director'] as String,
      genre: map['genre'] as String,
      year: map['year'] as int,
      url: map['url'] as String,
      attributes: map['attributes'] as MovieAttributes,
    );
  }
}
