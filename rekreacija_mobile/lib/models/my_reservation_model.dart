import 'package:json_annotation/json_annotation.dart';

part 'my_reservation_model.g.dart';

@JsonSerializable()
class MyReservationModel {
  String? objectName;
  String? objectAdress;
  String? objectImage;
  DateTime? appointmentDate;

  MyReservationModel(this.objectName, this.objectAdress, this.objectImage,this.appointmentDate);

  factory MyReservationModel.fromJson(Map<String, dynamic> json) => _$MyReservationModelFromJson(json);

  Map<String, dynamic> toJson() => _$MyReservationModelToJson(this);
}