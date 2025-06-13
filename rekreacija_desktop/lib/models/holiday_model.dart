import 'package:json_annotation/json_annotation.dart';

part 'holiday_model.g.dart';

@JsonSerializable()
class HolidayModel {
  int? id;
  String name;
  @JsonKey(name: 'start_date')
  DateTime startDate;
  @JsonKey(name: 'end_date')
  DateTime endDate;

  HolidayModel({
    this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
  });

  factory HolidayModel.fromJson(Map<String, dynamic> json) {
    return HolidayModel(
      id: json['id'] as int?,
      name: json['name'] ?? '',
      startDate: DateTime.tryParse(json['start_date'] ?? '') ?? DateTime(1970),
      endDate: DateTime.tryParse(json['end_date'] ?? '') ?? DateTime(1970),
    );
  }

  Map<String, dynamic> toJson() => _$HolidayModelToJson(this);
}
