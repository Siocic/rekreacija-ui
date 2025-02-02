// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'object_insert.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ObjectInsert _$ObjectInsertFromJson(Map<String, dynamic> json) => ObjectInsert(
      json['name'] as String?,
      json['created_date'] == null
          ? null
          : DateTime.parse(json['created_date'] as String),
      json['address'] as String?,
      json['city'] as String?,
      json['description'] as String?,
      (json['price'] as num?)?.toDouble(),
      json['user_id'] as String?,
      json['ObjectImage'] as String?,
      (json['sportId'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
    );

Map<String, dynamic> _$ObjectInsertToJson(ObjectInsert instance) =>
    <String, dynamic>{
      'name': instance.name,
      'created_date': instance.created_date?.toIso8601String(),
      'address': instance.address,
      'city': instance.city,
      'description': instance.description,
      'price': instance.price,
      'user_id': instance.user_id,
      'ObjectImage': instance.ObjectImage,
      'sportId': instance.sportId,
    };
