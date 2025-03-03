import 'package:json_annotation/json_annotation.dart';

part 'appointment_model.g.dart';

@JsonSerializable()
class AppointmentModel {
  int? id;
  DateTime? appointment_date;
  DateTime? start_time;
  DateTime? end_time;
  bool? is_approved;
  int? object_id;

  AppointmentModel(this.id, this.appointment_date, this.start_time, this.end_time, this.is_approved, this.object_id);


  factory AppointmentModel.fromJson(Map<String, dynamic> json) => _$AppointmentModelFromJson(json);

  Map<String, dynamic> toJson() => _$AppointmentModelToJson(this);
}