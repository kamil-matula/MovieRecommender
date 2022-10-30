// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_attribute.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieAttribute _$MovieAttributeFromJson(Map<String, dynamic> json) =>
    MovieAttribute(
      name: json['name'] as String,
      description: json['description'] as String?,
      value: json['value'] as int? ?? 0,
    );

Map<String, dynamic> _$MovieAttributeToJson(MovieAttribute instance) =>
    <String, dynamic>{
      'name': instance.name,
      'value': instance.value,
      'description': instance.description,
    };
