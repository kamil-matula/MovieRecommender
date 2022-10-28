import 'package:json_annotation/json_annotation.dart';

part 'movie_attribute.g.dart';

@JsonSerializable()
class MovieAttribute {
  final String name;
  int value;

  MovieAttribute({
    required this.name,
    this.value = 0,
  });

  factory MovieAttribute.fromJson(Map<String, dynamic> json) =>
      _$MovieAttributeFromJson(json);

  Map<String, dynamic> toJson() => _$MovieAttributeToJson(this);
}
