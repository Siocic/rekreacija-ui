// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_clients_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyClientsModel _$MyClientsModelFromJson(Map<String, dynamic> json) =>
    MyClientsModel(
      json['fullName'] as String?,
      json['email'] as String?,
      json['phoneNumber'] as String?,
      (json['numberOfAppointments'] as num?)?.toInt(),
      json['lastAppointmentDate'] == null
          ? null
          : DateTime.parse(json['lastAppointmentDate'] as String),
    );

Map<String, dynamic> _$MyClientsModelToJson(MyClientsModel instance) =>
    <String, dynamic>{
      'fullName': instance.fullName,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'numberOfAppointments': instance.numberOfAppointments,
      'lastAppointmentDate': instance.lastAppointmentDate?.toIso8601String(),
    };
