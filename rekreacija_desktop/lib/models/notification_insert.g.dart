// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_insert.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationInsert _$NotificationInsertFromJson(Map<String, dynamic> json) =>
    NotificationInsert(
      json['name'] as String?,
      json['description'] as String?,
      json['created_date'] == null
          ? null
          : DateTime.parse(json['created_date'] as String),
      json['user_id'] as String?,
    );

Map<String, dynamic> _$NotificationInsertToJson(NotificationInsert instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'created_date': instance.created_date?.toIso8601String(),
      'user_id': instance.user_id,
    };
