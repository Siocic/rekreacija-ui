import 'package:json_annotation/json_annotation.dart';

part 'holiday_model.g.dart';

@JsonSerializable()
class HolidayModel {
  int? id;
  String name;
  DateTime startDate;
  DateTime endDate;

  HolidayModel({
    this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
  });

  factory HolidayModel.fromJson(Map<String, dynamic> json) =>
      _$HolidayModelFromJson(json);

  Map<String, dynamic> toJson() => _$HolidayModelToJson(this);
}
