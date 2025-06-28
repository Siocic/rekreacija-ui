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
      json['is_approved'] as bool?,
      json['appointmentStartDate'] == null
          ? null
          : DateTime.parse(json['appointmentStartDate'] as String),
      json['appointmentEndDate'] == null
          ? null
          : DateTime.parse(json['appointmentEndDate'] as String),
      (json['number_of_players'] as num?)?.toInt(),
      (json['price'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$MyReservationModelToJson(MyReservationModel instance) =>
    <String, dynamic>{
      'objectName': instance.objectName,
      'objectAdress': instance.objectAdress,
      'objectImage': instance.objectImage,
      'appointmentDate': instance.appointmentDate?.toIso8601String(),
      'is_approved': instance.is_approved,
      'appointmentStartDate': instance.appointmentStartDate?.toIso8601String(),
      'appointmentEndDate': instance.appointmentEndDate?.toIso8601String(),
      'number_of_players': instance.number_of_players,
      'price': instance.price,
    };
