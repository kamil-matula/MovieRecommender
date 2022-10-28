import 'package:json_annotation/json_annotation.dart';
import 'package:movie_recommender/models/movie_attribute.dart';

part 'movie.g.dart';

@JsonSerializable()
class Movie {
  final String title;
  final String director;
  final String genre;
  final int year;
  final String? poster_url;
  final List<MovieAttribute?>? attributes;

  Movie({
    required this.title,
    required this.director,
    required this.genre,
    required this.year,
    this.poster_url,
    this.attributes,
  });

  factory Movie.fromJson(Map<String, dynamic> json) => _$MovieFromJson(json);

  /// Connect the generated [_$MovieToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$MovieToJson(this);
}
