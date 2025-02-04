// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'object_update.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ObjectUpdate _$ObjectUpdateFromJson(Map<String, dynamic> json) => ObjectUpdate(
      json['name'] as String?,
      json['updated_date'] == null
          ? null
          : DateTime.parse(json['updated_date'] as String),
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

Map<String, dynamic> _$ObjectUpdateToJson(ObjectUpdate instance) =>
    <String, dynamic>{
      'name': instance.name,
      'updated_date': instance.updated_date?.toIso8601String(),
      'address': instance.address,
      'city': instance.city,
      'description': instance.description,
      'price': instance.price,
      'user_id': instance.user_id,
      'ObjectImage': instance.ObjectImage,
      'sportId': instance.sportId,
    };
