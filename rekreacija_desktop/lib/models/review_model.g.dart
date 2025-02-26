// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReviewModel _$ReviewModelFromJson(Map<String, dynamic> json) => ReviewModel(
      (json['id'] as num?)?.toInt(),
      json['comment'] as String?,
      (json['rating'] as num?)?.toDouble(),
      json['created_date'] == null
          ? null
          : DateTime.parse(json['created_date'] as String),
      json['user_id'] as String?,
      (json['object_id'] as num?)?.toInt(),
      json['user'] == null
          ? null
          : UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ReviewModelToJson(ReviewModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'comment': instance.comment,
      'rating': instance.rating,
      'created_date': instance.created_date?.toIso8601String(),
      'user_id': instance.user_id,
      'object_id': instance.object_id,
      'user': instance.user,
    };
