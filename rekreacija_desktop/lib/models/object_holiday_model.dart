import 'package:json_annotation/json_annotation.dart';

part 'object_holiday_model.g.dart';

@JsonSerializable()
class ObjectHolidayModel {
  int objectId;
  int holidayId;

  ObjectHolidayModel({
    required this.objectId,
    required this.holidayId,
  });

  factory ObjectHolidayModel.fromJson(Map<String, dynamic> json) =>
      _$ObjectHolidayModelFromJson(json);

  Map<String, dynamic> toJson() => _$ObjectHolidayModelToJson(this);
}
