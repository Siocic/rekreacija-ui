import 'package:json_annotation/json_annotation.dart';

part 'my_client_payments_model.g.dart';

@JsonSerializable()
class MyClientPaymentsModel {
  String? fullName;
  String? email;
  String? phone;
  String? objectName;
  int? amount;
  DateTime? appointmentDate;

  MyClientPaymentsModel(this.fullName, this.email, this.phone,this.objectName, this.amount, this.appointmentDate);

  factory MyClientPaymentsModel.fromJson(Map<String, dynamic> json) => _$MyClientPaymentsModelFromJson(json);

  Map<String, dynamic> toJson() => _$MyClientPaymentsModelToJson(this);

}