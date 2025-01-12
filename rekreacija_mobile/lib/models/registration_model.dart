import 'package:json_annotation/json_annotation.dart';

part 'registration_model.g.dart';

@JsonSerializable()
class RegistrationModel {
  String? firstName;
  String? lastName;
  String? email;
  String? city;
  String? address;
  String? phoneNumber;
  String? password; 

  RegistrationModel(this.firstName,this.lastName,this.email,this.city,this.address,this.phoneNumber,this.password);
  factory RegistrationModel.fromJson(Map<String, dynamic> json) => _$RegistrationModelFromJson(json);

  Map<String, dynamic> toJson() => _$RegistrationModelToJson(this);
}
