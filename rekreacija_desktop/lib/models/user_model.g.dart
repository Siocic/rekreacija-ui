// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      json['firstName'] as String?,
      json['lastName'] as String?,
      json['email'] as String?,
      json['address'] as String?,
      json['city'] as String?,
      json['phoneNumber'] as String?,
      json['profilePicture'] as String?,
    )..Id = json['Id'] as String?;

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'Id': instance.Id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'address': instance.address,
      'city': instance.city,
      'phoneNumber': instance.phoneNumber,
      'profilePicture': instance.profilePicture,
    };
