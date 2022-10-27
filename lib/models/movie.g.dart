// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Movie _$MovieFromJson(Map<String, dynamic> json) => Movie(
      title: json['title'] as String,
      director: json['director'] as String,
      genre: json['genre'] as String,
      year: json['year'] as int,
      url: json['url'] as String?,
      attributes: (json['attributes'] as List<dynamic>?)
          ?.map((e) => e == null
              ? null
              : MovieAttribute.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MovieToJson(Movie instance) => <String, dynamic>{
      'title': instance.title,
      'director': instance.director,
      'genre': instance.genre,
      'year': instance.year,
      'url': instance.url,
      'attributes': instance.attributes,
    };
