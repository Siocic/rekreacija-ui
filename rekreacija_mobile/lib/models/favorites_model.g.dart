// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorites_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FavoritesModel _$FavoritesModelFromJson(Map<String, dynamic> json) =>
    FavoritesModel(
      (json['object_id'] as num?)?.toInt(),
      json['user_id'] as String?,
    );

Map<String, dynamic> _$FavoritesModelToJson(FavoritesModel instance) =>
    <String, dynamic>{
      'object_id': instance.object_id,
      'user_id': instance.user_id,
    };
