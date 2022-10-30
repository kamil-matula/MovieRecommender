// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Movie _$MovieFromJson(Map<String, dynamic> json) => Movie(
      id: json['id'] as String,
      title: json['title'] as String,
      director: json['director'] as String,
      genre: json['genre'] as String,
      year: json['year'] as int,
      poster_url: json['poster_url'] as String?,
      attributes: (json['attributes'] as List<dynamic>?)
          ?.map((e) => MovieAttribute.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MovieToJson(Movie instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'director': instance.director,
      'genre': instance.genre,
      'year': instance.year,
      'poster_url': instance.poster_url,
      'attributes': instance.attributes,
    };
