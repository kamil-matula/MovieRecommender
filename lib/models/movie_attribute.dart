import 'package:json_annotation/json_annotation.dart';

part 'movie_attribute.g.dart';

@JsonSerializable()
class MovieAttribute {
  final String name;
  final int value;
  final String? description;

  const MovieAttribute({
    required this.name,
    this.description,
    this.value = 0,
  });

  factory MovieAttribute.fromJson(Map<String, dynamic> json) =>
      _$MovieAttributeFromJson(json);

  Map<String, dynamic> toJson() => _$MovieAttributeToJson(this);

  MovieAttribute copyWith({
    String? name,
    String? description,
    int? value,
  }) {
    return MovieAttribute(
      name: name ?? this.name,
      description: description ?? this.description,
      value: value ?? this.value,
    );
  }
}
