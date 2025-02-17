// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_insert_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReviewInsertModel _$ReviewInsertModelFromJson(Map<String, dynamic> json) =>
    ReviewInsertModel(
      json['comment'] as String?,
      (json['rating'] as num?)?.toDouble(),
      json['created_date'] == null
          ? null
          : DateTime.parse(json['created_date'] as String),
      json['user_id'] as String?,
      (json['object_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ReviewInsertModelToJson(ReviewInsertModel instance) =>
    <String, dynamic>{
      'comment': instance.comment,
      'rating': instance.rating,
      'created_date': instance.created_date?.toIso8601String(),
      'user_id': instance.user_id,
      'object_id': instance.object_id,
    };
