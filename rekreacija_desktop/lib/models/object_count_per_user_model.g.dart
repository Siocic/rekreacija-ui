// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'object_count_per_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ObjectCountPerUserModel _$ObjectCountPerUserModelFromJson(
        Map<String, dynamic> json) =>
    ObjectCountPerUserModel(
      json['userId'] as String?,
      json['fullName'] as String?,
      (json['objectCount'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ObjectCountPerUserModelToJson(
        ObjectCountPerUserModel instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'fullName': instance.fullName,
      'objectCount': instance.objectCount,
    };
