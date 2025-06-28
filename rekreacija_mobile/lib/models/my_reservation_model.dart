import 'package:json_annotation/json_annotation.dart';

part 'my_reservation_model.g.dart';

@JsonSerializable()
class MyReservationModel {
  String? objectName;
  String? objectAdress;
  String? objectImage;
  DateTime? appointmentDate;
  bool? is_approved;
  DateTime? appointmentStartDate;
  DateTime? appointmentEndDate;
  int? number_of_players;
  double? price;

  MyReservationModel(
      this.objectName,
      this.objectAdress,
      this.objectImage,
      this.appointmentDate,
      this.is_approved,
      this.appointmentStartDate,
      this.appointmentEndDate,
      this.number_of_players,
      this.price);

  factory MyReservationModel.fromJson(Map<String, dynamic> json) =>
      _$MyReservationModelFromJson(json);

  Map<String, dynamic> toJson() => _$MyReservationModelToJson(this);
}
