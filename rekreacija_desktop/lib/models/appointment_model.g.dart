// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppointmentModel _$AppointmentModelFromJson(Map<String, dynamic> json) =>
    AppointmentModel(
      (json['id'] as num?)?.toInt(),
      json['appointment_date'] == null
          ? null
          : DateTime.parse(json['appointment_date'] as String),
      json['start_time'] == null
          ? null
          : DateTime.parse(json['start_time'] as String),
      json['end_time'] == null
          ? null
          : DateTime.parse(json['end_time'] as String),
      json['is_approved'] as bool?,
      (json['object_id'] as num?)?.toInt(),
      json['user_id'] as String?,
      json['object_name'] as String?,
      json['fullname'] as String?,
    );

Map<String, dynamic> _$AppointmentModelToJson(AppointmentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'appointment_date': instance.appointment_date?.toIso8601String(),
      'start_time': instance.start_time?.toIso8601String(),
      'end_time': instance.end_time?.toIso8601String(),
      'is_approved': instance.is_approved,
      'object_id': instance.object_id,
      'user_id': instance.user_id,
      'object_name': instance.object_name,
      'fullname': instance.fullname,
    };
