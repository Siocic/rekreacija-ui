// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment_insert_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppointmentInsertModel _$AppointmentInsertModelFromJson(
        Map<String, dynamic> json) =>
    AppointmentInsertModel(
      json['appointment_date'] == null
          ? null
          : DateTime.parse(json['appointment_date'] as String),
      json['start_time'] == null
          ? null
          : DateTime.parse(json['start_time'] as String),
      json['end_time'] == null
          ? null
          : DateTime.parse(json['end_time'] as String),
      (json['object_id'] as num?)?.toInt(),
      json['user_id'] as String?,
      (json['amount'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$AppointmentInsertModelToJson(
        AppointmentInsertModel instance) =>
    <String, dynamic>{
      'appointment_date': instance.appointment_date?.toIso8601String(),
      'start_time': instance.start_time?.toIso8601String(),
      'end_time': instance.end_time?.toIso8601String(),
      'object_id': instance.object_id,
      'user_id': instance.user_id,
      'amount': instance.amount,
    };
