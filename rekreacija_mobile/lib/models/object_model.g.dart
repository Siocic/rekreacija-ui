// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'object_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ObjectModel _$ObjectModelFromJson(Map<String, dynamic> json) => ObjectModel(
      (json['id'] as num?)?.toInt(),
      json['name'] as String?,
      json['created_date'] == null
          ? null
          : DateTime.parse(json['created_date'] as String),
      json['updated_date'] == null
          ? null
          : DateTime.parse(json['updated_date'] as String),
      json['address'] as String?,
      json['city'] as String?,
      json['description'] as String?,
      (json['price'] as num?)?.toDouble(),
      json['user_id'] as String?,
      (json['sportsId'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      json['objectImage'] as String?,
      json['imagePath'] as String?,
      (json['rating'] as num?)?.toDouble(),
      json['isFavorites'] as bool?,
    );

Map<String, dynamic> _$ObjectModelToJson(ObjectModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'created_date': instance.created_date?.toIso8601String(),
      'updated_date': instance.updated_date?.toIso8601String(),
      'address': instance.address,
      'city': instance.city,
      'description': instance.description,
      'price': instance.price,
      'user_id': instance.user_id,
      'sportsId': instance.sportsId,
      'objectImage': instance.objectImage,
      'imagePath': instance.imagePath,
      'rating': instance.rating,
      'isFavorites': instance.isFavorites,
    };
