// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'object_holiday_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ObjectHolidayModel _$ObjectHolidayModelFromJson(Map<String, dynamic> json) =>
    ObjectHolidayModel(
      objectId: (json['objectId'] as num).toInt(),
      holidayId: (json['holidayId'] as num).toInt(),
    );

Map<String, dynamic> _$ObjectHolidayModelToJson(ObjectHolidayModel instance) =>
    <String, dynamic>{
      'objectId': instance.objectId,
      'holidayId': instance.holidayId,
    };
