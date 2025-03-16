// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_reservation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyReservationModel _$MyReservationModelFromJson(Map<String, dynamic> json) =>
    MyReservationModel(
      json['objectName'] as String?,
      json['objectAdress'] as String?,
      json['objectImage'] as String?,
      json['appointmentDate'] == null
          ? null
          : DateTime.parse(json['appointmentDate'] as String),
    );

Map<String, dynamic> _$MyReservationModelToJson(MyReservationModel instance) =>
    <String, dynamic>{
      'objectName': instance.objectName,
      'objectAdress': instance.objectAdress,
      'objectImage': instance.objectImage,
      'appointmentDate': instance.appointmentDate?.toIso8601String(),
    };
