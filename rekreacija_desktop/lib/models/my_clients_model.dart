import 'package:json_annotation/json_annotation.dart';

part 'my_clients_model.g.dart';

@JsonSerializable()
class MyClientsModel {
  String? fullName;
  String? email;
  String? phoneNumber;
  int? numberOfAppointments;
  DateTime? lastAppointmentDate;

  MyClientsModel(this.fullName, this.email, this.phoneNumber,
      this.numberOfAppointments, this.lastAppointmentDate);

  factory MyClientsModel.fromJson(Map<String, dynamic> json) =>
      _$MyClientsModelFromJson(json);

  Map<String, dynamic> toJson() => _$MyClientsModelToJson(this);
}
