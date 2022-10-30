import 'package:json_annotation/json_annotation.dart';
import 'package:movie_recommender/models/movie_attribute.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final String email;
  final List<MovieAttribute> preferences;

  const User({
    required this.email,
    required this.preferences,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
