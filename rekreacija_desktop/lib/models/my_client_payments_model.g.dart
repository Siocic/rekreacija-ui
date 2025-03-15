// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_client_payments_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyClientPaymentsModel _$MyClientPaymentsModelFromJson(
        Map<String, dynamic> json) =>
    MyClientPaymentsModel(
      json['fullName'] as String?,
      json['email'] as String?,
      json['phone'] as String?,
      json['objectName'] as String?,
      (json['amount'] as num?)?.toInt(),
      json['appointmentDate'] == null
          ? null
          : DateTime.parse(json['appointmentDate'] as String),
    );

Map<String, dynamic> _$MyClientPaymentsModelToJson(
        MyClientPaymentsModel instance) =>
    <String, dynamic>{
      'fullName': instance.fullName,
      'email': instance.email,
      'phone': instance.phone,
      'objectName': instance.objectName,
      'amount': instance.amount,
      'appointmentDate': instance.appointmentDate?.toIso8601String(),
    };
