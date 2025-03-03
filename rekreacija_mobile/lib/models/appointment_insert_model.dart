import 'package:json_annotation/json_annotation.dart';

part 'appointment_insert_model.g.dart';

@JsonSerializable()
class AppointmentInsertModel {
  DateTime? appointment_date;
  DateTime? start_time;
  DateTime? end_time;
  int? object_id;
  String? user_id;
  double? amount;

  AppointmentInsertModel(this.appointment_date, this.start_time, this.end_time, this.object_id, this.user_id, this.amount);

  factory AppointmentInsertModel.fromJson(Map<String, dynamic> json) => _$AppointmentInsertModelFromJson(json);

  Map<String, dynamic> toJson() => _$AppointmentInsertModelToJson(this);
}