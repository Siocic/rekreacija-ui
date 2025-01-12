// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'registration_model.dart';

RegistrationModel _$RegistrationModelFromJson(Map<String, dynamic> json) =>
    RegistrationModel(
      json['firstName'] as String?,
      json['lastName'] as String?,
      json['email'] as String?,
      json['city'] as String?,
      json['address'] as String?,
      json['phoneNumber'] as String?,
      json['password'] as String?,
    );
Map<String, dynamic> _$RegistrationModelToJson(RegistrationModel instance) =>
    <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'city': instance.city,
      'address': instance.address,
      'phoneNumber': instance.phoneNumber,
      'password': instance.password,
    };
