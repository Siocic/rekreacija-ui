// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sport_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SportCategory _$SportCategoryFromJson(Map<String, dynamic> json) =>
    SportCategory(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
    );

Map<String, dynamic> _$SportCategoryToJson(SportCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };
